import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

/// Gemini API DataSource
///
/// 책임:
/// - Gemini API 호출 (질문 생성)
/// - 프롬프트 전송 및 응답 파싱
/// - 에러 핸들링
class GeminiApiDataSource {
  final Dio _dio;
  final Logger _logger = Logger();

  // 환경 변수
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String baseUrl = dotenv.env['GEMINI_API_URL'] ?? '';

  // API 엔드포인트
  static const String _model = 'gemini-1.5-flash';

  GeminiApiDataSource(this._dio);

  /// 성경 구절 기반 질문 생성
  ///
  /// [verseText]: 성경 구절 텍스트
  /// [relationshipStage]: 관계 단계 ('dating', 'engaged', 'married')
  /// [context]: 추가 컨텍스트 (선택)
  ///
  /// Returns: 생성된 질문 문자열
  ///
  /// Throws:
  /// - [DioException] 네트워크 오류
  /// - [GeminiApiException] API 응답 오류
  Future<String> generateQuestion({
    required String verseText,
    required String relationshipStage,
    String? context,
  }) async {
    if (apiKey.isEmpty) {
      throw GeminiApiException('GEMINI_API_KEY가 설정되지 않았습니다.');
    }

    _logger.i('🤖 Gemini API 호출: 질문 생성 시작');

    try {
      // 프롬프트 생성
      final prompt = _buildPrompt(
        verseText: verseText,
        relationshipStage: relationshipStage,
        context: context,
      );

      // API 호출
      final url = '$baseUrl/models/$_model:generateContent?key=$apiKey';

      final response = await _dio.post(
        url,
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topP': 0.9,
            'topK': 40,
            'maxOutputTokens': 200,
          },
        },
      );

      // 응답 파싱
      if (response.statusCode == 200) {
        final question = _parseResponse(response.data);
        _logger.i('✅ Gemini API 성공: ${question.substring(0, question.length > 50 ? 50 : question.length)}...');
        return question;
      } else {
        throw GeminiApiException(
          'API 호출 실패: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      _logger.e('❌ Gemini API 네트워크 오류', error: e);
      throw GeminiApiException('네트워크 오류: ${e.message}');
    } catch (e) {
      _logger.e('❌ Gemini API 알 수 없는 오류', error: e);
      throw GeminiApiException('알 수 없는 오류: $e');
    }
  }

  /// 프롬프트 생성
  String _buildPrompt({
    required String verseText,
    required String relationshipStage,
    String? context,
  }) {
    // 관계 단계별 컨텍스트
    final stageContext = {
      'dating': '연애 중인',
      'engaged': '약혼한',
      'married': '결혼한',
    }[relationshipStage] ?? '크리스천';

    return '''
당신은 크리스천 커플을 위한 성경 공부 가이드입니다.

성경 구절:
$verseText

커플 상태: $stageContext 커플
${context != null ? '추가 컨텍스트: $context\n' : ''}
위 말씀을 읽은 커플이 서로 나눌 수 있는 대화 질문 1개를 생성하세요.

요구사항:
1. 커플의 관계에 직접 적용 가능해야 함
2. 너무 무겁지 않고 자연스러운 대화 유도
3. "서로" 나눌 수 있는 질문 (한 사람만 답하는 것 X)
4. 50자 이내
5. 질문 형식으로 끝나야 함 (물음표 필수)

출력 형식:
[질문 내용만 출력, 추가 설명 없이]

예시:
- 이 말씀이 우리의 관계에 어떤 의미가 있을까요?
- 우리가 이 말씀을 실천하려면 무엇을 바꿔야 할까요?
- 이 말씀을 통해 서로에게 어떤 사랑을 보여줄 수 있을까요?
''';
  }

  /// 응답 파싱
  String _parseResponse(Map<String, dynamic> data) {
    try {
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw GeminiApiException('응답에 candidates가 없습니다.');
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      if (content == null) {
        throw GeminiApiException('응답에 content가 없습니다.');
      }

      final parts = content['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw GeminiApiException('응답에 parts가 없습니다.');
      }

      final text = parts[0]['text'] as String?;
      if (text == null || text.isEmpty) {
        throw GeminiApiException('응답에 text가 없습니다.');
      }

      // 불필요한 문자 제거
      return _cleanQuestion(text);
    } catch (e) {
      _logger.e('❌ Gemini 응답 파싱 실패', error: e);
      throw GeminiApiException('응답 파싱 실패: $e');
    }
  }

  /// 질문 정제
  String _cleanQuestion(String rawQuestion) {
    return rawQuestion
        .replaceAll('\"', '') // 따옴표 제거
        .replaceAll('*', '') // 별표 제거
        .replaceAll('\n', ' ') // 줄바꿈 공백 변환
        .trim();
  }
}

/// Gemini API 예외
class GeminiApiException implements Exception {
  final String message;

  GeminiApiException(this.message);

  @override
  String toString() => 'GeminiApiException: $message';
}
