import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/logger.dart';
import '../../providers/auth_provider.dart';
import '../../providers/couple_provider.dart';
import '../../providers/couple_state.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/loading/loading_indicator.dart';
import 'widgets/couple_status_card.dart';
import 'widgets/disconnect_dialog.dart';

/// 커플 관리 화면
///
/// 커플 상태 확인 및 관리 기능 제공
/// - 커플 정보 표시
/// - 플랜 변경
/// - 파트너 연결 해제
/// 참조: docs/roadmap.md Task 1.3
class CoupleManagementScreen extends ConsumerStatefulWidget {
  const CoupleManagementScreen({super.key});

  @override
  ConsumerState<CoupleManagementScreen> createState() =>
      _CoupleManagementScreenState();
}

class _CoupleManagementScreenState
    extends ConsumerState<CoupleManagementScreen> {
  @override
  void initState() {
    super.initState();
    _loadCoupleData();
  }

  /// 커플 정보 로드
  Future<void> _loadCoupleData() async {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (user != null) {
      await ref.read(coupleProvider.notifier).loadCouple(user.id);
    }
  }

  /// 플랜 변경 화면으로 이동
  void _navigateToPlanScreen() {
    final coupleState = ref.read(coupleProvider);
    final couple = coupleState.couple;

    if (couple != null) {
      context.push('/couple/plan');
    }
  }

  /// 파트너 연결 해제
  Future<void> _disconnectCouple() async {
    final coupleState = ref.read(coupleProvider);
    final authState = ref.read(authProvider);

    final couple = coupleState.couple;
    final user = authState.user;

    if (couple == null || user == null) {
      logger.warning('CoupleManagementScreen: 커플 또는 사용자 정보 없음');
      return;
    }

    // 확인 다이얼로그 표시
    final confirmed = await DisconnectDialog.show(context);

    if (confirmed == true) {
      logger.info('CoupleManagementScreen: 연결 해제 확인됨');

      // 연결 해제 실행
      await ref
          .read(coupleProvider.notifier)
          .disconnectCouple(coupleId: couple.coupleId, userId: user.id);

      if (mounted) {
        // 성공 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('파트너와의 연결이 해제되었습니다'),
            backgroundColor: Colors.orange,
          ),
        );

        // 홈 화면으로 이동
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coupleState = ref.watch(coupleProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: '커플 관리', showBackButton: true),
      body: SafeArea(
        child: coupleState.isLoading
            ? const Center(child: LoadingIndicator())
            : RefreshIndicator(
                onRefresh: _loadCoupleData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: coupleState.isConnected
                      ? _buildConnectedView(context, coupleState)
                      : _buildNotConnectedView(context),
                ),
              ),
      ),
    );
  }

  /// 연결된 상태 UI
  Widget _buildConnectedView(BuildContext context, CoupleState coupleState) {
    final couple = coupleState.couple!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 커플 상태 카드
        CoupleStatusCard(couple: couple),
        const SizedBox(height: 24),

        // 플랜 변경 버튼
        PrimaryButton(
          text: couple.hasPlan ? 'Daily Verse 플랜 변경' : 'Daily Verse 플랜 설정',
          onPressed: _navigateToPlanScreen,
          icon: Icons.edit,
        ),
        const SizedBox(height: 12),

        // 파트너 해제 버튼
        SecondaryButton(
          text: '파트너 해제',
          onPressed: _disconnectCouple,
          icon: Icons.link_off,
          isDestructive: true,
        ),
      ],
    );
  }

  /// 연결되지 않은 상태 UI
  Widget _buildNotConnectedView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Icon(Icons.people_outline, size: 120, color: Colors.grey[300]),
        const SizedBox(height: 24),
        Text(
          '파트너와 연결되지 않았습니다',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          '파트너를 초대하여\n함께 성경을 읽어보세요',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: PrimaryButton(
            text: '파트너 초대하기',
            onPressed: () => context.push('/couple/invite'),
            icon: Icons.send,
          ),
        ),
      ],
    );
  }
}
