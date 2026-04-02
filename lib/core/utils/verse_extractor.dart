import 'package:logger/logger.dart';

/// 핵심 구절 추출 유틸리티
///
/// 책임:
/// - 긴 성경 구절에서 핵심 구절 3-5개 추출
/// - 의미 있는 문장 단위로 분리
/// - 중요도 기반 선택
class VerseExtractor {
  final Logger _logger = Logger();

  /// 핵심 구절 추출
  ///
  /// [verses]: 전체 구절 리스트
  /// [maxCount]: 최대 추출 개수 (기본 5개)
  ///
  /// Returns: 추출된 핵심 구절 리스트
  ///
  /// 로직:
  /// 1. 문장 단위 분리 (마침표, 느낌표, 물음표 기준)
  /// 2. 키워드 기반 중요도 점수 계산
  /// 3. 점수 높은 순으로 maxCount개 선택
  /// 4. 원래 순서 유지하여 반환
  List<String> extractKeyVerses(List<String> verses, {int maxCount = 5}) {
    if (verses.isEmpty) return [];
    if (verses.length <= maxCount) return verses;

    _logger.i('🔍 핵심 구절 추출: ${verses.length}개 → 최대 $maxCount개');

    try {
      // 1. 각 구절에 점수 부여
      final scoredVerses = verses
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final verse = entry.value;
            final score = _calculateImportanceScore(verse);

            return _ScoredVerse(
              verse: verse,
              score: score,
              originalIndex: index,
            );
          })
          .toList();

      // 2. 점수 높은 순으로 정렬
      scoredVerses.sort((a, b) => b.score.compareTo(a.score));

      // 3. 상위 maxCount개 선택
      final selectedVerses = scoredVerses.take(maxCount).toList();

      // 4. 원래 순서로 재정렬
      selectedVerses.sort((a, b) => a.originalIndex.compareTo(b.originalIndex));

      // 5. 텍스트만 반환
      final result = selectedVerses.map((v) => v.verse).toList();

      _logger.i('✅ 핵심 구절 ${result.length}개 추출 완료');
      return result;
    } catch (e) {
      _logger.e('❌ 핵심 구절 추출 실패', error: e);
      // 실패 시 앞에서부터 maxCount개 반환
      return verses.take(maxCount).toList();
    }
  }

  /// 구절 중요도 점수 계산
  ///
  /// 점수 기준:
  /// - 키워드 포함 여부 (+10점)
  /// - 문장 길이 (적정 길이 +5점)
  /// - 특수 문자 (명령문, 질문 등 +3점)
  int _calculateImportanceScore(String verse) {
    int score = 0;

    // 1. 핵심 키워드 (+10점)
    final keywords = [
      '사랑',
      '하나님',
      '예수',
      '그리스도',
      '믿음',
      '소망',
      '은혜',
      '진리',
      '생명',
      '구원',
      '복음',
      '성령',
      '기도',
      '감사',
      '용서',
      '회개',
      '섬김',
      '겸손',
      '인내',
      '평화',
    ];

    for (final keyword in keywords) {
      if (verse.contains(keyword)) {
        score += 10;
        break; // 하나만 카운트
      }
    }

    // 2. 관계 키워드 (+8점)
    final relationshipKeywords = [
      '서로',
      '우리',
      '함께',
      '이웃',
      '형제',
      '자매',
      '친구',
      '부부',
    ];

    for (final keyword in relationshipKeywords) {
      if (verse.contains(keyword)) {
        score += 8;
        break;
      }
    }

    // 3. 적정 문장 길이 (+5점)
    final length = verse.length;
    if (length >= 20 && length <= 80) {
      score += 5;
    }

    // 4. 명령문 (+3점)
    if (verse.contains('하라') ||
        verse.contains('하십시오') ||
        verse.contains('하세요')) {
      score += 3;
    }

    // 5. 질문 (+3점)
    if (verse.contains('?') || verse.contains('가')) {
      score += 3;
    }

    // 6. 인용 (+2점)
    if (verse.contains('이르시되') ||
        verse.contains('말씀하시되') ||
        verse.contains('이르되')) {
      score += 2;
    }

    return score;
  }

  /// 문장 단위로 분리
  ///
  /// [text]: 전체 텍스트
  ///
  /// Returns: 문장 리스트
  List<String> splitSentences(String text) {
    // 마침표, 느낌표, 물음표 기준으로 분리
    final sentences = <String>[];
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      buffer.write(char);

      // 문장 종결 문자
      if (char == '.' || char == '!' || char == '?') {
        final sentence = buffer.toString().trim();
        if (sentence.isNotEmpty) {
          sentences.add(sentence);
        }
        buffer.clear();
      }
    }

    // 마지막 문장
    if (buffer.isNotEmpty) {
      final sentence = buffer.toString().trim();
      if (sentence.isNotEmpty) {
        sentences.add(sentence);
      }
    }

    return sentences;
  }
}

/// 점수가 부여된 구절
class _ScoredVerse {
  final String verse;
  final int score;
  final int originalIndex;

  _ScoredVerse({
    required this.verse,
    required this.score,
    required this.originalIndex,
  });
}
