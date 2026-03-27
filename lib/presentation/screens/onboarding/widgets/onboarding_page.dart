import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

/// 온보딩 페이지 위젯
///
/// 온보딩 각 단계를 표시하는 재사용 가능한 페이지 위젯
class OnboardingPage extends StatelessWidget {
  /// 페이지 아이콘
  final IconData icon;

  /// 페이지 제목
  final String title;

  /// 페이지 설명
  final String description;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // 아이콘
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 80, color: AppTheme.primaryColor),
          ),

          const SizedBox(height: 48),

          // 제목
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),

          const SizedBox(height: 16),

          // 설명
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary.withValues(alpha: 0.8),
                  height: 1.5,
                ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
