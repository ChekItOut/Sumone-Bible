import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// 이메일/비밀번호 회원가입 UseCase
///
/// 단일 책임: 이메일/비밀번호로 회원가입하기
class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  /// 회원가입 실행
  ///
  /// [params]: 회원가입 파라미터 (email, password)
  ///
  /// Returns:
  /// - Right(User): 회원가입 성공
  /// - Left(Failure): 회원가입 실패
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUpWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

/// 회원가입 파라미터
class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignUpParams &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
