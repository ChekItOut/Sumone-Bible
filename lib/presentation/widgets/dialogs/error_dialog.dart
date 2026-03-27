import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../buttons/primary_button.dart';

/// Error Dialog - 에러 메시지 다이얼로그
///
/// 사용자에게 에러 메시지를 표시하는 다이얼로그입니다.
/// Helper 메서드로 쉽게 호출할 수 있습니다.
///
/// 예시:
/// ```dart
/// await ErrorDialog.show(
///   context,
///   title: '오류',
///   message: '네트워크 연결을 확인해주세요.',
/// );
/// ```
///
/// 주요 매개변수:
/// - title: 다이얼로그 제목 (기본값: "오류")
/// - message: 에러 메시지 (필수)
/// - buttonText: 버튼 텍스트 (기본값: "확인")
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  const ErrorDialog({
    super.key,
    this.title = '오류',
    required this.message,
    this.buttonText = '확인',
  });

  /// Helper 메서드 - 다이얼로그 표시
  static Future<void> show(
    BuildContext context, {
    String title = '오류',
    required String message,
    String buttonText = '확인',
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 외부 클릭으로 닫을 수 없음
      builder: (context) =>
          ErrorDialog(title: title, message: message, buttonText: buttonText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // 20px 둥근 모서리
      ),
      child: Padding(
        padding: const EdgeInsets.all(24), // 내부 패딩 24px
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 에러 아이콘
            const Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 48,
            ),
            const SizedBox(height: 16),

            // 제목
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 내용
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 확인 버튼
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: buttonText,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
