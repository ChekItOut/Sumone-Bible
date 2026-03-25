import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Google OAuth 로그인 UseCase
///
/// 단일 책임: Google 계정으로 로그인하기
class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  /// Google 로그인 실행
  ///
  /// 파라미터 없음 (Google OAuth 플로우가 자동으로 처리)
  ///
  /// Returns:
  /// - Right(User): 로그인 성공
  /// - Left(Failure): 로그인 실패 또는 취소
  Future<Either<Failure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}
