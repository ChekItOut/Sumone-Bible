import 'package:flutter/material.dart';

/// 디자인 시스템 테스트 페이지
///
/// Phase 0.5 - Task 0.5.1
/// 제공받은 UI 스크린샷을 기반으로 추출한 디자인 토큰을 시각적으로 확인
///
/// NOTE: 이 페이지는 기능이 없는 순수 UI 테스트용입니다.
/// 사용자 컨펌 후 삭제 예정 (Production 빌드 전)
class DesignTestScreen extends StatefulWidget {
  const DesignTestScreen({super.key});

  @override
  State<DesignTestScreen> createState() => _DesignTestScreenState();
}

class _DesignTestScreenState extends State<DesignTestScreen>
    with SingleTickerProviderStateMixin {
  // 테스트용 상태
  bool _isChecked1 = true;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  int _selectedTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================== 디자인 토큰 ====================

  // Primary Color (제공받은 색상)
  static const Color _primaryColor = Color(0xFFF93D17);
  static const Color _primaryLight = Color(0xFFFF6B47);
  static const Color _primaryDark = Color(0xFFD93010);

  // Background
  static const Color _backgroundColor = Color(0xFFF8F5F5); // 연한 회색/핑크 배경
  static const Color _surfaceColor = Color(0xFFFFFFFF); // 카드는 완전 흰색

  // Text
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF666666);
  static const Color _textTertiary = Color(0xFF999999);

  // Border & Divider
  static const Color _borderColor = Color(0xFFE0E0E0);
  static const Color _dividerColor = Color(0xFFF5F5F5);

  // Status Colors
  static const Color _successColor = Color(0xFF6BCF8E);
  static const Color _warningColor = Color(0xFFFFB84D);
  static const Color _errorColor = Color(0xFFFF6B6B);
  static const Color _infoColor = Color(0xFF4D9FFF);

  // Disabled
  static const Color _disabledBackground = Color(0xFFFFF0ED);
  static const Color _disabledText = Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: _textPrimary,
        elevation: 0,
        title: const Text('디자인 시스템 테스트'),
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
            _buildTypography(),
            const SizedBox(height: 32),

            // 3. 버튼
            _buildSectionTitle('3. 버튼 (Buttons)'),
            const SizedBox(height: 12),
            _buildButtons(),
            const SizedBox(height: 32),

            // 4. 카드
            _buildSectionTitle('4. 카드 (Cards)'),
            const SizedBox(height: 12),
            _buildCards(),
            const SizedBox(height: 32),

            // 5. 다이얼로그
            _buildSectionTitle('5. 다이얼로그 (Dialogs)'),
            const SizedBox(height: 12),
            _buildDialogButtons(),
            const SizedBox(height: 32),

            // 6. 리스트 아이템
            _buildSectionTitle('6. 리스트 아이템 (List Items)'),
            const SizedBox(height: 12),
            _buildListItems(),
            const SizedBox(height: 32),

            // 7. 체크박스
            _buildSectionTitle('7. 체크박스 (Checkboxes)'),
            const SizedBox(height: 12),
            _buildCheckboxes(),
            const SizedBox(height: 32),

            // 8. 탭
            _buildSectionTitle('8. 탭 (Tabs)'),
            const SizedBox(height: 12),
            _buildTabs(),
            const SizedBox(height: 32),

            // 9. 프로그레스
            _buildSectionTitle('9. 프로그레스 (Progress)'),
            const SizedBox(height: 12),
            _buildProgress(),
            const SizedBox(height: 32),

            // 10. 하단 고정 버튼 미리보기
            _buildSectionTitle('10. 하단 고정 버튼 (Bottom Fixed Button)'),
            const SizedBox(height: 12),
            _buildBottomButtonPreview(),
            const SizedBox(height: 80), // 하단 여백
          ],
        ),
      ),
    );
  }

  // ==================== 섹션 빌더 ====================

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _infoColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: _infoColor, size: 20),
              const SizedBox(width: 8),
              Text(
                '테스트 페이지 안내',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '이 페이지는 제공받은 UI 스크린샷을 분석하여 추출한 디자인 토큰을 확인하기 위한 테스트 페이지입니다.\n\n'
            '• Primary Color: #F93D17 (주황-빨강)\n'
            '• 배경: 흰색\n'
            '• 카드 중심 디자인\n'
            '• 둥근 모서리 + 부드러운 그림자\n\n'
            '컨펌 후 실제 테마에 적용됩니다.',
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
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
        color: _textPrimary,
      ),
    );
  }

  Widget _buildColorPalette() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Primary Colors',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch(
                    'Primary',
                    '#F93D17',
                    _primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Primary Light',
                    '#FF6B47',
                    _primaryLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch(
                    'Primary Dark',
                    '#D93010',
                    _primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Status Colors',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch('Success', '#6BCF8E', _successColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch('Warning', '#FFB84D', _warningColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch('Error', '#FF6B6B', _errorColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildColorSwatch('Info', '#4D9FFF', _infoColor),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Text Colors',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorSwatch('Primary', '#1A1A1A', _textPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      _buildColorSwatch('Secondary', '#666666', _textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      _buildColorSwatch('Tertiary', '#999999', _textTertiary),
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
            border: Border.all(color: _borderColor, width: 1),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          hex,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTypography() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Headline 1 - 24px Bold',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Headline 2 - 20px Bold',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Headline 3 - 18px SemiBold',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const Divider(height: 32),
            Text(
              'Body 1 - 16px Regular',
              style: TextStyle(
                fontSize: 16,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Body 2 - 14px Regular',
              style: TextStyle(
                fontSize: 14,
                color: _textPrimary,
              ),
            ),
            const Divider(height: 32),
            Text(
              'Caption 1 - 12px Regular',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Caption 2 - 10px Regular',
              style: TextStyle(
                fontSize: 10,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Primary Button',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            // Secondary Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _dividerColor,
                foregroundColor: _textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Secondary Button',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            // Disabled Button
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _disabledBackground,
                foregroundColor: _disabledText,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: _disabledBackground,
                disabledForegroundColor: _disabledText,
              ),
              child: const Text(
                'Disabled Button',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
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
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '16px 둥근 모서리, 부드러운 그림자',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Elevated Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '20px 둥근 모서리, 더 강한 그림자',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogButtons() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _showConfirmDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('확인 다이얼로그 보기'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showProductDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('제품 다이얼로그 보기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItems() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildListItem(
            '소스내추럴',
            '메가 스트렝스 베타 시토스테롤',
            true,
            () => setState(() => _isChecked1 = !_isChecked1),
          ),
          Divider(height: 1, color: _dividerColor),
          _buildListItem(
            '뉴트리코스트',
            '베타알라닌',
            false,
            () => setState(() => _isChecked2 = !_isChecked2),
          ),
          Divider(height: 1, color: _dividerColor),
          _buildListItem(
            '나우푸드',
            '베타-1,3/1,6-D-글루칸 100mg',
            false,
            () => setState(() => _isChecked3 = !_isChecked3),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    String brand,
    String productName,
    bool isChecked,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 제품 이미지 (플레이스홀더)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _dividerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medication_outlined,
                color: _textTertiary,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),

            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand,
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // 체크박스
            _buildCircularCheckbox(isChecked),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxes() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                _buildCircularCheckbox(true),
                const SizedBox(height: 8),
                Text(
                  '선택됨',
                  style: TextStyle(fontSize: 12, color: _textSecondary),
                ),
              ],
            ),
            Column(
              children: [
                _buildCircularCheckbox(false),
                const SizedBox(height: 8),
                Text(
                  '선택 안 됨',
                  style: TextStyle(fontSize: 12, color: _textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularCheckbox(bool isChecked) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isChecked ? _primaryColor : Colors.transparent,
        border: Border.all(
          color: isChecked ? _primaryColor : _borderColor,
          width: 2,
        ),
      ),
      child: isChecked
          ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
          : null,
    );
  }

  Widget _buildTabs() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTab('전체', 0),
                ),
                Expanded(
                  child: _buildTab('최근', 1),
                ),
                Expanded(
                  child: _buildTab('인기', 2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '선택된 탭: ${_selectedTab == 0 ? "전체" : _selectedTab == 1 ? "최근" : "인기"}',
              style: TextStyle(
                fontSize: 14,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? _primaryColor : _textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 원형 프로그레스
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.76,
                      strokeWidth: 10,
                      backgroundColor: _dividerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '16',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      Text(
                        '점',
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 선형 프로그레스
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '선형 프로그레스',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 8,
                    backgroundColor: _dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonPreview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '하단 고정 버튼 스타일 (실제 화면에서 하단 고정)',
              style: TextStyle(
                fontSize: 14,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '선택 완료',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 다이얼로그 ====================

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '정말 삭제하시겠어요?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '내 영양제 정보가 있어야\n더 좋은 추천과 분석을 받을 수\n있어요',
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _dividerColor,
                        foregroundColor: _textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '삭제',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '아니요',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '찾으시는 영양제가 맞나요?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _dividerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  size: 64,
                  color: _textTertiary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '메가 스트렝스 베타 시토스테롤',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '소스내추럴',
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _dividerColor,
                        foregroundColor: _textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '아니요',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '네, 맞아요',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
