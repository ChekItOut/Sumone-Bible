import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/logger.dart';
import 'routes.dart';
import 'theme.dart';

/// Bible SumOne 앱의 최상위 위젯
///
/// Riverpod ProviderScope로 감싸져 있으며,
/// Material Design 3 테마와 GoRouter 라우팅을 적용
class BibleSumOneApp extends ConsumerStatefulWidget {
  const BibleSumOneApp({super.key});

  @override
  ConsumerState<BibleSumOneApp> createState() => _BibleSumOneAppState();
}

class _BibleSumOneAppState extends ConsumerState<BibleSumOneApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  /// 딥링크 초기화
  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // 앱이 종료된 상태에서 딥링크로 실행된 경우
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    // 앱이 실행 중일 때 딥링크를 받은 경우
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        logger.error('딥링크 처리 오류: $err');
      },
    );
  }

  /// 딥링크 처리
  void _handleDeepLink(Uri uri) {
    logger.info('딥링크 수신: $uri');

    // biblesumone://couple/connect/{token}
    if (uri.scheme == 'biblesumone' && uri.host == 'couple') {
      final path = uri.path;
      logger.info('딥링크 경로: $path');

      // GoRouter를 통해 화면 이동
      // NOTE: GoRouter.of(context)는 여기서 직접 사용 불가능
      // 대신 전역 navigatorKey를 사용하거나, routes.dart의 router를 직접 사용
      AppRouter.router.go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
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
