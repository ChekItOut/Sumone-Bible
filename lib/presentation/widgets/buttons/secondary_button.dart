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
/// - icon: 버튼 앞에 표시할 아이콘 (선택사항)
/// - isDestructive: 삭제/해제 등 위험한 액션 표시 (빨간색)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final bool isDestructive;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.height = 48,
    this.padding,
    this.icon,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || onPressed == null;

    // 색상 결정: 파괴적 액션이면 빨간색, 아니면 회색
    final Color backgroundColor = isDisabled
        ? AppTheme.disabledBackground
        : isDestructive
        ? Colors.red.shade50
        : AppTheme.dividerColor;

    final Color foregroundColor = isDisabled
        ? AppTheme.disabledText
        : isDestructive
        ? Colors.red.shade700
        : AppTheme.textSecondary;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
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
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
