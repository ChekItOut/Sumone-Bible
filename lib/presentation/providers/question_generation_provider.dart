import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/network/dio_provider.dart';
import '../../data/datasources/gemini_api_datasource.dart';
import '../../core/utils/verse_extractor.dart';
import '../../core/utils/question_templates.dart';
import '../../core/utils/question_quality_filter.dart';
import '../../data/services/question_generation_service.dart';
import '../../data/services/pastor_review_service.dart';

/// Gemini API DataSource Provider
final geminiApiDataSourceProvider = Provider<GeminiApiDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return GeminiApiDataSource(dio);
});

/// VerseExtractor Provider
final verseExtractorProvider = Provider<VerseExtractor>((ref) {
  return VerseExtractor();
});

/// QuestionTemplates Provider
final questionTemplatesProvider = Provider<QuestionTemplates>((ref) {
  return QuestionTemplates();
});

/// QuestionQualityFilter Provider
final questionQualityFilterProvider = Provider<QuestionQualityFilter>((ref) {
  return QuestionQualityFilter();
});

/// QuestionGenerationService Provider
final questionGenerationServiceProvider = Provider<QuestionGenerationService>((
  ref,
) {
  final geminiDataSource = ref.watch(geminiApiDataSourceProvider);
  final verseExtractor = ref.watch(verseExtractorProvider);
  final questionTemplates = ref.watch(questionTemplatesProvider);

  return QuestionGenerationService(
    geminiDataSource,
    verseExtractor,
    questionTemplates,
  );
});

/// PastorReviewService Provider
final pastorReviewServiceProvider = Provider<PastorReviewService>((ref) {
  final supabase = Supabase.instance.client;
  return PastorReviewService(supabase);
});

/// 질문 생성 상태 Provider
///
/// 사용 예시:
/// ```dart
/// final questionAsync = ref.watch(generateQuestionProvider(params));
/// questionAsync.when(
///   data: (question) => Text(question),
///   loading: () => CircularProgressIndicator(),
///   error: (err, stack) => Text('오류: $err'),
/// );
/// ```
final generateQuestionProvider =
    FutureProvider.family<String, QuestionGenerationParams>((
      ref,
      params,
    ) async {
      final service = ref.watch(questionGenerationServiceProvider);
      final qualityFilter = ref.watch(questionQualityFilterProvider);
      final reviewService = ref.watch(pastorReviewServiceProvider);

      // 1. 승인된 질문이 있는지 먼저 확인 (베타 테스트)
      if (params.verseId != null) {
        final approvedQuestion = await reviewService.getApprovedQuestion(
          params.verseId!,
        );
        if (approvedQuestion != null) {
          return approvedQuestion;
        }
      }

      // 2. 새로운 질문 생성
      final generatedQuestion = await service.generateQuestion(
        verses: params.verses,
        relationshipStage: params.relationshipStage,
        topic: params.topic,
        bookName: params.bookName,
      );

      // 3. 품질 검사
      final qualityResult = qualityFilter.checkQuality(generatedQuestion);

      if (!qualityResult.isValid) {
        // 품질 미달 시 개선 시도
        final improvedQuestion = qualityFilter.improveQuestion(
          generatedQuestion,
        );

        // 재검사
        final recheck = qualityFilter.checkQuality(improvedQuestion);
        if (recheck.isValid) {
          // 검토 제출 (비동기, 결과 대기 안 함)
          if (params.verseId != null) {
            _submitForReviewInBackground(
              reviewService: reviewService,
              verseId: params.verseId!,
              question: improvedQuestion,
              verses: params.verses,
            );
          }

          return improvedQuestion;
        } else {
          // 여전히 미달이면 템플릿 사용
          return ref
              .watch(questionTemplatesProvider)
              .generateTemplateQuestion(
                topic: params.topic,
                relationshipStage: params.relationshipStage,
                bookName: params.bookName,
              );
        }
      }

      // 4. 검토 제출 (백그라운드)
      if (params.verseId != null) {
        _submitForReviewInBackground(
          reviewService: reviewService,
          verseId: params.verseId!,
          question: generatedQuestion,
          verses: params.verses,
        );
      }

      return generatedQuestion;
    });

/// 백그라운드 검토 제출 (Fire and Forget)
Future<void> _submitForReviewInBackground({
  required PastorReviewService reviewService,
  required String verseId,
  required String question,
  required List<String> verses,
}) async {
  try {
    // 생성 방법 판별
    final verseCount = verses.length;
    final method = verseCount <= 5
        ? 'gemini_full'
        : verseCount <= 50
        ? 'gemini_key'
        : 'template';

    await reviewService.submitForReview(
      verseId: verseId,
      question: question,
      generationMethod: method,
      metadata: {'verse_count': verseCount},
    );
  } catch (e) {
    // 검토 제출 실패는 무시 (사용자 경험에 영향 안 줌)
    print('⚠️  검토 제출 실패: $e');
  }
}

/// 질문 생성 파라미터
class QuestionGenerationParams {
  final List<String> verses;
  final String relationshipStage;
  final String? topic;
  final String? bookName;
  final String? verseId; // 검토용

  QuestionGenerationParams({
    required this.verses,
    required this.relationshipStage,
    this.topic,
    this.bookName,
    this.verseId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionGenerationParams &&
        other.verses.join() == verses.join() &&
        other.relationshipStage == relationshipStage &&
        other.topic == topic &&
        other.bookName == bookName &&
        other.verseId == verseId;
  }

  @override
  int get hashCode {
    return verses.join().hashCode ^
        relationshipStage.hashCode ^
        (topic?.hashCode ?? 0) ^
        (bookName?.hashCode ?? 0) ^
        (verseId?.hashCode ?? 0);
  }
}
