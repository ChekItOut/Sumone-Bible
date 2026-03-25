// 앱 전체에서 사용하는 에러 타입 정의
//
// Clean Architecture의 일부로, 비즈니스 로직에서 발생하는
// 모든 에러를 표현하기 위한 추상 클래스와 구체적인 타입들

/// 추상 기본 Failure 클래스
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// 인증 관련 에러
///
/// 로그인, 회원가입, 로그아웃 등 인증 프로세스에서 발생하는 에러
class AuthFailure extends Failure {
  const AuthFailure(super.message);

  /// 사용자 친화적 에러 메시지 생성
  factory AuthFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const AuthFailure('이메일 형식이 올바르지 않습니다.');
      case 'user-not-found':
        return const AuthFailure('이메일 또는 비밀번호가 올바르지 않습니다.');
      case 'wrong-password':
        return const AuthFailure('이메일 또는 비밀번호가 올바르지 않습니다.');
      case 'email-already-in-use':
        return const AuthFailure('이미 사용 중인 이메일입니다.');
      case 'weak-password':
        return const AuthFailure('비밀번호는 최소 6자 이상이어야 합니다.');
      case 'user-disabled':
        return const AuthFailure('비활성화된 계정입니다. 고객센터에 문의하세요.');
      case 'operation-not-allowed':
        return const AuthFailure('허용되지 않은 작업입니다.');
      case 'account-exists-with-different-credential':
        return const AuthFailure('다른 로그인 방식으로 이미 가입된 이메일입니다.');
      case 'invalid-credential':
        return const AuthFailure('인증 정보가 유효하지 않습니다.');
      case 'invalid-verification-code':
        return const AuthFailure('인증 코드가 올바르지 않습니다.');
      case 'session-expired':
        return const AuthFailure('세션이 만료되었습니다. 다시 로그인해주세요.');
      default:
        return AuthFailure('인증 오류: $code');
    }
  }
}

/// 네트워크 관련 에러
///
/// 인터넷 연결 실패, 타임아웃 등 네트워크 문제
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '인터넷 연결을 확인해주세요.']);
}

/// 서버 관련 에러
///
/// API 서버, Supabase 서버 등 서버 측 문제
class ServerFailure extends Failure {
  const ServerFailure([super.message = '일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.']);

  factory ServerFailure.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const ServerFailure('잘못된 요청입니다.');
      case 401:
        return const ServerFailure('인증이 필요합니다. 다시 로그인해주세요.');
      case 403:
        return const ServerFailure('접근 권한이 없습니다.');
      case 404:
        return const ServerFailure('요청한 정보를 찾을 수 없습니다.');
      case 500:
        return const ServerFailure('서버 오류가 발생했습니다.');
      case 503:
        return const ServerFailure('서비스를 일시적으로 사용할 수 없습니다.');
      default:
        return ServerFailure('서버 오류 ($statusCode)');
    }
  }
}

/// 로컬 캐시/저장소 관련 에러
class CacheFailure extends Failure {
  const CacheFailure([super.message = '로컬 데이터 저장 중 오류가 발생했습니다.']);
}

/// 데이터베이스 관련 에러
///
/// Supabase 데이터베이스 작업 중 발생하는 에러
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = '데이터베이스 오류가 발생했습니다.']);

  factory DatabaseFailure.fromCode(String code) {
    switch (code) {
      case '23505': // unique_violation
        return const DatabaseFailure('이미 존재하는 데이터입니다.');
      case '23503': // foreign_key_violation
        return const DatabaseFailure('참조된 데이터를 찾을 수 없습니다.');
      case '23502': // not_null_violation
        return const DatabaseFailure('필수 정보가 누락되었습니다.');
      case '42501': // insufficient_privilege
        return const DatabaseFailure('권한이 부족합니다.');
      default:
        return DatabaseFailure('데이터베이스 오류: $code');
    }
  }
}

/// 입력 값 검증 실패
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// 예상치 못한 에러
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = '알 수 없는 오류가 발생했습니다.']);
}
