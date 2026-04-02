import 'dart:math';
import 'package:logger/logger.dart';

/// 템플릿 질문 시스템
///
/// 책임:
/// - 긴 성경 구절(51절 이상)용 템플릿 질문 제공
/// - Gemini API 비용 절감
/// - 주제별/관계 단계별 맞춤 질문
class QuestionTemplates {
  final Logger _logger = Logger();
  final Random _random = Random();

  /// 템플릿 질문 생성
  ///
  /// [topic]: 주제 (선택)
  /// [relationshipStage]: 관계 단계 ('dating', 'engaged', 'married')
  /// [bookName]: 성경 책 이름 (선택)
  ///
  /// Returns: 무작위로 선택된 템플릿 질문
  String generateTemplateQuestion({
    String? topic,
    required String relationshipStage,
    String? bookName,
  }) {
    _logger.i('📝 템플릿 질문 생성: topic=$topic, stage=$relationshipStage');

    // 1. 주제별 템플릿
    if (topic != null) {
      final topicQuestions = _getTopicQuestions(topic);
      if (topicQuestions.isNotEmpty) {
        return _selectRandom(topicQuestions);
      }
    }

    // 2. 관계 단계별 템플릿
    final stageQuestions = _getRelationshipQuestions(relationshipStage);
    if (stageQuestions.isNotEmpty) {
      return _selectRandom(stageQuestions);
    }

    // 3. 기본 템플릿
    return _selectRandom(_getGenericQuestions());
  }

  /// 주제별 질문 템플릿
  List<String> _getTopicQuestions(String topic) {
    final templates = <String, List<String>>{
      // 사랑
      'love': [
        '이 말씀이 우리의 사랑에 어떤 의미가 있을까요?',
        '우리가 서로를 향한 사랑을 어떻게 더 깊게 할 수 있을까요?',
        '하나님의 사랑을 우리의 관계에서 어떻게 실천할 수 있을까요?',
        '이 말씀을 통해 서로에게 어떤 사랑을 보여줄 수 있을까요?',
      ],

      // 용서
      'forgiveness': [
        '우리가 서로를 용서하는 데 어려움이 있다면 무엇일까요?',
        '이 말씀이 우리의 관계에서 용서를 어떻게 도와줄까요?',
        '서로에게 용서를 구하거나 베풀어야 할 부분이 있을까요?',
        '하나님의 용서를 경험하며 서로를 어떻게 대할 수 있을까요?',
      ],

      // 감사
      'gratitude': [
        '오늘 서로에게 감사한 점은 무엇인가요?',
        '하나님이 우리의 관계에 주신 축복은 무엇일까요?',
        '이 말씀을 통해 감사의 마음을 어떻게 키울 수 있을까요?',
        '서로에게 감사를 표현하는 방법을 새롭게 시도해볼까요?',
      ],

      // 소통
      'communication': [
        '우리의 대화에서 개선할 점은 무엇일까요?',
        '이 말씀이 우리의 소통 방식에 어떤 변화를 줄 수 있을까요?',
        '서로의 마음을 더 잘 이해하려면 무엇이 필요할까요?',
        '하나님 앞에서 진솔한 대화를 나누려면 어떻게 해야 할까요?',
      ],

      // 믿음
      'faith': [
        '우리의 믿음이 관계에 어떤 영향을 주고 있나요?',
        '이 말씀을 통해 우리의 믿음을 어떻게 성장시킬 수 있을까요?',
        '서로의 신앙을 격려하고 지지하는 방법은 무엇일까요?',
        '하나님을 중심에 둔 관계를 위해 무엇을 할 수 있을까요?',
      ],

      // 겸손
      'humility': [
        '우리가 서로에게 겸손해야 할 부분은 무엇일까요?',
        '이 말씀이 우리의 자세를 어떻게 바꿔줄 수 있을까요?',
        '서로를 섬기는 마음을 어떻게 키울 수 있을까요?',
        '그리스도의 겸손을 본받아 무엇을 실천할 수 있을까요?',
      ],

      // 인내
      'patience': [
        '우리가 서로에게 더 인내해야 할 부분은 무엇일까요?',
        '이 말씀이 어려운 순간에 어떻게 도움이 될까요?',
        '서로의 약점을 이해하고 기다려주려면 무엇이 필요할까요?',
        '하나님의 인내를 경험하며 서로를 어떻게 대할 수 있을까요?',
      ],

      // 기도
      'prayer': [
        '우리가 함께 기도해야 할 제목은 무엇인가요?',
        '이 말씀을 기도로 어떻게 실천할 수 있을까요?',
        '서로를 위해 어떤 기도가 필요할까요?',
        '하나님께 우리의 관계를 맡기는 기도를 함께 나눌까요?',
      ],
    };

    return templates[topic.toLowerCase()] ?? [];
  }

