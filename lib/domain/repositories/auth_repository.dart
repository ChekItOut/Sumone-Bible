import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/user.dart';

/// 인증 관련 데이터 작업을 정의하는 Repository 인터페이스
///
/// Domain Layer에서 정의하고, Data Layer에서 구현함
/// 이를 통해 Domain이 Data의 구체적인 구현에 의존하지 않음 (Dependency Inversion)
abstract class AuthRepository {
  /// 현재 로그인한 사용자 가져오기
  ///
  /// Returns:
  /// - Right(User): 로그인된 사용자
  /// - Left(Failure): 로그인 상태가 아니거나 에러 발생
  Future<Either<Failure, User>> getCurrentUser();

  /// 이메일/비밀번호로 로그인
  ///
  /// [email]: 사용자 이메일
  /// [password]: 비밀번호
  ///
  /// Returns:
  /// - Right(User): 로그인 성공
  /// - Left(AuthFailure): 로그인 실패 (잘못된 이메일/비밀번호)
  /// - Left(NetworkFailure): 네트워크 연결 실패
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Google OAuth로 로그인
  ///
  /// Returns:
  /// - Right(User): 로그인 성공
  /// - Left(AuthFailure): 로그인 실패 또는 취소
  /// - Left(NetworkFailure): 네트워크 연결 실패
  Future<Either<Failure, User>> signInWithGoogle();

  /// 이메일/비밀번호로 회원가입
  ///
  /// [email]: 사용자 이메일
  /// [password]: 비밀번호
  ///
  /// Returns:
  /// - Right(User): 회원가입 성공
  /// - Left(AuthFailure): 회원가입 실패 (이미 존재하는 이메일 등)
  /// - Left(NetworkFailure): 네트워크 연결 실패
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
  });

  /// 로그아웃
  ///
  /// Returns:
  /// - Right(Unit): 로그아웃 성공
  /// - Left(Failure): 로그아웃 실패
  Future<Either<Failure, Unit>> signOut();

  /// 인증 상태 변경 스트림
  ///
  /// 로그인/로그아웃 시 자동으로 상태 전파
  ///
  /// Returns:
  /// - Stream<User?>: 로그인 상태면 User, 아니면 null
  Stream<User?> authStateChanges();
}
