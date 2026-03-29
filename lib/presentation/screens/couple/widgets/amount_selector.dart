import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../widgets/cards/base_card.dart';

/// 하루 분량 선택 위젯
///
/// 절/장 단위 선택 및 숫자 입력
class AmountSelector extends StatelessWidget {
  final String selectedType; // 'verse' | 'chapter'
  final int amount;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<int> onAmountChanged;

  const AmountSelector({
    super.key,
    required this.selectedType,
    required this.amount,
    required this.onTypeChanged,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '하루 분량 설정',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 절/장 선택 (라디오 버튼)
            Row(
              children: [
                Expanded(
                  child: _buildTypeOption(
                    context,
                    type: 'verse',
                    label: '절 단위',
                    description: '1-10절씩',
                    icon: Icons.format_list_numbered,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeOption(
                    context,
                    type: 'chapter',
                    label: '장 단위',
                    description: '1-5장씩',
                    icon: Icons.menu_book,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 숫자 입력
            _buildAmountInput(context),
          ],
        ),
      ),
    );
  }

  /// 타입 선택 옵션
  Widget _buildTypeOption(
    BuildContext context, {
    required String type,
    required String label,
    required String description,
    required IconData icon,
  }) {
    final isSelected = selectedType == type;

    return InkWell(
      onTap: () => onTypeChanged(type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 분량 숫자 입력
  Widget _buildAmountInput(BuildContext context) {
    final maxAmount = selectedType == 'verse' ? 10 : 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedType == 'verse' ? '하루에 읽을 절 수' : '하루에 읽을 장 수',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),

        // 슬라이더
        Row(
          children: [
            Expanded(
              child: Slider(
                value: amount.toDouble(),
                min: 1,
                max: maxAmount.toDouble(),
                divisions: maxAmount - 1,
                label: amount.toString(),
                onChanged: (value) => onAmountChanged(value.toInt()),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '$amount',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 가이드 텍스트
        Text(
          selectedType == 'verse' ? '1-10절 사이에서 선택하세요' : '1-5장 사이에서 선택하세요',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
