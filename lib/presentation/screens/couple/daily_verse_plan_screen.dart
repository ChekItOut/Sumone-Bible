import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/logger.dart';
import '../../../domain/entities/daily_verse_plan.dart';
import '../../providers/couple_provider.dart';
import '../../providers/couple_state.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/loading/loading_indicator.dart';
import 'widgets/amount_selector.dart';
import 'widgets/book_selector.dart';
import 'widgets/plan_preview.dart';

/// 일일 말씀 플랜 설정 화면
///
/// 함께 읽을 성경 플랜 설정
/// - 절/장 단위 선택
/// - 하루 분량 입력
/// - 시작 성경 선택
/// 참조: docs/roadmap.md Task 1.3
class DailyVersePlanScreen extends ConsumerStatefulWidget {
  const DailyVersePlanScreen({super.key});

  @override
  ConsumerState<DailyVersePlanScreen> createState() =>
      _DailyVersePlanScreenState();
}

class _DailyVersePlanScreenState extends ConsumerState<DailyVersePlanScreen> {
  // 폼 상태
  String _selectedBook = '창세기';
  int _dailyAmount = 3;
  String _amountType = 'verse'; // 'verse' | 'chapter'

  @override
  void initState() {
    super.initState();
    _loadExistingPlan();
  }

  /// 기존 플랜 로드 (있으면 pre-fill)
  void _loadExistingPlan() {
    final coupleState = ref.read(coupleProvider);
    final existingPlan = coupleState.couple?.dailyVersePlan;

    if (existingPlan != null) {
      setState(() {
        _selectedBook = existingPlan.startBook;
        _dailyAmount = existingPlan.dailyAmount;
        _amountType = existingPlan.dailyAmountType;
      });

      logger.info(
        'DailyVersePlanScreen: 기존 플랜 로드됨 - $_selectedBook, $_dailyAmount $_amountType',
      );
    }
  }

  /// 플랜 저장 및 시작
  Future<void> _savePlan() async {
    final coupleState = ref.read(coupleProvider);
    final couple = coupleState.couple;

    if (couple == null) {
      logger.warning('DailyVersePlanScreen: 커플 정보 없음');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('커플 정보를 찾을 수 없습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // 플랜 생성
    final plan = DailyVersePlan(
      startBook: _selectedBook,
      dailyAmount: _dailyAmount,
      dailyAmountType: _amountType,
      currentBook: _selectedBook,
      currentChapter: 1,
      currentVerse: 1,
      startedAt: DateTime.now(),
    );

    // 플랜 업데이트
    await ref
        .read(coupleProvider.notifier)
        .updateDailyVersePlan(coupleId: couple.coupleId, plan: plan);

    final updatedState = ref.read(coupleProvider);

    if (mounted) {
      if (updatedState.hasError) {
        // 에러 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updatedState.error!),
            backgroundColor: Colors.red,
          ),
        );
      } else if (updatedState.couple?.hasPlan == true) {
        // 성공: 홈 화면으로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('플랜이 설정되었습니다! 이제 함께 성경을 읽어보세요 📖'),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coupleState = ref.watch(coupleProvider);
    final isLoading = coupleState.isLoading;

    return Scaffold(
      appBar: CustomAppBar(
        title: coupleState.couple?.hasPlan == true
            ? 'Daily Verse 플랜 변경'
            : 'Daily Verse 플랜 설정',
        showBackButton: true,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: LoadingIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 설명
                    _buildDescription(context),
                    const SizedBox(height: 24),

                    // 하루 분량 선택
                    AmountSelector(
                      selectedType: _amountType,
                      amount: _dailyAmount,
                      onTypeChanged: (type) {
                        setState(() {
                          _amountType = type;
                          // 타입 변경 시 기본값으로 재설정
                          _dailyAmount = type == 'verse' ? 3 : 1;
                        });
                      },
                      onAmountChanged: (amount) {
                        setState(() {
                          _dailyAmount = amount;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // 시작 성경 선택
                    BookSelector(
                      selectedBook: _selectedBook,
                      onBookChanged: (book) {
                        setState(() {
                          _selectedBook = book;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // 플랜 미리보기
                    PlanPreview(
                      selectedBook: _selectedBook,
                      dailyAmount: _dailyAmount,
                      dailyAmountType: _amountType,
                    ),
                    const SizedBox(height: 24),

                    // 저장 버튼
                    PrimaryButton(
                      text: coupleState.couple?.hasPlan == true
                          ? '플랜 변경하기'
                          : '저장하고 시작하기',
                      onPressed: _savePlan,
                      icon: Icons.check_circle,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// 설명 섹션
  Widget _buildDescription(BuildContext context) {
    return Container(
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
              Icon(Icons.info_outline, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                '함께 읽을 플랜을 설정하세요',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '커플이 함께 읽을 성경과 하루 분량을 설정합니다.\n'
            '설정한 플랜에 따라 매일 새로운 말씀이 도착합니다.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.blue[800]),
          ),
        ],
      ),
    );
  }
}
