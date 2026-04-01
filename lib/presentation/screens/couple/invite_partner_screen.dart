import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/logger.dart';
import '../../providers/auth_provider.dart';
import '../../providers/couple_provider.dart';
import '../../providers/couple_state.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/cards/base_card.dart';
import '../../widgets/loading/loading_indicator.dart';

/// 파트너 초대 화면
///
/// 초대 링크 생성 및 공유 기능 제공
/// 참조: docs/roadmap.md Task 1.3
class InvitePartnerScreen extends ConsumerStatefulWidget {
  const InvitePartnerScreen({super.key});

  @override
  ConsumerState<InvitePartnerScreen> createState() =>
      _InvitePartnerScreenState();
}

class _InvitePartnerScreenState extends ConsumerState<InvitePartnerScreen> {
  /// 초대 링크 생성
  Future<void> _createInviteLink() async {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (user == null) {
      logger.warning('InvitePartnerScreen: 사용자 정보 없음');
      return;
    }

    await ref.read(coupleProvider.notifier).createInviteLink(user.id);

    // 에러 확인
    final coupleState = ref.read(coupleProvider);
    if (coupleState.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(coupleState.error!),
          backgroundColor: Colors.red,
        ),
      );
    } else if (coupleState.hasInviteLink && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('초대 링크가 생성되었습니다'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// 초대 링크 공유
  Future<void> _shareInviteLink() async {
    final coupleState = ref.read(coupleProvider);
    final inviteLink = coupleState.inviteLink;

    if (inviteLink == null) {
      logger.warning('InvitePartnerScreen: 초대 링크 없음');
      return;
    }

    // 딥링크 스킴 사용: biblesumone://couple/connect/{token}
    const baseUrl = 'biblesumone://couple';
    final fullUrl = inviteLink.getFullUrl(baseUrl);

    try {
      await Share.share(
        '💖 Bible SumOne 초대\n\n'
        '함께 성경을 읽고 나눌 파트너가 되어주세요!\n\n'
        '초대 링크: $fullUrl\n\n'
        '링크는 7일간 유효합니다.',
        subject: 'Bible SumOne 초대',
      );

      logger.info('InvitePartnerScreen: 초대 링크 공유 성공');
    } catch (e) {
      logger.error('InvitePartnerScreen: 초대 링크 공유 실패 - $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('공유에 실패했습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 초대 링크 복사
  Future<void> _copyInviteLink() async {
    final coupleState = ref.read(coupleProvider);
    final inviteLink = coupleState.inviteLink;

    if (inviteLink == null) {
      logger.warning('InvitePartnerScreen: 초대 링크 없음');
      return;
    }

    // 딥링크 스킴 사용: biblesumone://couple/connect/{token}
    const baseUrl = 'biblesumone://couple';
    final fullUrl = inviteLink.getFullUrl(baseUrl);

    try {
      await Clipboard.setData(ClipboardData(text: fullUrl));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('링크가 복사되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }

      logger.info('InvitePartnerScreen: 초대 링크 복사 성공');
    } catch (e) {
      logger.error('InvitePartnerScreen: 초대 링크 복사 실패 - $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final coupleState = ref.watch(coupleProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: '파트너 초대', showBackButton: true),
      body: SafeArea(
        child: coupleState.isLoading
            ? const Center(child: LoadingIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 설명 섹션
                    _buildDescriptionSection(context),
                    const SizedBox(height: 24),

                    if (!coupleState.hasInviteLink)
                      // 초대 링크 생성 버튼
                      _buildCreateLinkButton()
                    else
                      // 생성된 링크 표시 및 공유 버튼
                      _buildInviteLinkSection(context, coupleState),
                  ],
                ),
              ),
      ),
    );
  }

  /// 설명 섹션
  Widget _buildDescriptionSection(BuildContext context) {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.people, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              '파트너와 함께 시작하세요',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '초대 링크를 생성하여 파트너와 공유하세요.\n'
              '함께 성경을 읽고 나눌 수 있습니다.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[800], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '초대 링크는 7일간 유효합니다',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 초대 링크 생성 버튼
  Widget _buildCreateLinkButton() {
    return PrimaryButton(
      text: '초대 링크 생성',
      onPressed: _createInviteLink,
      icon: Icons.add_link,
    );
  }

  /// 생성된 초대 링크 섹션
  Widget _buildInviteLinkSection(
    BuildContext context,
    CoupleState coupleState,
  ) {
    final inviteLink = coupleState.inviteLink!;
    // 딥링크 스킴 사용: biblesumone://couple/connect/{token}
    const baseUrl = 'biblesumone://couple';
    final fullUrl = inviteLink.getFullUrl(baseUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 링크 표시 카드
        BaseCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.link, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      '초대 링크',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    fullUrl,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '유효 기간: ${inviteLink.daysUntilExpiry}일 남음',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 공유 버튼
        PrimaryButton(
          text: '공유하기',
          onPressed: _shareInviteLink,
          icon: Icons.share,
        ),
        const SizedBox(height: 12),

        // 링크 복사 버튼
        SecondaryButton(
          text: '링크 복사',
          onPressed: _copyInviteLink,
          icon: Icons.copy,
        ),
      ],
    );
  }
}
