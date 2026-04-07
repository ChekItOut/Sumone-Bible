import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/daily_verse.dart';
import '../../../widgets/cards/base_card.dart';

class WeeklyVerseStatus {
  final DateTime date;
  final bool isCompleted;
  final bool isToday;
  final DailyVerse? verse;

  const WeeklyVerseStatus({
    required this.date,
    required this.isCompleted,
    required this.isToday,
    this.verse,
  });
}

class WeeklyCalendar extends StatelessWidget {
  final List<WeeklyVerseStatus> weekData;
  final ValueChanged<WeeklyVerseStatus>? onTapDate;

  const WeeklyCalendar({super.key, required this.weekData, this.onTapDate});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: weekData
                .map(
                  (item) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => onTapDate?.call(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            children: [
                              Text(
                                _weekdayLabel(item.date.weekday),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: item.isToday
                                          ? AppTheme.primaryColor
                                          : AppTheme.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              _StatusCircle(item: item),
                              const SizedBox(height: 8),
                              Text(
                                '${item.date.day}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: item.isToday
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[weekday - 1];
  }
}

class _StatusCircle extends StatelessWidget {
  final WeeklyVerseStatus item;

  const _StatusCircle({required this.item});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color iconColor;
    final IconData icon;
    final Border? border;

    if (item.isToday) {
      backgroundColor = Colors.white;
      iconColor = AppTheme.primaryColor;
      icon = item.isCompleted ? Icons.check : Icons.auto_awesome;
      border = Border.all(color: AppTheme.primaryColor, width: 2);
    } else if (item.isCompleted) {
      backgroundColor = AppTheme.primaryColor;
      iconColor = Colors.white;
      icon = Icons.check;
      border = null;
    } else {
      backgroundColor = AppTheme.backgroundColor;
      iconColor = AppTheme.textTertiary;
      icon = Icons.close;
      border = Border.all(color: AppTheme.borderColor);
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: border,
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}
