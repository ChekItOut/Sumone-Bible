import 'package:flutter/material.dart';

/// Bible SumOne 앱 테마 정의
///
/// Material Design 3 기반, design-guideline.md 준수
/// 참조: docs/design-guideline.md (Phase 0.5)
class AppTheme {
  // ==================== 컬러 팔레트 (design-guideline.md) ====================

  // Primary Colors (주 색상)
  static const Color primaryColor = Color(0xFF11BC78); // 녹색/민트 (#11BC78)
  static const Color primaryLight = Color(0xFF40D399); // 밝은 톤 (#40D399)
  static const Color primaryDark = Color(0xFF0D9A63); // 어두운 톤 (#0D9A63)

  // Background Colors (배경 색상)
  static const Color backgroundColor = Color(0xFFF1F5F9); // 앱 전체 배경 (#F1F5F9)
  static const Color surfaceColor = Color(0xFFFFFFFF); // 카드 배경 (#FFFFFF)

  // Text Colors (텍스트 색상)
  static const Color textPrimary = Color(0xFF1A1A1A); // 주요 텍스트 (#1A1A1A)
  static const Color textSecondary = Color(0xFF666666); // 보조 텍스트 (#666666)
  static const Color textTertiary = Color(0xFF999999); // 세부 텍스트 (#999999)

  // Border & Divider Colors (테두리 및 구분선)
  static const Color borderColor = Color(0xFFE0E0E0); // 테두리 (#E0E0E0)
  static const Color dividerColor = Color(0xFFF5F5F5); // 구분선 (#F5F5F5)

  // Status Colors (상태 색상)
  static const Color successColor = Color(0xFF6BCF8E); // 성공 (#6BCF8E)
  static const Color warningColor = Color(0xFFFFB84D); // 경고 (#FFB84D)
  static const Color errorColor = Color(0xFFFF6B6B); // 오류 (#FF6B6B)
  static const Color infoColor = Color(0xFF4D9FFF); // 정보 (#4D9FFF)

  // Disabled Colors (비활성 색상)
  static const Color disabledBackground = Color(0xFFFFF0ED); // 배경 (#FFF0ED)
  static const Color disabledText = Color(0xFFCCCCCC); // 텍스트 (#CCCCCC)

  // Dark Mode Colors (다크 모드 - 추후 확장)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // ==================== 라이트 테마 (design-guideline.md 기반) ====================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: primaryLight,
      surface: surfaceColor,
      error: errorColor,
    ),

    scaffoldBackgroundColor: backgroundColor, // 연한 회색/핑크 배경

    // ==================== 텍스트 테마 ====================
    // TODO: 폰트 파일 추가 후 fontFamily 활성화
    textTheme: const TextTheme(
      // Headline 1 - 24px Bold
      headlineLarge: TextStyle(
        // fontFamily: 'Pretendard', // TODO: 폰트 추가 후 활성화
        fontSize: 24,
        fontWeight: FontWeight.bold, // 700
        color: textPrimary,
      ),

      // Headline 2 - 20px Bold
      headlineMedium: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),

      // Headline 3 - 18px SemiBold
      headlineSmall: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 18,
        fontWeight: FontWeight.w600, // SemiBold
        color: textPrimary,
      ),

      // Body 1 - 16px Regular
      bodyLarge: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.normal, // 400
        color: textPrimary,
      ),

      // Body 2 - 14px Regular
      bodyMedium: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),

      // Caption 1 - 12px Regular
      bodySmall: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),

      // Caption 2 - 10px Regular
      labelSmall: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),

      // 성경 구절 전용 - 18px Noto Serif KR, line height 1.8
      displayLarge: TextStyle(
        // fontFamily: 'Noto Serif KR', // TODO: 폰트 추가 후 활성화
        fontSize: 18,
        fontWeight: FontWeight.w500, // Medium
        height: 1.8, // 줄 간격 (가독성)
        color: textPrimary,
      ),
    ),

    // ==================== 버튼 테마 ====================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // #F93D17
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 12px 둥근 모서리
        ),
        elevation: 0, // Material 3 스타일
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600, // SemiBold
        ),
      ),
    ),

    // ==================== 카드 테마 ====================
    cardTheme: CardThemeData(
      elevation: 2, // 부드러운 그림자
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // 16px 둥근 모서리
      ),
      color: surfaceColor, // 흰색 배경
      shadowColor: Colors.black.withValues(alpha: 0.08),
    ),

    // ==================== 입력 필드 테마 ====================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100, // 연한 회색 배경
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // 12px 둥근 모서리
        borderSide: BorderSide.none, // 테두리 없음
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryColor, // 포커스 시 Primary Color
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      hintStyle: const TextStyle(color: textSecondary),
    ),

    // ==================== AppBar 테마 ====================
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor, // 앱 배경색과 동일
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false, // 좌측 정렬
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
    ),

    // ==================== Divider 테마 ====================
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),

    // ==================== Progress Indicator 테마 ====================
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
      linearTrackColor: dividerColor,
      circularTrackColor: dividerColor,
    ),
  );

  // ==================== 다크 테마 (추후 확장 예정) ====================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: primaryLight, // 밝은 Primary 사용
      secondary: primaryColor,
      surface: surfaceDark,
      error: errorColor,
    ),

    scaffoldBackgroundColor: backgroundDark,

    // TODO: Phase 0.5 - 다크 모드 색상 팔레트 정의 필요
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      headlineSmall: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),

      bodyLarge: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 16,
        color: textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 14,
        color: textSecondaryDark,
      ),
      bodySmall: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 12,
        color: textSecondaryDark,
      ),
      labelSmall: TextStyle(
        // fontFamily: 'Pretendard',
        fontSize: 10,
        color: textSecondaryDark,
      ),

      displayLarge: TextStyle(
        // fontFamily: 'Noto Serif KR',
        fontSize: 18,
        height: 1.8,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      hintStyle: const TextStyle(color: textSecondaryDark),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.grey.shade800,
      thickness: 1,
      space: 1,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: surfaceDark,
      circularTrackColor: surfaceDark,
    ),
  );
}
