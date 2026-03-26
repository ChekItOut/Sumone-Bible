import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/onboarding/profile_setup_screen.dart';
import '../presentation/screens/_test/holy_fire_test_screen.dart'; // 테스트용

/// Bible SumOne 앱 라우팅 설정
///
/// GoRouter를 사용하여 선언적 라우팅 구현
/// 참조: docs/roadmap.md 섹션 1.1
class AppRouter {
  /// GoRouter 인스턴스
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      // ==================== 스플래시 ====================
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ==================== 온보딩 ====================
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // ==================== 인증 ====================
      // TODO: Phase 1에서 구현 예정
      // GoRoute(
      //   path: '/auth/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginScreen(),
      // ),

      // ==================== 홈 ====================
      // TODO: Phase 2에서 구현 예정
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const HomeScreen(),
      // ),

      // ==================== 말씀 ====================
      // TODO: Phase 2에서 구현 예정
      // GoRoute(
      //   path: '/verse/daily',
      //   name: 'daily_verse',
      //   builder: (context, state) => const DailyVerseScreen(),
      // ),

      // ==================== 답변 ====================
      // TODO: Phase 3에서 구현 예정
      // GoRoute(
      //   path: '/response/:verseId',
      //   name: 'response',
      //   builder: (context, state) {
      //     final verseId = state.pathParameters['verseId']!;
      //     return ResponseScreen(verseId: verseId);
      //   },
      // ),

      // ==================== 설정 ====================
      // TODO: Phase 6에서 구현 예정
      // GoRoute(
      //   path: '/settings',
      //   name: 'settings',
      //   builder: (context, state) => const SettingsScreen(),
      // ),

      // ==================== 테스트 ====================
      // NOTE: 테스트용 라우트 - 프로덕션에서는 제거 예정
      GoRoute(
        path: '/holy-fire-test',
        name: 'holy-fire-test',
        builder: (context, state) => const HolyFireTestScreen(),
      ),
    ],

    // 에러 페이지
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}
