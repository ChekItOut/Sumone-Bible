import 'package:flutter/material.dart';

/// Bible SumOne 앱 테마 정의
///
/// 라이트/다크 모드를 지원하며, Material Design 3 기반
/// 참조: docs/prd.md 섹션 7.2 컬러 팔레트
class AppTheme {
  // ==================== 컬러 팔레트 ====================

  // Primary Colors (성경/영적 주제)
  static const Color primaryColor = Color(0xFF6B4DE8); // 보라색 (영적, 고귀함)
  static const Color secondaryColor = Color(0xFFFFC857); // 따뜻한 노란색 (별, 빛)
  static const Color accentColor = Color(0xFFFF6B9D); // 핑크 (하트, 사랑)

  // Background Colors (스크린샷 참조: 부드러운 slate blue)
  static const Color backgroundLight = Color(0xFF78909C); // Slate blue-grey
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Surface Colors (카드 배경)
  static const Color surfaceLight = Color(0xFFFFFFFF); // 흰색 카드
  static const Color surfaceLightSecondary = Color(0xFFF5F5F5); // 보조 카드

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1A1A1A); // 카드 위 텍스트
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textOnBackgroundLight = Color(0xFFFFFFFF); // 배경 위 텍스트 (흰색)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // ==================== 라이트 테마 ====================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceLight, // 카드는 흰색
      background: backgroundLight, // 배경은 slate blue
      error: Colors.red.shade400,
    ),

    scaffoldBackgroundColor: backgroundLight, // 전체 배경

    // 텍스트 테마
    // TODO: Phase 0.3 - 폰트 추가 후 fontFamily 복원
    textTheme: const TextTheme(
      // Headline (제목)
      headlineLarge: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      headlineMedium: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),

      // Body (본문)
      bodyLarge: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 16,
        color: textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 14,
        color: textSecondaryLight,
      ),

      // 성경 구절 전용 (세리프)
      displayLarge: TextStyle(
        // fontFamily: 'Noto Serif KR', // TODO: 폰트 추가 후 활성화
        fontSize: 18,
        height: 1.8, // 줄 간격
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
    ),

    // 버튼 테마 (스크린샷 참조: 더 둥근 모서리)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
    ),

    // 카드 테마 (스크린샷 참조: 큰 둥근 모서리 + 부드러운 그림자)
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: surfaceLight,
      shadowColor: Colors.black.withValues(alpha: 0.08),
    ),

    // 입력 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),

    // AppBar 테마 (배경과 동일한 색상, 텍스트는 흰색)
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight, // Slate blue
      foregroundColor: textOnBackgroundLight, // 흰색
      elevation: 0,
      centerTitle: false, // iOS 스타일 (좌측 정렬)
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: textOnBackgroundLight,
      ),
    ),
  );

  // ==================== 다크 테마 ====================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF8B6EF7), // 밝은 보라색
      secondary: secondaryColor,
      surface: surfaceDark,
      error: Colors.red.shade300,
    ),

    // TODO: Phase 0.3 - 폰트 추가 후 fontFamily 복원
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),

      bodyLarge: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 16,
        color: textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 14,
        color: textSecondaryDark,
      ),

      displayLarge: TextStyle(
        // fontFamily: 'Noto Serif KR', // TODO: 폰트 추가 후 활성화
        fontSize: 18,
        height: 1.8,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B6EF7),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: surfaceDark,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8B6EF7), width: 2),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
