/// Logger - 로깅 유틸리티
///
/// print() 대신 사용하는 구조화된 로그 시스템
///
/// 예시:
/// ```dart
/// logger.info('사용자 로그인 성공: $userId');
/// logger.error('API 호출 실패', error: exception);
/// logger.debug('디버깅 정보: $data');
/// logger.warning('주의: 세션 만료 임박');
/// ```
///
/// 로그 레벨:
/// - info: 일반 정보 (✅)
/// - debug: 디버깅용 상세 정보 (🔍)
/// - error: 에러 발생 (❌)
/// - warning: 경고 (⚠️)
class Logger {
  /// 일반 정보 로그
  ///
  /// 앱의 주요 이벤트나 사용자 액션을 기록할 때 사용
  /// 예: 로그인 성공, 데이터 로드 완료, 화면 이동 등
  static void info(String message) {
    print('ℹ️ [INFO] $message');
  }

  /// 디버깅 로그
  ///
  /// 개발 중 상세한 정보를 확인할 때 사용
  /// 예: API 요청/응답, 상태 변경, 변수 값 등
  static void debug(String message) {
    print('🔍 [DEBUG] $message');
  }

  /// 에러 로그
  ///
  /// 예외나 에러가 발생했을 때 사용
  /// 예: API 호출 실패, 인증 에러, 데이터 파싱 실패 등
  ///
  /// [message] 에러 설명
  /// [error] 선택적 에러 객체 (Exception, Error 등)
  static void error(String message, {Object? error}) {
    print('❌ [ERROR] $message${error != null ? ": $error" : ""}');
  }

  /// 경고 로그
  ///
  /// 잠재적 문제나 주의가 필요한 상황에서 사용
  /// 예: 세션 만료 임박, 네트워크 느림, Deprecated API 사용 등
  static void warning(String message) {
    print('⚠️ [WARNING] $message');
  }
}

/// 전역 logger 인스턴스
///
/// 사용 예시:
/// ```dart
/// import 'package:bible_sumone/core/utils/logger.dart';
///
/// logger.info('앱 시작');
/// logger.error('로그인 실패', error: exception);
/// ```
final logger = Logger();
