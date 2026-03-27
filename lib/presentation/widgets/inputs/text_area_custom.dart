import 'package:flutter/material.dart';
import 'text_field_custom.dart';

/// Text Area Custom - 여러 줄 입력 필드
///
/// TextFieldCustom을 확장하여 여러 줄 입력을 지원합니다.
/// 답변 작성, 긴 텍스트 입력에 사용합니다.
///
/// 예시:
/// ```dart
/// TextAreaCustom(
///   labelText: '답변 작성',
///   hintText: '오늘 말씀을 읽고 느낀 점을 자유롭게 작성해주세요.',
///   controller: responseController,
///   maxLines: 5,
/// )
/// ```
///
/// 주요 매개변수:
/// - labelText: 입력 필드 라벨 (옵션)
/// - hintText: 플레이스홀더 텍스트 (옵션)
/// - controller: TextEditingController (옵션)
/// - errorText: 에러 메시지 (옵션)
/// - enabled: 활성화 여부 (기본값: true)
/// - maxLines: 최대 줄 수 (기본값: 5)
/// - onChanged: 입력 변경 시 콜백 (옵션)
class TextAreaCustom extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? errorText;
  final bool enabled;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  const TextAreaCustom({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.errorText,
    this.enabled = true,
    this.maxLines = 5,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldCustom(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      errorText: errorText,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      onChanged: onChanged,
    );
  }
}
