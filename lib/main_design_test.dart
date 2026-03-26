import 'package:flutter/material.dart';
import 'presentation/screens/design_system/design_test_screen.dart';

/// 디자인 시스템 테스트 전용 main 파일
///
/// Phase 0.5 - Task 0.5.1
///
/// 사용법:
/// flutter run -t lib/main_design_test.dart
///
/// 기존 프로젝트에 영향 없이 디자인 테스트 화면만 실행됩니다.
void main() {
  runApp(const DesignTestApp());
}

class DesignTestApp extends StatelessWidget {
  const DesignTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design System Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F5F5), // 연한 회색/핑크 배경
        cardColor: const Color(0xFFFFFFFF), // 카드는 완전 흰색
        cardTheme: const CardThemeData(
          color: Color(0xFFFFFFFF), // 카드 배경색 강제 설정
        ),
      ),
      home: const DesignTestScreen(),
    );
  }
}
