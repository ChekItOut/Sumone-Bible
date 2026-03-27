import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/buttons/text_button_custom.dart';
import '../../widgets/cards/base_card.dart';
import '../../widgets/cards/elevated_card.dart';
import '../../widgets/inputs/text_field_custom.dart';
import '../../widgets/inputs/text_area_custom.dart';
import '../../widgets/loading/loading_indicator.dart';
import '../../widgets/loading/skeleton_loader.dart';
import '../../widgets/dialogs/confirm_dialog.dart';
import '../../widgets/dialogs/error_dialog.dart';

/// Widgets Test Screen - 공통 위젯 테스트 페이지
///
/// 모든 공통 위젯을 테스트하고 시연할 수 있는 페이지입니다.
/// Phase 0.5.6에서 제거 예정 (Production 빌드 대비)
class WidgetsTestScreen extends StatefulWidget {
  const WidgetsTestScreen({super.key});

  @override
  State<WidgetsTestScreen> createState() => _WidgetsTestScreenState();
}

class _WidgetsTestScreenState extends State<WidgetsTestScreen> {
  // 버튼 로딩 상태
  bool isPrimaryLoading = false;

  // 입력 필드 컨트롤러
  final TextEditingController defaultController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController errorController = TextEditingController();
  final TextEditingController textAreaController = TextEditingController();

  // 다크 모드 상태
  bool isDarkMode = false;

  @override
  void dispose() {
    defaultController.dispose();
    emailController.dispose();
    passwordController.dispose();
    errorController.dispose();
    textAreaController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: '공통 위젯 테스트',
        showBackButton: true,
        actions: [
          // 다크 모드 토글 (추후 구현 시 동작)
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              _showSnackBar('다크 모드: ${value ? "ON" : "OFF"} (추후 구현)');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            BaseCard(
              backgroundColor: AppTheme.infoColor.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.infoColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '이 페이지는 공통 위젯 테스트용입니다. Phase 0.5.6에서 제거 예정입니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. Buttons Section
            _buildSectionTitle('1. Buttons'),
            const SizedBox(height: 12),

            // Primary Button (Default)
            PrimaryButton(
              text: 'Primary Button (Default)',
              onPressed: () => _showSnackBar('Primary 버튼 클릭'),
              fullWidth: true,
            ),
            const SizedBox(height: 12),

            // Primary Button (Loading)
            PrimaryButton(
              text: 'Primary Button (Loading)',
              isLoading: isPrimaryLoading,
              onPressed: () {
                setState(() => isPrimaryLoading = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() => isPrimaryLoading = false);
                    _showSnackBar('로딩 완료');
                  }
                });
              },
              fullWidth: true,
            ),
            const SizedBox(height: 12),

            // Primary Button (Disabled)
            PrimaryButton(
              text: 'Primary Button (Disabled)',
              onPressed: null,
              fullWidth: true,
            ),
            const SizedBox(height: 12),

            // Secondary Button
            SecondaryButton(
              text: 'Secondary Button',
              onPressed: () => _showSnackBar('Secondary 버튼 클릭'),
              fullWidth: true,
            ),
            const SizedBox(height: 12),

            // Text Button
            Center(
              child: TextButtonCustom(
                text: '회원가입',
                onPressed: () => _showSnackBar('Text 버튼 클릭'),
              ),
            ),
            const SizedBox(height: 12),

            // Button Group (취소 + 확인)
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: '취소',
                    onPressed: () => _showSnackBar('취소 클릭'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: '확인',
                    onPressed: () => _showSnackBar('확인 클릭'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 2. Cards Section
            _buildSectionTitle('2. Cards'),
            const SizedBox(height: 12),

            // Base Card
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Base Card',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'elevation: 2, borderRadius: 16px',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Elevated Card
            ElevatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Elevated Card',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'elevation: 4, borderRadius: 20px (더 강한 그림자)',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tappable Card
            BaseCard(
              onTap: () => _showSnackBar('카드 탭됨'),
              child: Row(
                children: [
                  Icon(Icons.touch_app, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tappable Card (클릭 가능)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.textTertiary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. Inputs Section
            _buildSectionTitle('3. Inputs'),
            const SizedBox(height: 12),

            // TextField (Default)
            TextFieldCustom(
              labelText: '이름',
              hintText: '이름을 입력하세요',
              controller: defaultController,
            ),
            const SizedBox(height: 16),

            // TextField (Email)
            TextFieldCustom(
              labelText: '이메일',
              hintText: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              prefixIcon: Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 16),

            // TextField (Password)
            TextFieldCustom(
              labelText: '비밀번호',
              hintText: '비밀번호를 입력하세요',
              obscureText: true,
              controller: passwordController,
              prefixIcon: Icon(Icons.lock_outlined),
            ),
            const SizedBox(height: 16),

            // TextField (Error)
            TextFieldCustom(
              labelText: '에러 상태',
              hintText: '잘못된 입력',
              controller: errorController,
              errorText: '올바른 형식이 아닙니다',
            ),
            const SizedBox(height: 16),

            // TextField (Disabled)
            TextFieldCustom(
              labelText: '비활성 상태',
              hintText: '입력 불가',
              enabled: false,
            ),
            const SizedBox(height: 16),

            // TextArea
            TextAreaCustom(
              labelText: '답변 작성',
              hintText: '오늘 말씀을 읽고 느낀 점을 자유롭게 작성해주세요.',
              controller: textAreaController,
              maxLines: 5,
            ),

            const SizedBox(height: 32),

            // 4. Loading Section
            _buildSectionTitle('4. Loading'),
            const SizedBox(height: 12),

            BaseCard(
              child: Column(
                children: [
                  Text(
                    'Loading Indicators',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          LoadingIndicator(size: 24),
                          const SizedBox(height: 8),
                          Text('24px', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          LoadingIndicator(size: 40),
                          const SizedBox(height: 8),
                          Text('40px', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          LoadingIndicator(size: 56),
                          const SizedBox(height: 8),
                          Text('56px', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Skeleton Loader
            Text(
              'Skeleton Loaders',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            SkeletonCard(),

            const SizedBox(height: 32),

            // 5. Dialogs Section
            _buildSectionTitle('5. Dialogs'),
            const SizedBox(height: 12),

            PrimaryButton(
              text: 'Confirm Dialog 열기',
              onPressed: () async {
                final result = await ConfirmDialog.show(
                  context,
                  title: '확인',
                  message: '이 작업을 진행하시겠습니까?',
                );

                if (result == true) {
                  _showSnackBar('확인됨');
                } else if (result == false) {
                  _showSnackBar('취소됨');
                }
              },
              fullWidth: true,
            ),
            const SizedBox(height: 12),

            SecondaryButton(
              text: 'Error Dialog 열기',
              onPressed: () async {
                await ErrorDialog.show(
                  context,
                  title: '오류',
                  message: '네트워크 연결을 확인해주세요.',
                );
              },
              fullWidth: true,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }
}
