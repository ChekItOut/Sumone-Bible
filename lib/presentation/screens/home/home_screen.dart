import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/logger.dart';
import '../../providers/auth_provider.dart';
import '../../providers/couple_provider.dart';
import '../../providers/couple_state.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/base_card.dart';
import '../../widgets/loading/loading_indicator.dart';
import '../couple/widgets/couple_status_card.dart';

/// 홈 화면
///
/// 온보딩 완료 후 최초 진입 화면
/// 커플 상태 및 오늘의 말씀을 표시
/// 참조: docs/prd.md 섹션 7.4
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 첫 프레임 렌더링 후 커플 정보 로드
    // NOTE: AuthProvider의 checkAuthStatus()가 완료될 때까지 대기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCoupleData();
    });
  }

  /// 커플 정보 로드
  Future<void> _loadCoupleData() async {
    final authState = ref.read(authProvider);

    // AuthProvider 로딩 중이면 대기
    if (authState.isLoading) {
      logger.debug('HomeScreen: AuthProvider 초기화 대기 중...');
      return;
    }

    final user = authState.user;

    if (user != null) {
      logger.info('HomeScreen: 커플 정보 로드 시작 (user_id: ${user.id})');
      await ref.read(coupleProvider.notifier).loadCouple(user.id);
    } else {
      // 이 경고가 나타나면 안 됨 (SplashScreen에서 이미 체크함)
      logger.error('HomeScreen: 사용자가 로그인되어 있지 않음! 라우팅 오류 가능성');
      // 안전하게 온보딩으로 리다이렉트
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final coupleState = ref.watch(coupleProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Bible SumOne'),
        centerTitle: true,
        actions: [
          // 커플 관리 버튼 (커플 연결 시에만 표시)
          if (coupleState.isConnected)
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => context.push('/couple/manage'),
              tooltip: '커플 관리',
            ),
          // 설정 버튼 (임시, Phase 5 예정)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Phase 5 - 설정 화면 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('설정 화면은 Phase 5에서 구현 예정입니다')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCoupleData,
          child: coupleState.isLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 환영 메시지
                      Text(
                        '안녕하세요, ${authState.user?.name ?? '사용자'}님! 👋',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // 커플 상태 섹션
                      _buildCoupleStatusSection(context, coupleState),
                      const SizedBox(height: 24),

                      // 오늘의 말씀 섹션 (Placeholder)
                      _buildDailyVerseSection(context),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// 커플 상태 섹션
  Widget _buildCoupleStatusSection(
    BuildContext context,
    CoupleState coupleState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '커플 상태',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        if (coupleState.isConnected)
          // 연결됨: CoupleStatusCard 위젯 재사용
          Column(
            children: [
              CoupleStatusCard(
                couple: coupleState.couple!,
                onManageTap: () => context.push('/couple/manage'),
              ),
              // 플랜 미설정 시 안내 및 버튼 추가
              if (!coupleState.couple!.hasPlan) ...[
                const SizedBox(height: 16),
                BaseCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 48,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '함께 읽을 플랜을 설정하세요',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '성경 읽기 플랜을 설정하면\n매일 새로운 말씀을 받아볼 수 있습니다',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          text: '플랜 설정하기',
                          onPressed: () => context.push('/couple/plan'),
                          icon: Icons.book,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          )
        else
          // 미연결: 초대 버튼
          _buildCoupleNotConnectedCard(context),
      ],
    );
  }

  /// 커플 미연결 카드
  Widget _buildCoupleNotConnectedCard(BuildContext context) {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '아직 파트너와 연결되지 않았습니다',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '파트너를 초대하여 함께 성경을 읽어보세요',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: '파트너 초대하기',
              onPressed: () => context.push('/couple/invite'),
              icon: Icons.send,
            ),
          ],
        ),
      ),
    );
  }

  /// 오늘의 말씀 섹션 (Placeholder)
  Widget _buildDailyVerseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘의 말씀',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BaseCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Phase 2에서 구현 예정',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '커플과 함께 읽을 플랜을 설정하면\n매일 새로운 말씀이 도착합니다',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
