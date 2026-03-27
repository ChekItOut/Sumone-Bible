import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Secondary Button - 보조 액션용 버튼
///
/// Divider Color (#F5F5F5) 배경에 Text Secondary (#666666) 텍스트를 사용합니다.
///
/// 예시:
/// ```dart
/// SecondaryButton(
///   text: '취소',
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
///
/// 주요 매개변수:
/// - text: 버튼에 표시할 텍스트 (필수)
/// - onPressed: 버튼 클릭 시 실행할 함수 (null이면 비활성 상태)
/// - isLoading: 로딩 상태 표시 여부 (기본값: false)
/// - fullWidth: 전체 너비 사용 여부 (기본값: false)
/// - height: 버튼 높이 (기본값: 48)
/// - padding: 버튼 내부 패딩 (기본값: 수평 24px, 수직 16px)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.height = 48,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || onPressed == null;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppTheme.disabledBackground
              : AppTheme.dividerColor, // 연한 회색
          foregroundColor: isDisabled
              ? AppTheme.disabledText
              : AppTheme.textSecondary, // 중간 회색 텍스트
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          disabledBackgroundColor: AppTheme.disabledBackground,
          disabledForegroundColor: AppTheme.disabledText,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.textSecondary,
                  ),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
