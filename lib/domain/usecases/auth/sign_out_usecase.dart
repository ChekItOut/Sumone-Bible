import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

/// 로그아웃 UseCase
///
/// 단일 책임: 현재 사용자를 로그아웃시키기
class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  /// 로그아웃 실행
  ///
  /// 파라미터 없음
  ///
  /// Returns:
  /// - Right(Unit): 로그아웃 성공
  /// - Left(Failure): 로그아웃 실패
  Future<Either<Failure, Unit>> call() async {
    return await repository.signOut();
  }
}
