import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

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
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),

      // ==================== 인증 ====================
      // TODO: Phase 1에서 구현 예정
      // GoRoute(
      //   path: '/auth/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginScreen(),
      // ),

      // ==================== 온보딩 ====================
      // TODO: Phase 1에서 구현 예정
      // GoRoute(
      //   path: '/onboarding',
      //   name: 'onboarding',
      //   builder: (context, state) => const OnboardingScreen(),
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
