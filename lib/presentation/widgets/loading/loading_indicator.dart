import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Loading Indicator - 로딩 인디케이터
///
/// CircularProgressIndicator를 래핑하여 일관된 스타일을 제공합니다.
/// 다양한 크기와 색상을 지원하며, 접근성 레이블을 제공합니다.
///
/// 예시:
/// ```dart
/// LoadingIndicator()  // 기본 크기 40px
/// LoadingIndicator(size: 24)  // 작은 크기
/// LoadingIndicator(color: Colors.white)  // 흰색
/// ```
///
/// 주요 매개변수:
/// - size: 인디케이터 크기 (기본값: 40)
/// - color: 인디케이터 색상 (기본값: AppTheme.primaryColor)
/// - strokeWidth: 선 두께 (기본값: 4)
/// - semanticLabel: 접근성 레이블 (기본값: "로딩 중")
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? semanticLabel;

  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 4,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppTheme.primaryColor,
        ),
        semanticsLabel: semanticLabel ?? '로딩 중',
      ),
    );
  }
}

/// Full Screen Loading - 전체 화면 로딩
///
/// 화면 중앙에 로딩 인디케이터를 표시합니다.
/// Scaffold의 body로 사용할 수 있습니다.
///
/// 예시:
/// ```dart
/// Scaffold(
///   body: FullScreenLoading(),
/// )
/// ```
class FullScreenLoading extends StatelessWidget {
  final String? message;

  const FullScreenLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(size: 48),
          if (message != null) ...[
            const SizedBox(height: 24),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
