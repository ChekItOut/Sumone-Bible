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

// ============================================================
// 커플 매칭 관련 예외 (Phase 1.3)
// ============================================================

/// 커플 정보를 찾을 수 없음
class NoCoupleException extends AppException {
  const NoCoupleException({
    String message = 'Couple not found',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 초대 링크가 만료됨
class ExpiredInviteLinkException extends AppException {
  const ExpiredInviteLinkException({
    String message = 'Invite link has expired',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 유효하지 않은 초대 링크
class InvalidInviteLinkException extends AppException {
  const InvalidInviteLinkException({
    String message = 'Invalid invite link',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 이미 다른 커플과 연결됨
class AlreadyConnectedException extends AppException {
  const AlreadyConnectedException({
    String message = 'Already connected to another couple',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 권한이 없음 (커플 작업 시)
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'Unauthorized operation',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

// ============================================================
// 성경 데이터 관련 예외 (Phase 2.1)
// ============================================================

/// 성경 데이터 관련 예외
class BibleDataException extends AppException {
  const BibleDataException({
    String message = 'Bible data operation failed',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}

/// 일일 말씀을 찾을 수 없음
class VerseNotFoundException extends AppException {
  const VerseNotFoundException({
    String message = 'Daily verse not found',
    dynamic originalError,
  }) : super(message, originalError: originalError);
}
