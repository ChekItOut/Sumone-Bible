import 'package:flutter/material.dart';
import 'package:bible_sumone/app/theme.dart';

/// 테마 시스템 테스트 페이지
///
/// Phase 0.5 - Task 0.5.2
/// design-guideline.md 기반 색상, 타이포그래피 시각화 및 다크 모드 테스트
///
/// NOTE: 이 페이지는 기능이 없는 순수 UI 테스트용입니다.
/// 사용자 컨펌 후 삭제 예정 (Production 빌드 전)
class ThemeTestScreen extends StatefulWidget {
  const ThemeTestScreen({super.key});

  @override
  State<ThemeTestScreen> createState() => _ThemeTestScreenState();
}

class _ThemeTestScreenState extends State<ThemeTestScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Theme(
      data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: _isDarkMode
                ? AppTheme.backgroundDark
                : AppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('테마 시스템 테스트'),
              actions: [
                // 다크 모드 토글
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, size: 20),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.nightlight_outlined, size: 20),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 안내 메시지
                  _buildInfoCard(),
                  const SizedBox(height: 24),

                  // 1. 색상 팔레트
                  _buildSectionTitle('1. 색상 팔레트 (Color Palette)'),
                  const SizedBox(height: 12),
                  _buildColorPalette(),
                  const SizedBox(height: 32),

                  // 2. 타이포그래피
                  _buildSectionTitle('2. 타이포그래피 (Typography)'),
                  const SizedBox(height: 12),
                  _buildTypography(textTheme),
                  const SizedBox(height: 32),

                  // 3. 버튼 스타일
                  _buildSectionTitle('3. 버튼 (Buttons)'),
                  const SizedBox(height: 12),
                  _buildButtons(),
                  const SizedBox(height: 32),

                  // 4. 카드 스타일
                  _buildSectionTitle('4. 카드 (Cards)'),
                  const SizedBox(height: 12),
                  _buildCards(),
                  const SizedBox(height: 32),

                  // 5. 입력 필드
                  _buildSectionTitle('5. 입력 필드 (Text Fields)'),
                  const SizedBox(height: 12),
                  _buildTextFields(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== 섹션 빌더 ====================

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.infoColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.infoColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '테마 시스템 테스트',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'design-guideline.md 기반 테마 시스템을 시각화합니다.\n\n'
            '• Primary Color: #11BC78 (녹색/민트)\n'
            '• Background: #F1F5F9 (Light) / #121212 (Dark)\n'
            '• 타이포그래피: Pretendard (기본), Noto Serif KR (성경 구절)\n'
            '• Material Design 3 기반\n\n'
            '우측 상단 스위치로 다크 모드를 테스트할 수 있습니다.',
            style: TextStyle(
              fontSize: 14,
              color: _isDarkMode
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildColorPalette() {
    return Card(
      elevation: _isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary Colors
            Text(
              'Primary Colors',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch(
                    'Primary',
                    '#11BC78',
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Light',
                    '#40D399',
                    AppTheme.primaryLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Dark',
                    '#0D9A63',
                    AppTheme.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status Colors
            Text(
              'Status Colors',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch(
                    'Success',
                    '#6BCF8E',
                    AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Warning',
                    '#FFB84D',
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch(
                    'Error',
                    '#FF6B6B',
                    AppTheme.errorColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Info',
                    '#4D9FFF',
                    AppTheme.infoColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Background & Text Colors
            Text(
              'Background & Text',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch(
                    'Background',
                    _isDarkMode ? '#121212' : '#F1F5F9',
                    _isDarkMode
                        ? AppTheme.backgroundDark
                        : AppTheme.backgroundColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Surface',
                    _isDarkMode ? '#1E1E1E' : '#FFFFFF',
                    _isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch(
                    'Text Primary',
                    _isDarkMode ? '#FFFFFF' : '#1A1A1A',
                    _isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Text Secondary',
                    _isDarkMode ? '#B0B0B0' : '#666666',
                    _isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Text Tertiary',
                    '#999999',
                    AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatch(String label, String hex, Color color) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isDarkMode
                  ? Colors.grey.shade700
                  : AppTheme.borderColor,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color:
                _isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          hex,
          style: TextStyle(
            fontSize: 9,
            color: _isDarkMode
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTypography(TextTheme textTheme) {
    return Card(
      elevation: _isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Headline 1 - 24px Bold',
              style: textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Headline 2 - 20px Bold',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Headline 3 - 18px SemiBold',
              style: textTheme.headlineSmall,
            ),
            const Divider(height: 32),
            Text(
              'Body 1 - 16px Regular (주요 본문)',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Body 2 - 14px Regular (보조 본문)',
              style: textTheme.bodyMedium,
            ),
            const Divider(height: 32),
            Text(
              'Caption 1 - 12px Regular (캡션)',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Caption 2 - 10px Regular (타임스탬프)',
              style: textTheme.labelSmall,
            ),
            const Divider(height: 32),
            Text(
              '성경 구절 전용 - 18px Noto Serif KR (예정)\n'
              '사랑은 오래 참고 사랑은 온유하며 투기하지 아니하며...',
              style: textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Card(
      elevation: _isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary Button
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary Button'),
            ),
            const SizedBox(height: 12),

            // Secondary Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.dividerColor,
                foregroundColor: AppTheme.textSecondary,
              ),
              child: const Text('Secondary Button'),
            ),
            const SizedBox(height: 12),

            // Disabled Button
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.disabledBackground,
                foregroundColor: AppTheme.disabledText,
                disabledBackgroundColor: AppTheme.disabledBackground,
                disabledForegroundColor: AppTheme.disabledText,
              ),
              child: const Text('Disabled Button'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCards() {
    return Column(
      children: [
        // Basic Card
        Card(
          elevation: _isDarkMode ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Card (elevation 2)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '16px 둥근 모서리, 부드러운 그림자',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Elevated Card (강조)
        Card(
          elevation: _isDarkMode ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elevated Card (elevation 4)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '20px 둥근 모서리, 더 강한 그림자 (중요 컨텐츠용)',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFields() {
    return Card(
      elevation: _isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: '기본 입력 필드',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: '포커스 시 Primary Color 테두리',
                helperText: '클릭하여 테스트',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: '비활성 입력 필드',
                enabled: false,
                filled: true,
                fillColor: _isDarkMode
                    ? Colors.grey.shade900
                    : AppTheme.disabledBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
