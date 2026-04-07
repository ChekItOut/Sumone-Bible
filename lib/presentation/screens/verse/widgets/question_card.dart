import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../widgets/cards/elevated_card.dart';
import '../../../widgets/loading/skeleton_loader.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final bool isLoading;

  const QuestionCard({
    super.key,
    required this.question,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedCard(
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_alt_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Today\'s Question',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading) ...const [
            SkeletonLoader(width: double.infinity, height: 18, borderRadius: 6),
            SizedBox(height: 8),
            SkeletonLoader(width: 220, height: 18, borderRadius: 6),
          ] else
            Text(
              question,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
