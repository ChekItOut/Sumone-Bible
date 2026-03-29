import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/logger.dart';
import '../../providers/auth_provider.dart';
import '../../providers/couple_provider.dart';
import '../../providers/couple_state.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/text_button_custom.dart';
import '../../widgets/cards/base_card.dart';
import '../../widgets/loading/loading_indicator.dart';

/// 초대 수락 화면 (딥링크 진입)
///
/// 초대 링크를 통해 진입하여 커플 연결 수락
/// 참조: docs/roadmap.md Task 1.3
class ConnectCoupleScreen extends ConsumerStatefulWidget {
  final String token;

  const ConnectCoupleScreen({super.key, required this.token});

  @override
  ConsumerState<ConnectCoupleScreen> createState() =>
      _ConnectCoupleScreenState();
}

class _ConnectCoupleScreenState extends ConsumerState<ConnectCoupleScreen> {
  bool _isAccepting = false;

  /// 초대 수락
  Future<void> _acceptInvite() async {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (user == null) {
      logger.warning('ConnectCoupleScreen: 사용자 정보 없음');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('먼저 로그인해주세요'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/onboarding');
      }
      return;
    }

    setState(() {
      _isAccepting = true;
    });

    try {
      await ref
          .read(coupleProvider.notifier)
          .acceptInvite(token: widget.token, accepterId: user.id);

      final coupleState = ref.read(coupleProvider);

      if (mounted) {
        if (coupleState.hasError) {
          // 에러 처리
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(coupleState.error!),
              backgroundColor: Colors.red,
            ),
          );
        } else if (coupleState.isConnected) {
          // 성공: 플랜 설정 화면으로 이동
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('파트너와 연결되었습니다! 이제 플랜을 설정해주세요.'),
              backgroundColor: Colors.green,
            ),
          );

          context.go('/couple/plan');
        }
      }
    } catch (e) {
      logger.error('ConnectCoupleScreen: 초대 수락 실패 - $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('초대 수락에 실패했습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAccepting = false;
        });
      }
    }
  }

  /// 거절 (홈으로 이동)
  void _decline() {
    logger.info('ConnectCoupleScreen: 초대 거절');
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '파트너 초대', showBackButton: false),
      body: SafeArea(
        child: _isAccepting
            ? const Center(child: LoadingIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // 초대 정보 카드
                    BaseCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 80,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '함께 성경을 읽자는\n초대를 받았어요',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '파트너와 함께 매일 성경을 읽고\n서로의 소감을 나눌 수 있습니다.',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // 초대 링크 정보
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.blue[700],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '초대 토큰',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.blue[900]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.token.substring(0, 16) + '...',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontFamily: 'monospace',
                                          color: Colors.blue[800],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 수락 버튼
                    PrimaryButton(
                      text: '수락하기',
                      onPressed: _acceptInvite,
                      icon: Icons.check_circle,
                    ),
                    const SizedBox(height: 12),

                    // 거절 버튼
                    TextButtonCustom(text: '거절하기', onPressed: _decline),
                  ],
                ),
              ),
      ),
    );
  }
}
