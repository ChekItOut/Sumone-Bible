import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Text Field Custom - 커스텀 입력 필드
///
/// 라벨, 힌트, 에러 메시지, 아이콘을 지원하는 재사용 가능한 입력 필드입니다.
///
/// 예시:
/// ```dart
/// TextFieldCustom(
///   labelText: '이메일',
///   hintText: 'example@email.com',
///   keyboardType: TextInputType.emailAddress,
///   controller: emailController,
/// )
/// ```
///
/// 주요 매개변수:
/// - labelText: 입력 필드 라벨 (옵션)
/// - hintText: 플레이스홀더 텍스트 (옵션)
/// - controller: TextEditingController (옵션)
/// - errorText: 에러 메시지 (옵션, 표시 시 빨간 테두리)
/// - obscureText: 비밀번호 입력 여부 (기본값: false)
/// - keyboardType: 키보드 타입 (기본값: TextInputType.text)
/// - enabled: 활성화 여부 (기본값: true)
/// - prefixIcon: 좌측 아이콘 (옵션)
/// - suffixIcon: 우측 아이콘 (옵션)
/// - maxLines: 최대 줄 수 (기본값: 1)
/// - onChanged: 입력 변경 시 콜백 (옵션)
/// - validator: 유효성 검사 함수 (옵션, TextFormField에서 사용)
/// - textInputAction: 키보드 액션 버튼 (기본값: TextInputAction.done)
class TextFieldCustom extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const TextFieldCustom({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 라벨 (있을 경우)
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 입력 필드
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,
          textInputAction: textInputAction,
          style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? Colors
                      .grey
                      .shade100 // 연한 회색 배경
                : AppTheme.disabledBackground, // 비활성 배경
            hintText: hintText,
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            errorStyle: const TextStyle(
              color: AppTheme.errorColor,
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // 12px 둥근 모서리
              borderSide: BorderSide.none, // 테두리 없음
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor, // 포커스 시 Primary Color
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.errorColor, // 에러 시 Error Color
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.errorColor,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}
