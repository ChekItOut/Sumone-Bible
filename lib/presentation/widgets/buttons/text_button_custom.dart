import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Text Button Custom - 배경 없는 텍스트 버튼
///
/// Primary Color (#11BC78) 텍스트를 사용하며, 배경이 없는 링크 스타일 버튼입니다.
///
/// 예시:
/// ```dart
/// TextButtonCustom(
///   text: '회원가입',
///   onPressed: () => context.push('/signup'),
/// )
/// ```
///
/// 주요 매개변수:
/// - text: 버튼에 표시할 텍스트 (필수)
/// - onPressed: 버튼 클릭 시 실행할 함수 (null이면 비활성 상태)
/// - isLoading: 로딩 상태 표시 여부 (기본값: false)
/// - padding: 버튼 내부 패딩 (기본값: 수평 16px, 수직 8px)
class TextButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const TextButtonCustom({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || onPressed == null;

    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isDisabled
            ? AppTheme.disabledText
            : AppTheme.primaryColor, // Primary Color 텍스트
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
    );
  }
}
