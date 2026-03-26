import 'package:flutter/material.dart';
import 'presentation/screens/_test/holy_fire_test_screen.dart';

/// 테스트 전용 main 파일
///
/// 사용법:
/// flutter run -t lib/main_test.dart
///
/// 기존 프로젝트에 영향 없이 테스트 화면만 실행됩니다.
void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holy Fire Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HolyFireTestScreen(),
    );
  }
}
