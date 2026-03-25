import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// 현재 사용자 조회 UseCase
///
/// 단일 책임: 현재 로그인한 사용자 정보 가져오기
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// 현재 사용자 조회 실행
  ///
  /// 파라미터 없음
  ///
  /// Returns:
  /// - Right(User): 로그인된 사용자
  /// - Left(Failure): 로그인 상태가 아니거나 에러 발생
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}
