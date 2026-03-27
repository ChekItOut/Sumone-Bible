import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Elevated Card - 강조 카드 위젯
///
/// elevation 4와 더 둥근 모서리(20px)를 사용한 강조 카드입니다.
/// 중요한 정보 (오늘의 말씀 카드 등)를 표시할 때 사용합니다.
///
/// 예시:
/// ```dart
/// ElevatedCard(
///   child: Column(
///     children: [
///       Text('오늘의 말씀'),
///       Text('사랑은 오래 참고...'),
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
class ElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const ElevatedCard({
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
      elevation: 4, // 더 강한 그림자
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // 20px 둥근 모서리 (더 둥글게)
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
        borderRadius: BorderRadius.circular(20),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
