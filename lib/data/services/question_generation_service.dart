import 'package:logger/logger.dart';
import '../datasources/gemini_api_datasource.dart';
import '../../core/utils/verse_extractor.dart';
import '../../core/utils/question_templates.dart';

/// 질문 생성 서비스
///
/// 책임:
/// - 성경 구절 분량에 따른 3단계 처리
/// - Gemini API 비용 최적화
/// - 질문 생성 전략 선택
///
/// 전략:
/// - 5절 이하: 전체 텍스트 → Gemini
/// - 6-50절: 핵심 3-5개 추출 → Gemini
/// - 51절 이상: 템플릿 질문 (Gemini 안 씀)
class QuestionGenerationService {
  final GeminiApiDataSource _geminiDataSource;
  final VerseExtractor _verseExtractor;
  final QuestionTemplates _questionTemplates;
  final Logger _logger = Logger();

  QuestionGenerationService(
    this._geminiDataSource,
    this._verseExtractor,
    this._questionTemplates,
  );

  /// 질문 생성 (분량별 자동 처리)
  ///
  /// [verses]: 성경 구절 리스트
  /// [relationshipStage]: 관계 단계 ('dating', 'engaged', 'married')
  /// [topic]: 주제 (선택)
  /// [bookName]: 성경 책 이름 (선택)
  ///
  /// Returns: 생성된 질문 문자열
  ///
  /// Throws:
  /// - [QuestionGenerationException] 질문 생성 실패
  Future<String> generateQuestion({
    required List<String> verses,
    required String relationshipStage,
    String? topic,
    String? bookName,
  }) async {
    if (verses.isEmpty) {
      throw QuestionGenerationException('구절이 비어있습니다.');
    }

    final verseCount = verses.length;
    _logger.i('📝 질문 생성 시작: $verseCount절');

    try {
      // 분량별 전략 선택
      if (verseCount <= 5) {
        // 전략 1: 전체 텍스트 → Gemini
        return await _generateWithFullText(
          verses: verses,
          relationshipStage: relationshipStage,
          topic: topic,
        );
      } else if (verseCount <= 50) {
        // 전략 2: 핵심 추출 → Gemini
        return await _generateWithKeyVerses(
          verses: verses,
          relationshipStage: relationshipStage,
          topic: topic,
        );
      } else {
        // 전략 3: 템플릿 질문
        return _generateWithTemplate(
          relationshipStage: relationshipStage,
          topic: topic,
          bookName: bookName,
        );
      }
    } catch (e) {
      _logger.e('❌ 질문 생성 실패', error: e);

      // 폴백: 템플릿 질문 사용
      _logger.w('⚠️  폴백: 템플릿 질문 사용');
      return _generateWithTemplate(
        relationshipStage: relationshipStage,
        topic: topic,
        bookName: bookName,
      );
    }
  }

  /// 전략 1: 전체 텍스트 → Gemini (5절 이하)
  Future<String> _generateWithFullText({
    required List<String> verses,
    required String relationshipStage,
    String? topic,
  }) async {
    _logger.i('🤖 전략 1: 전체 텍스트 → Gemini');

    final fullText = verses.join(' ');

    return await _geminiDataSource.generateQuestion(
      verseText: fullText,
      relationshipStage: relationshipStage,
      context: topic != null ? '주제: $topic' : null,
    );
  }

  /// 전략 2: 핵심 추출 → Gemini (6-50절)
  Future<String> _generateWithKeyVerses({
    required List<String> verses,
    required String relationshipStage,
    String? topic,
  }) async {
    _logger.i('🎯 전략 2: 핵심 추출 → Gemini');

    // 핵심 구절 3-5개 추출
    final keyVerses = _verseExtractor.extractKeyVerses(verses, maxCount: 5);

    _logger.i('✅ 핵심 구절 추출 완료: ${keyVerses.length}개');

    final keyText = keyVerses.join(' ');

    return await _geminiDataSource.generateQuestion(
      verseText: keyText,
      relationshipStage: relationshipStage,
      context: topic != null
          ? '주제: $topic (긴 구절 중 핵심만 추출)'
          : '긴 구절 중 핵심만 추출',
    );
  }

  /// 전략 3: 템플릿 질문 (51절 이상)
  String _generateWithTemplate({
    required String relationshipStage,
    String? topic,
    String? bookName,
  }) {
    _logger.i('📝 전략 3: 템플릿 질문 (Gemini 안 씀)');

    return _questionTemplates.generateTemplateQuestion(
      topic: topic,
      relationshipStage: relationshipStage,
      bookName: bookName,
    );
  }

  /// 질문 생성 비용 추정
  ///
  /// [verseCount]: 구절 수
  ///
  /// Returns: 비용 구분 ('free', 'low', 'high')
  String estimateCost(int verseCount) {
    if (verseCount <= 5) {
      return 'high'; // 전체 텍스트 → Gemini
    } else if (verseCount <= 50) {
      return 'low'; // 핵심만 → Gemini
    } else {
      return 'free'; // 템플릿만
    }
  }

  /// 질문 생성 전략 설명
  ///
  /// [verseCount]: 구절 수
  ///
  /// Returns: 전략 설명 문자열
  String getStrategyDescription(int verseCount) {
    if (verseCount <= 5) {
      return '전체 텍스트를 AI로 분석하여 맞춤 질문을 생성합니다.';
    } else if (verseCount <= 50) {
      return '핵심 구절을 추출하여 AI로 질문을 생성합니다. (비용 절감)';
    } else {
      return '템플릿 질문을 사용합니다. (무료, 목회자 검수 완료)';
    }
  }
}

/// 질문 생성 예외
class QuestionGenerationException implements Exception {
  final String message;

  QuestionGenerationException(this.message);

  @override
  String toString() => 'QuestionGenerationException: $message';
}
