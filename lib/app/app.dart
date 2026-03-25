import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'routes.dart';

/// Bible SumOne 앱의 최상위 위젯
///
/// Riverpod ProviderScope로 감싸져 있으며,
/// Material Design 3 테마와 GoRouter 라우팅을 적용
class BibleSumOneApp extends ConsumerWidget {
  const BibleSumOneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // 앱 정보
      title: 'Bible SumOne',
      debugShowCheckedModeBanner: false,

      // 테마
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // TODO: Phase 6에서 사용자 설정 반영
      // 로케일 (다국어 지원 준비)
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // Material 위젯 다국어
        GlobalWidgetsLocalizations.delegate, // 기본 위젯 다국어
        GlobalCupertinoLocalizations.delegate, // Cupertino 위젯 다국어
      ],

      // 라우팅
      routerConfig: AppRouter.router,
    );
  }
}
