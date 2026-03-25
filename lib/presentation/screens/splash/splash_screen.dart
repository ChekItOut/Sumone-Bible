import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme.dart';

/// 컬러 팔레트 쇼케이스 화면
///
/// Bible SumOne 프로젝트에서 사용하는 모든 색상을 카드 형태로 표시
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              const Text(
                'Bible SumOne',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Color Palette',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),

              const SizedBox(height: 32),

              // Primary Colors
              _buildSectionTitle('Primary Colors'),
              const SizedBox(height: 16),
              _buildColorCard(
                context,
                'Primary',
                '보라색 (영적, 고귀함)',
                AppTheme.primaryColor,
                '#6B4DE8',
              ),
              const SizedBox(height: 12),
              _buildColorCard(
                context,
                'Secondary',
                '따뜻한 노란색 (빛, 별)',
                AppTheme.secondaryColor,
                '#FFC857',
              ),
              const SizedBox(height: 12),
              _buildColorCard(
                context,
                'Accent',
                '핑크 (하트, 사랑)',
                AppTheme.accentColor,
                '#FF6B9D',
              ),

              const SizedBox(height: 32),

              // Background Colors
              _buildSectionTitle('Background Colors'),
              const SizedBox(height: 16),
              _buildColorCard(
                context,
                'Background Light',
                'Slate Blue-Grey',
                AppTheme.backgroundLight,
                '#78909C',
              ),
              const SizedBox(height: 12),
              _buildColorCard(
                context,
                'Surface Light',
                '카드 배경 (흰색)',
                AppTheme.surfaceLight,
                '#FFFFFF',
                isDark: false,
              ),

              const SizedBox(height: 32),

              // Text Colors
              _buildSectionTitle('Text Colors'),
              const SizedBox(height: 16),
              _buildColorCard(
                context,
                'Text Primary',
                '카드 위 텍스트',
                AppTheme.textPrimaryLight,
                '#1A1A1A',
              ),
              const SizedBox(height: 12),
              _buildColorCard(
                context,
                'Text Secondary',
                '보조 텍스트',
                AppTheme.textSecondaryLight,
                '#666666',
              ),
              const SizedBox(height: 12),
              _buildColorCard(
                context,
                'Text on Background',
                '배경 위 텍스트 (흰색)',
                AppTheme.textOnBackgroundLight,
                '#FFFFFF',
                isDark: false,
              ),

              const SizedBox(height: 32),

              // 사용 예시 카드
              _buildSectionTitle('Usage Example'),
              const SizedBox(height: 16),
              _buildExampleCard(context),

              const SizedBox(height: 32),

              // 안내 메시지
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '💡 색상 코드를 탭하면 클립보드에 복사됩니다',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Phase 정보
              Center(
                child: Text(
                  'Phase 0 완료 • 다음: Phase 1 인증 시스템',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildColorCard(
    BuildContext context,
    String name,
    String description,
    Color color,
    String hexCode, {
    bool isDark = true,
  }) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: hexCode));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$hexCode 복사됨'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 색상 샘플
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
            ),
            const SizedBox(width: 16),

            // 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      hexCode,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 복사 아이콘
            Icon(Icons.copy, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 말씀',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '고린도전서 13:4-7',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.favorite, size: 18, color: AppTheme.accentColor),
                  SizedBox(width: 4),
                  Text(
                    '235',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.star, size: 18, color: AppTheme.secondaryColor),
                  SizedBox(width: 4),
                  Text(
                    '3.5',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 버튼 예시
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('읽으러 가기'),
            ),
          ),

          const SizedBox(height: 12),

          // 보조 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '과거 대화 보기',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
