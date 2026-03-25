import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// 이메일/비밀번호 로그인 UseCase
///
/// 단일 책임: 이메일/비밀번호로 로그인하기
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  /// 로그인 실행
  ///
  /// [params]: 로그인 파라미터 (email, password)
  ///
  /// Returns:
  /// - Right(User): 로그인 성공
  /// - Left(Failure): 로그인 실패
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

/// 로그인 파라미터
class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignInParams &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
