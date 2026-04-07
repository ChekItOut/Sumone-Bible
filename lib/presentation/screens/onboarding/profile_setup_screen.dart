import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../core/utils/logger.dart';
import '../../../data/datasources/supabase_auth_datasource.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/text_field_custom.dart';

/// 프로필 설정 화면 (확장 버전)
///
/// 온보딩 완료 후 사용자 프로필 설정
/// - 프로필 사진
/// - 이름
/// - 생년월일
/// - 관계 단계
/// - 사귀기 시작한 날짜
/// - 결혼 날짜 (married인 경우만)
///
/// 참조: docs/prd.md 섹션 F-002
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();

  // 상태 변수
  String? _selectedRelationshipStage;
  DateTime? _birthDate;
  DateTime? _relationshipStartDate;
  DateTime? _marriageDate;
  XFile? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // NOTE: 온보딩에서 이미 로그인 확인했으므로 _checkAuthStatus() 불필요
    // 이 화면에 도달했다는 것은 이미 인증된 상태임을 의미
  }

  // 관계 단계 옵션
  final Map<String, String> _relationshipStages = {
    'dating': '연애 중',
    'engaged': '약혼함',
    'married': '결혼함',
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 이름 유효성 검증
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

  /// 프로필 사진 선택
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImage = image;
        });
      }
    } catch (e) {
      logger.error('이미지 선택 실패', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지를 선택할 수 없습니다: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 날짜 선택 다이얼로그
  Future<void> _selectDate({
    required String title,
    required Function(DateTime) onDateSelected,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime.now(),
      locale: const Locale('ko', 'KR'),
      helpText: title,
      cancelText: '취소',
      confirmText: '확인',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  /// 프로필 저장
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 필수 항목 검증
    if (_selectedRelationshipStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('관계 단계를 선택해주세요'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('생년월일을 선택해주세요'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_relationshipStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사귀기 시작한 날짜를 선택해주세요'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // married인 경우 결혼 날짜 필수
    if (_selectedRelationshipStage == 'married' && _marriageDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('결혼 날짜를 선택해주세요'),
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

      // TODO: Phase 2 - 프로필 사진 업로드 (Supabase Storage)
      // String? profileImageUrl;
      // if (_profileImage != null) {
      //   profileImageUrl = await _uploadProfileImage(_profileImage!);
      // }

      // 1. 현재 사용자 정보 가져오기
      final currentUser = await dataSource.getCurrentUser();
      logger.info('프로필 저장 시작 - user_id: ${currentUser.id}');

      // 2. public.users 테이블 업데이트 데이터 준비
      final now = DateTime.now();
      final userUpdateData = {
        'user_id': currentUser.id,
        'name': _nameController.text.trim(),
        'relationship_stage': _selectedRelationshipStage,
        'birth_date': _birthDate!.toIso8601String().split('T')[0], // DATE 형식
        'relationship_start_date': _relationshipStartDate!
            .toIso8601String()
            .split('T')[0],
        if (_selectedRelationshipStage == 'married' && _marriageDate != null)
          'marriage_date': _marriageDate!.toIso8601String().split('T')[0],
        'created_at': now.toIso8601String(), // INSERT 시 필요
        'updated_at': now.toIso8601String(),
        // 'profile_image_url': profileImageUrl, // TODO: Phase 2
      };

      logger.debug('저장할 데이터: $userUpdateData');

      // 3. UPSERT: 존재하면 업데이트, 없으면 삽입
      await dataSource.updateUserProfile(userUpdateData);

      logger.info('✅ 프로필 저장 성공 - public.users 테이블 업데이트 완료');

      if (mounted) {
        // 프로필 설정 완료 → 홈 화면으로 직접 이동
        context.go('/home');
      }
    } catch (e) {
      logger.error('프로필 저장 실패', error: e);
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

  /// 날짜 포맷팅
  String _formatDate(DateTime date) {
    return DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(date);
  }

  /// 나이 계산
  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: '프로필 설정', centerTitle: true),
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
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  '파트너와 함께 사용할 프로필을 설정해주세요',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black87),
                ),

                const SizedBox(height: 32),

                // 프로필 사진 선택
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.primaryColor.withAlpha(51),
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : null,
                        child: _profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: AppTheme.primaryColor,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(26),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 이름 입력
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
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

                const SizedBox(height: 16),

                // 생년월일 선택
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _selectDate(
                      title: '생년월일 선택',
                      onDateSelected: (date) {
                        setState(() {
                          _birthDate = date;
                        });
                      },
                      initialDate: DateTime(1995),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cake,
                            color: _birthDate != null
                                ? AppTheme.primaryColor
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '생년월일',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _birthDate != null
                                      ? '${_formatDate(_birthDate!)} (${_calculateAge(_birthDate!)}세)'
                                      : '생년월일을 선택해주세요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _birthDate != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _birthDate != null
                                        ? AppTheme.textPrimary
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 관계 단계 선택
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '관계 단계',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ..._relationshipStages.entries.map((entry) {
                        final isSelected =
                            _selectedRelationshipStage == entry.key;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedRelationshipStage = entry.key;
                                // married가 아니면 결혼 날짜 초기화
                                if (entry.key != 'married') {
                                  _marriageDate = null;
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryColor.withAlpha(26)
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

                const SizedBox(height: 16),

                // 사귀기 시작한 날짜 선택
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _selectDate(
                      title: '사귀기 시작한 날짜',
                      onDateSelected: (date) {
                        setState(() {
                          _relationshipStartDate = date;
                        });
                      },
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: _relationshipStartDate != null
                                ? AppTheme.primaryColor
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '사귀기 시작한 날짜',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _relationshipStartDate != null
                                      ? _formatDate(_relationshipStartDate!)
                                      : '날짜를 선택해주세요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _relationshipStartDate != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _relationshipStartDate != null
                                        ? AppTheme.textPrimary
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 결혼 날짜 선택 (married인 경우만)
                if (_selectedRelationshipStage == 'married') ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _selectDate(
                        title: '결혼 날짜',
                        onDateSelected: (date) {
                          setState(() {
                            _marriageDate = date;
                          });
                        },
                        initialDate: _relationshipStartDate ?? DateTime.now(),
                        firstDate: _relationshipStartDate ?? DateTime(2000),
                        lastDate: DateTime.now(),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.celebration,
                              color: _marriageDate != null
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '결혼 날짜',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _marriageDate != null
                                        ? _formatDate(_marriageDate!)
                                        : '결혼 날짜를 선택해주세요',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: _marriageDate != null
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: _marriageDate != null
                                          ? AppTheme.textPrimary
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // 완료 버튼
                PrimaryButton(
                  text: '완료',
                  onPressed: _saveProfile,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
