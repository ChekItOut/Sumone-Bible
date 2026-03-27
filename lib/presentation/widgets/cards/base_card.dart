import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Base Card - 기본 카드 위젯
///
/// 표준 카드 스타일을 적용한 재사용 가능한 카드 컴포넌트입니다.
/// 탭 가능 옵션과 커스텀 배경색을 지원합니다.
///
/// 예시:
/// ```dart
/// BaseCard(
///   child: Column(
///     children: [
///       Text('제목'),
///       Text('내용'),
///     ],
///   ),
/// )
/// ```
///
/// 주요 매개변수:
/// - child: 카드 내부에 표시할 위젯 (필수)
/// - padding: 카드 내부 패딩 (기본값: 20px)
/// - margin: 카드 외부 여백 (기본값: null)
/// - onTap: 카드 클릭 시 실행할 함수 (null이면 탭 불가)
/// - backgroundColor: 카드 배경색 (기본값: surfaceColor)
class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
      elevation: 2, // 부드러운 그림자
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // 16px 둥근 모서리
      ),
      color: backgroundColor ?? AppTheme.surfaceColor,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      margin: margin,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );

    // onTap이 있으면 InkWell로 감싸기
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
