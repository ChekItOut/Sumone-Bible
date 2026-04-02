import 'package:logger/logger.dart';

/// 질문 품질 필터
///
/// 책임:
/// - 생성된 질문의 품질 검증
/// - 부적절한 질문 필터링
/// - 질문 개선 제안
class QuestionQualityFilter {
  final Logger _logger = Logger();

  /// 질문 품질 검사
  ///
  /// [question]: 검사할 질문
  ///
  /// Returns: 검사 결과 (QualityCheckResult)
  QualityCheckResult checkQuality(String question) {
    _logger.i('🔍 질문 품질 검사: ${question.substring(0, question.length > 30 ? 30 : question.length)}...');

    final issues = <String>[];
    int score = 100; // 기본 100점

    // 1. 기본 검증
    if (question.isEmpty) {
      issues.add('질문이 비어있습니다.');
      score = 0;
      return QualityCheckResult(
        isValid: false,
        score: score,
        issues: issues,
        suggestion: null,
      );
    }

    // 2. 길이 검증 (10-100자)
    if (question.length < 10) {
      issues.add('질문이 너무 짧습니다. (최소 10자)');
      score -= 30;
    } else if (question.length > 100) {
      issues.add('질문이 너무 깁니다. (최대 100자)');
      score -= 20;
    }

    // 3. 질문 형식 검증
    if (!question.contains('?') &&
        !question.contains('까') &&
        !question.contains('가요')) {
      issues.add('질문 형식이 아닙니다. 물음표(?)가 필요합니다.');
      score -= 40;
    }

    // 4. 커플 대화 적합성
    if (!_isCoupleConversationSuitable(question)) {
      issues.add('커플 대화에 적합하지 않은 질문입니다.');
      score -= 30;
    }

    // 5. 금지 단어 검사
    final bannedWords = _getBannedWords();
    for (final word in bannedWords) {
      if (question.toLowerCase().contains(word.toLowerCase())) {
        issues.add('부적절한 단어가 포함되어 있습니다: $word');
        score -= 50;
      }
    }

    // 6. 필수 요소 검사 (가점)
    if (_hasPositiveKeywords(question)) {
      score += 10;
    }

    // 7. 최종 점수 보정
    score = score.clamp(0, 100);

    // 8. 개선 제안
    String? suggestion;
    if (score < 70) {
      suggestion = _generateSuggestion(issues);
    }

    final isValid = score >= 60 && issues.isEmpty;

    _logger.i('✅ 품질 검사 완료: 점수=$score, 유효=$isValid');

    return QualityCheckResult(
      isValid: isValid,
      score: score,
      issues: issues,
      suggestion: suggestion,
    );
  }

  /// 커플 대화 적합성 검사
  bool _isCoupleConversationSuitable(String question) {
    // 긍정적 키워드
    final positiveKeywords = [
      '우리',
      '서로',
      '함께',
      '관계',
      '사랑',
      '믿음',
      '기도',
    ];

    for (final keyword in positiveKeywords) {
      if (question.contains(keyword)) {
        return true;
      }
    }

    // 단독 질문 패턴 (부정적)
    final negativePatterns = [
      '당신은',
      '너는',
      '나는',
      '혼자',
    ];

    for (final pattern in negativePatterns) {
      if (question.contains(pattern)) {
        return false;
      }
    }

    return true;
  }

  /// 금지 단어 목록
  List<String> _getBannedWords() {
    return [
      // 폭력적 단어
      '죽',
      '때리',
      '싸우',

      // 비속어 (예시, 실제로는 더 많이 추가)
      '바보',
      '멍청',

      // 부정적 단어 (과도한 경우)
      '싫어',
      '미워',
      '증오',

      // 종교적 부적절
      '저주',
      '심판',
    ];
  }

  /// 긍정적 키워드 포함 여부
  bool _hasPositiveKeywords(String question) {
    final positiveKeywords = [
      '사랑',
      '은혜',
      '축복',
      '감사',
      '기도',
      '믿음',
      '소망',
      '용서',
      '섬김',
      '겸손',
    ];

    for (final keyword in positiveKeywords) {
      if (question.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  /// 개선 제안 생성
  String _generateSuggestion(List<String> issues) {
    if (issues.isEmpty) return '';

    final suggestions = <String>[];

    for (final issue in issues) {
      if (issue.contains('짧습니다')) {
        suggestions.add('질문을 더 구체적으로 작성해보세요.');
      } else if (issue.contains('깁니다')) {
        suggestions.add('질문을 간결하게 줄여보세요.');
      } else if (issue.contains('물음표')) {
        suggestions.add('질문 끝에 "?"를 추가하거나 "-까요?" 형식으로 바꿔보세요.');
      } else if (issue.contains('적합하지')) {
        suggestions.add('"우리", "서로" 등 커플 중심의 표현을 사용해보세요.');
      } else if (issue.contains('부적절한 단어')) {
        suggestions.add('긍정적이고 건설적인 표현으로 바꿔보세요.');
      }
    }

    return suggestions.join(' ');
  }

  /// 질문 자동 개선 (간단한 수정)
  ///
  /// [question]: 원본 질문
  ///
  /// Returns: 개선된 질문
  String improveQuestion(String question) {
    String improved = question.trim();

    // 1. 물음표 추가
    if (!improved.endsWith('?') &&
        !improved.endsWith('까') &&
        !improved.endsWith('가요')) {
      if (improved.endsWith('까')) {
        improved = '$improved요?';
      } else {
        improved = '$improved?';
      }
    }

    // 2. 앞뒤 따옴표 제거
    improved = improved.replaceAll('"', '').replaceAll("'", '');

    // 3. 다중 공백 제거
    improved = improved.replaceAll(RegExp(r'\s+'), ' ');

    // 4. 줄바꿈 제거
    improved = improved.replaceAll('\n', ' ');

    return improved.trim();
  }
}

/// 품질 검사 결과
class QualityCheckResult {
  final bool isValid; // 통과 여부 (60점 이상)
  final int score; // 점수 (0-100)
  final List<String> issues; // 문제점 목록
  final String? suggestion; // 개선 제안

  QualityCheckResult({
    required this.isValid,
    required this.score,
    required this.issues,
    this.suggestion,
  });

  @override
  String toString() {
    return 'QualityCheckResult(isValid: $isValid, score: $score, issues: ${issues.length})';
  }
}
