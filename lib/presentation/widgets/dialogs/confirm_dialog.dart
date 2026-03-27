import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../buttons/secondary_button.dart';
import '../buttons/primary_button.dart';

/// Confirm Dialog - 확인/취소 다이얼로그
///
/// 사용자에게 확인을 요청하는 다이얼로그입니다.
/// Helper 메서드로 쉽게 호출할 수 있으며, 결과를 true/false로 반환합니다.
///
/// 예시:
/// ```dart
/// final result = await ConfirmDialog.show(
///   context,
///   title: '삭제 확인',
///   message: '정말 삭제하시겠습니까?',
/// );
///
/// if (result == true) {
///   // 확인 버튼 클릭
/// }
/// ```
///
/// 주요 매개변수:
/// - title: 다이얼로그 제목 (필수)
/// - message: 다이얼로그 내용 (필수)
/// - confirmText: 확인 버튼 텍스트 (기본값: "확인")
/// - cancelText: 취소 버튼 텍스트 (기본값: "취소")
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = '확인',
    this.cancelText = '취소',
  });

  /// Helper 메서드 - 다이얼로그 표시
  ///
  /// 반환값: true (확인), false (취소), null (외부 클릭)
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
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

            // 버튼
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: SecondaryButton(
                    text: cancelText,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),

                // 확인 버튼
                Expanded(
                  child: PrimaryButton(
                    text: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
