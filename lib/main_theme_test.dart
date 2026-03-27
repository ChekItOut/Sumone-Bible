import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'presentation/screens/design_system/theme_test_screen.dart';

/// 테마 테스트 전용 main 파일
///
/// 실행 방법:
/// flutter run -t lib/main_theme_test.dart
void main() {
  runApp(const ThemeTestApp());
}

class ThemeTestApp extends StatelessWidget {
  const ThemeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Test',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const ThemeTestScreen(),
    );
  }
}
