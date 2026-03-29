import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/constants/supabase_client.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';
import '../../widgets/loading/loading_indicator.dart';

/// 스플래시 화면
///
/// 앱 시작 시 로딩 화면 표시 및 인증 상태 확인
/// - 로그인 완료: 홈 화면으로 이동
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
      // 로그인된 경우: 프로필 완료 여부 체크
      final userId = authState.user?.id;
      if (userId != null) {
        final isProfileCompleted = await _checkProfileCompleted(userId);

        if (mounted) {
          if (isProfileCompleted) {
            // 프로필 완료: 홈 화면으로
            context.go('/home');
          } else {
            // 프로필 미완료: 프로필 설정 화면으로
            context.go('/profile-setup');
          }
        }
      } else {
        // userId가 null인 경우 (비정상): 온보딩으로
        if (mounted) {
          context.go('/onboarding');
        }
      }
    } else {
      // 미로그인: 온보딩 화면으로
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  /// 프로필 완료 여부 확인
  ///
  /// public.users 테이블에서 name, birth_date, relationship_stage가
  /// 모두 설정되어 있으면 프로필 완료로 판단
  Future<bool> _checkProfileCompleted(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select('name, birth_date, relationship_stage')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // 레코드 없음: 프로필 미완료
        return false;
      }

      // 필수 필드 체크
      final name = response['name'] as String?;
      final birthDate = response['birth_date'] as String?;
      final relationshipStage = response['relationship_stage'] as String?;

      // 모두 설정되어 있으면 프로필 완료
      return name != null &&
          name.isNotEmpty &&
          birthDate != null &&
          relationshipStage != null;
    } catch (e) {
      // 에러 발생 시 안전하게 프로필 설정 화면으로
      return false;
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
              const LoadingIndicator(size: 32, color: AppTheme.surfaceColor),
            ],
          ),
        ),
      ),
    );
  }
}
