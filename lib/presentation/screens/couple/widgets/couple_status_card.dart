import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/couple.dart';
import '../../../widgets/cards/base_card.dart';

/// 커플 상태 표시 카드 위젯
///
/// 파트너 정보, 관계 단계, 연결일, 플랜 정보를 표시
class CoupleStatusCard extends StatelessWidget {
  final Couple couple;
  final VoidCallback? onManageTap;

  const CoupleStatusCard({super.key, required this.couple, this.onManageTap});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더: 아이콘 + 타이틀
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '파트너와 연결됨',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        couple.relationshipStageText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 연결일
            _buildInfoRow(
              context,
              icon: Icons.calendar_today,
              label: '연결일',
              value: _formatDate(couple.createdAt),
            ),
            const SizedBox(height: 8),

            // 플랜 정보
            if (couple.hasPlan) ...[
              _buildInfoRow(
                context,
                icon: Icons.book,
                label: '현재 플랜',
                value: couple.dailyVersePlan!.description,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                icon: Icons.location_on,
                label: '진행 상황',
                value: couple.dailyVersePlan!.currentPosition,
              ),
            ] else ...[
              _buildInfoRow(
                context,
                icon: Icons.book_outlined,
                label: '플랜',
                value: '아직 설정되지 않았습니다',
                valueColor: Colors.grey,
              ),
            ],

            // 관리 버튼 (선택사항)
            if (onManageTap != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onManageTap,
                    icon: const Icon(Icons.settings),
                    label: const Text('커플 관리'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 정보 행 (아이콘 + 라벨 + 값)
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 날짜 포맷팅
  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
