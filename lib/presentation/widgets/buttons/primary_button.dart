import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Primary Button - 주요 액션용 버튼
///
/// Primary Color (#11BC78)를 사용하며, 로딩 상태와 비활성 상태를 지원합니다.
///
/// 예시:
/// ```dart
/// PrimaryButton(
///   text: '로그인',
///   onPressed: () => print('로그인'),
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
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
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
    // 로딩 중이거나 onPressed가 null이면 비활성
    final bool isDisabled = isLoading || onPressed == null;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey.shade300 // 중성적인 회색 (테마 일관성)
              : AppTheme.primaryColor,
          foregroundColor: isDisabled
              ? Colors.grey.shade600 // 진한 회색 텍스트
              : Colors.white,
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 12px 둥근 모서리
          ),
          elevation: 0, // Material Design 3
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // SemiBold
                ),
              ),
      ),
    );
  }
}
