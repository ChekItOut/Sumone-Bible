import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Custom AppBar - 커스텀 앱바
///
/// 일관된 스타일의 앱바를 제공합니다.
/// 뒤로가기 버튼 제어, 액션 버튼 지원, Material Design 3 스타일을 따릅니다.
///
/// 예시:
/// ```dart
/// Scaffold(
///   appBar: CustomAppBar(
///     title: '화면 제목',
///   ),
/// )
/// ```
///
/// 주요 매개변수:
/// - title: 앱바 제목 (필수)
/// - showBackButton: 뒤로가기 버튼 표시 여부 (기본값: true)
/// - actions: 우측 액션 버튼 리스트 (옵션)
/// - elevation: 앱바 그림자 (기본값: 0)
/// - centerTitle: 제목 중앙 정렬 (기본값: true)
/// - backgroundColor: 배경색 (기본값: AppTheme.backgroundColor)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final double elevation;
  final bool centerTitle;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.elevation = 0,
    this.centerTitle = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppTheme.backgroundColor,
      foregroundColor: AppTheme.textPrimary,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showBackButton,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
