import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../widgets/cards/base_card.dart';

/// 플랜 미리보기 위젯
///
/// 선택한 플랜 설정에 따른 미리보기 동적 생성
class PlanPreview extends StatelessWidget {
  final String selectedBook;
  final int dailyAmount;
  final String dailyAmountType;

  const PlanPreview({
    super.key,
    required this.selectedBook,
    required this.dailyAmount,
    required this.dailyAmountType,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.preview, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  '플랜 미리보기',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 플랜 설명
            _buildPreviewItem(
              context,
              icon: Icons.book,
              label: '시작 성경',
              value: selectedBook,
            ),
            const SizedBox(height: 12),
            _buildPreviewItem(
              context,
              icon: Icons.calendar_today,
              label: '하루 분량',
              value: _getDailyAmountText(),
            ),
            const SizedBox(height: 12),
            _buildPreviewItem(
              context,
              icon: Icons.access_time,
              label: '예상 소요 시간',
              value: _getEstimatedTime(),
            ),
            const SizedBox(height: 16),

            // 예시 텍스트
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '오늘 읽을 내용',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getExampleText(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.blue[900]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 미리보기 항목
  Widget _buildPreviewItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 하루 분량 텍스트
  String _getDailyAmountText() {
    if (dailyAmountType == 'verse') {
      return '$dailyAmount절씩';
    } else {
      return '$dailyAmount장씩';
    }
  }

  /// 예상 소요 시간
  String _getEstimatedTime() {
    if (dailyAmountType == 'verse') {
      // 절 단위: 1절당 약 30초 가정
      final minutes = (dailyAmount * 0.5).ceil();
      return '약 $minutes분';
    } else {
      // 장 단위: 1장당 약 3분 가정
      final minutes = (dailyAmount * 3).ceil();
      return '약 $minutes분';
    }
  }

  /// 예시 텍스트
  String _getExampleText() {
    if (dailyAmountType == 'verse') {
      return '$selectedBook부터 $dailyAmount절씩 읽으면, '
          '오늘은 $selectedBook 1장 1-$dailyAmount절을 읽습니다.';
    } else {
      final endChapter = dailyAmount;
      return '$selectedBook부터 $dailyAmount장씩 읽으면, '
          '오늘은 $selectedBook 1-$endChapter장을 읽습니다.';
    }
  }
}
