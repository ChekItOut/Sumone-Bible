import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/daily_verse.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/elevated_card.dart';
import '../../../widgets/loading/skeleton_loader.dart';

class DailyVerseCard extends StatelessWidget {
  final DailyVerse? verse;
  final bool isLoading;
  final VoidCallback? onTap;

  const DailyVerseCard({
    super.key,
    required this.verse,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ElevatedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonLoader(width: 120, height: 18, borderRadius: 6),
            SizedBox(height: 16),
            SkeletonLoader(width: 180, height: 24, borderRadius: 6),
            SizedBox(height: 16),
            SkeletonLoader(width: double.infinity, height: 18, borderRadius: 6),
            SizedBox(height: 8),
            SkeletonLoader(width: double.infinity, height: 18, borderRadius: 6),
            SizedBox(height: 8),
            SkeletonLoader(width: 220, height: 18, borderRadius: 6),
            SizedBox(height: 20),
            SkeletonLoader(
              width: double.infinity,
              height: 48,
              borderRadius: 12,
            ),
          ],
        ),
      );
    }

    if (verse == null) {
      return ElevatedCard(
        child: Column(
          children: [
            Icon(Icons.menu_book_outlined, size: 52, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Today\'s verse is not ready yet.',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Refresh again in a moment to see the verse and question.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // NOTE: verse는 이미 null 체크 완료, 로컬 변수로 타입 좁히기
    final verseData = verse!;

    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Today\'s Verse',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            verseData.reference,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            verseData.textKorean,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontFamily: 'Pretendard'),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Open Verse',
            onPressed: onTap,
            fullWidth: true,
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}
