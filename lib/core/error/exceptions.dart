// 앱 전체에서 사용하는 Exception 타입 정의
//
// DataSource 레이어에서 발생하는 예외들을 정의
// Repository에서 이 Exception들을 catch하여 Failure로 변환함

/// 기본 Exception 클래스
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;

  const AppException(this.message, {this.originalError});

  @override
  String toString() => message;
}

/// 인증 관련 예외
class AuthException extends AppException {
  final String? code;

  const AuthException(String message, {this.code, dynamic originalError})
    : super(message, originalError: originalError);
}

/// 네트워크 관련 예외
class NetworkException extends AppException {
  const NetworkException({
    String message = 'Network connection failed',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 서버 관련 예외
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
    String message, {
    this.statusCode,
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 데이터베이스 관련 예외
class DatabaseException extends AppException {
  final String? code;

  const DatabaseException(String message, {this.code, dynamic originalError})
    : super(message, originalError: originalError);
}

/// 캐시 관련 예외
class CacheException extends AppException {
  const CacheException({
    String message = 'Cache operation failed',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 데이터 파싱 예외
class ParsingException extends AppException {
  const ParsingException({
    String message = 'Failed to parse data',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 입력 값 검증 예외
class ValidationException extends AppException {
  const ValidationException(String message) : super(message);
}
