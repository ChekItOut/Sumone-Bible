import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/logger.dart';
import '../../../data/datasources/supabase_auth_datasource.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/text_field_custom.dart';

/// 프로필 설정 화면
///
/// 온보딩 완료 후 사용자 프로필(이름, 관계 단계)을 설정
/// 참조: docs/prd.md 섹션 F-002
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedRelationshipStage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 로그인 상태 확인
    _checkAuthStatus();
  }

  /// 로그인 상태 확인
  Future<void> _checkAuthStatus() async {
    try {
      final dataSource = SupabaseAuthDataSource();
      await dataSource.getCurrentUser();
      logger.info('프로필 설정 화면: 사용자 로그인 확인됨');
    } catch (e) {
      logger.warning('프로필 설정 화면: 사용자가 로그인되어 있지 않음');

      if (mounted) {
        // 로그인되어 있지 않으면 온보딩으로 돌아가기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('먼저 로그인해주세요'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );

        // 온보딩 화면으로 리다이렉트
        context.go('/onboarding');
      }
    }
  }

  // 관계 단계 옵션
  final Map<String, String> _relationshipStages = {
    'dating': '연애 중',
    'engaged': '약혼함',
    'married': '신혼',
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요';
    }
    if (value.length < 2) {
      return '이름은 최소 2자 이상이어야 합니다';
    }
    if (value.length > 20) {
      return '이름은 최대 20자까지 입력 가능합니다';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRelationshipStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('관계 단계를 선택해주세요'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dataSource = SupabaseAuthDataSource();

      // 현재 사용자 확인 (디버깅용)
      logger.info('프로필 저장 시작');
      try {
        final currentUser = await dataSource.getCurrentUser();
        logger.info('현재 사용자: ${currentUser.id}');
      } catch (e) {
        logger.error('사용자 조회 실패', error: e);
      }

      // 업데이트할 데이터 출력
      final metadata = {
        'name': _nameController.text.trim(),
        'relationship_stage': _selectedRelationshipStage,
      };
      logger.debug('업데이트할 메타데이터: $metadata');

      // Supabase Auth user_metadata 업데이트
      await dataSource.updateUserMetadata(metadata);

      // TODO: Supabase users 테이블에도 저장 (Phase 2)
      // await supabase.from('users').upsert({
      //   'user_id': currentUser.id,
      //   'name': _nameController.text.trim(),
      //   'relationship_stage': _selectedRelationshipStage,
      // });

      if (mounted) {
        // 홈 화면으로 이동 (현재 단계에서는 스플래시로)
        // TODO: Phase 2에서 실제 홈 화면으로 변경
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 저장 실패: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(title: '프로필 설정', centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 안내 메시지
                Text(
                  '거의 다 왔어요!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '파트너와 함께 사용할 프로필을 설정해주세요',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87, // 약간 연한 검정 (가독성)
                  ),
                ),

                const SizedBox(height: 40),

                // 이름 입력 카드
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFieldCustom(
                    labelText: '이름',
                    hintText: '홍길동',
                    controller: _nameController,
                    validator: _validateName,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 24),

                // 관계 단계 선택 카드
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
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
                      Text(
                        '관계 단계',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 관계 단계 선택 버튼들
                      ..._relationshipStages.entries.map((entry) {
                        final isSelected =
                            _selectedRelationshipStage == entry.key;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedRelationshipStage = entry.key;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      )
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 완료 버튼
                PrimaryButton(
                  text: '완료',
                  onPressed: _saveProfile,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
