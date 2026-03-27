import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';
import '../../widgets/loading/loading_indicator.dart';

/// 스플래시 화면
///
/// 앱 시작 시 로딩 화면 표시 및 인증 상태 확인
/// - 로그인 완료: 홈 화면으로 이동 (TODO: Phase 2)
/// - 미로그인: 온보딩 화면으로 이동
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 페이드 인 애니메이션 설정
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // 인증 상태 확인 및 라우팅
    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 최소 2초 대기 (로고 표시)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 인증 상태 확인
    final authState = ref.read(authProvider);

    if (authState.isAuthenticated) {
      // 로그인된 경우
      // TODO: Phase 2에서 홈 화면으로 변경
      // context.go('/home');

      // 임시: 다시 스플래시 표시 (개발 중)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인 완료! (홈 화면은 Phase 2에서 구현 예정)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // 미로그인: 온보딩 화면으로
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 아이콘
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.textPrimary.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 64,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: 32),

              // 앱 이름
              Text(
                'Bible SumOne',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      letterSpacing: -0.5,
                    ),
              ),

              const SizedBox(height: 8),

              // 태그라인
              Text(
                '함께하는 말씀 나눔',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary.withValues(alpha: 0.8),
                    ),
              ),

              const SizedBox(height: 48),

              // 로딩 인디케이터
              const LoadingIndicator(
                size: 32,
                color: AppTheme.surfaceColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
