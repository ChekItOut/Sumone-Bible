import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../widgets/cards/base_card.dart';

class VerseText extends StatelessWidget {
  final String reference;
  final String text;

  const VerseText({super.key, required this.reference, required this.text});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reference,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontFamily: 'Pretendard',
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
