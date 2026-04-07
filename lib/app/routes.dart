import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/_test/holy_fire_test_screen.dart';
import '../presentation/screens/couple/connect_couple_screen.dart';
import '../presentation/screens/couple/couple_management_screen.dart';
import '../presentation/screens/couple/daily_verse_plan_screen.dart';
import '../presentation/screens/couple/invite_partner_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/onboarding/profile_setup_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/verse/daily_verse_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
      GoRoute(
        path: '/couple/manage',
        name: 'couple_manage',
        builder: (context, state) => const CoupleManagementScreen(),
      ),
      GoRoute(
        path: '/couple/invite',
        name: 'couple_invite',
        builder: (context, state) => const InvitePartnerScreen(),
      ),
      GoRoute(
        path: '/couple/connect/:token',
        name: 'couple_connect',
        builder: (context, state) {
          final token = state.pathParameters['token']!;
          return ConnectCoupleScreen(token: token);
        },
      ),
      GoRoute(
        path: '/couple/plan',
        name: 'couple_plan',
        builder: (context, state) => const DailyVersePlanScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/verse/daily',
        name: 'daily_verse',
        builder: (context, state) => const DailyVerseScreen(),
      ),
      GoRoute(
        path: '/verse/:verseId',
        name: 'verse_detail',
        builder: (context, state) {
          final verseId = state.pathParameters['verseId']!;
          return DailyVerseScreen(verseId: verseId);
        },
      ),
      GoRoute(
        path: '/holy-fire-test',
        name: 'holy-fire-test',
        builder: (context, state) => const HolyFireTestScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
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