  /// 관계 단계별 질문 템플릿
  List<String> _getRelationshipQuestions(String relationshipStage) {
    final templates = <String, List<String>>{
      // 연애 중
      'dating': [
        '이 말씀이 우리의 교제에 어떤 의미가 있을까요?',
        '우리의 관계를 하나님 중심으로 만들려면 무엇을 해야 할까요?',
        '서로를 향한 순수한 사랑을 지키려면 어떻게 해야 할까요?',
        '이 말씀을 통해 서로에게 어떤 약속을 할 수 있을까요?',
      ],

      // 약혼
      'engaged': [
        '결혼을 준비하며 이 말씀이 우리에게 주는 메시지는 무엇일까요?',
        '우리의 결혼 생활을 위해 지금 준비해야 할 것은 무엇일까요?',
        '이 말씀을 결혼 서약에 어떻게 담을 수 있을까요?',
        '하나님이 우리의 결혼을 통해 이루시길 원하는 것은 무엇일까요?',
      ],

      // 결혼
      'married': [
        '이 말씀이 우리의 결혼 생활에 어떤 변화를 줄 수 있을까요?',
        '우리가 부부로서 더 성장하려면 무엇이 필요할까요?',
        '이 말씀을 우리의 가정에서 어떻게 실천할 수 있을까요?',
        '하나님이 우리 부부를 통해 이루시길 원하는 것은 무엇일까요?',
      ],
    };

    return templates[relationshipStage] ?? [];
  }

  /// 일반 질문 템플릿 (기본)
  List<String> _getGenericQuestions() {
    return [
      '이 말씀이 우리에게 전하는 메시지는 무엇일까요?',
      '우리가 이 말씀을 실천하려면 무엇을 바꿔야 할까요?',
      '이 말씀을 통해 하나님이 우리에게 원하시는 것은 무엇일까요?',
      '우리의 관계에서 이 말씀을 어떻게 적용할 수 있을까요?',
      '이 말씀이 우리의 삶에 어떤 영향을 주길 바라시나요?',
      '서로를 위해 이 말씀으로 무엇을 기도할 수 있을까요?',
      '이 말씀을 따라 살려면 어떤 결단이 필요할까요?',
      '우리가 이 말씀을 함께 지키려면 무엇을 할 수 있을까요?',
    ];
  }

  /// 무작위 선택
  String _selectRandom(List<String> questions) {
    if (questions.isEmpty) {
      return '이 말씀이 우리에게 전하는 메시지는 무엇일까요?';
    }

    final index = _random.nextInt(questions.length);
    return questions[index];
  }

  /// 모든 템플릿 질문 개수
  int get totalTemplateCount {
    int count = 0;

    // 주제별
    count += _getTopicQuestions('love').length;
    count += _getTopicQuestions('forgiveness').length;
    count += _getTopicQuestions('gratitude').length;
    count += _getTopicQuestions('communication').length;
    count += _getTopicQuestions('faith').length;
    count += _getTopicQuestions('humility').length;
    count += _getTopicQuestions('patience').length;
    count += _getTopicQuestions('prayer').length;

    // 관계 단계별
    count += _getRelationshipQuestions('dating').length;
    count += _getRelationshipQuestions('engaged').length;
    count += _getRelationshipQuestions('married').length;

    // 일반
    count += _getGenericQuestions().length;

    return count;
  }
}
