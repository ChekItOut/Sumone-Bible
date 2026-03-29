import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/couple.dart';
import '../../repositories/couple_repository.dart';

/// 커플 정보 조회 UseCase
///
/// 단일 책임: 사용자가 속한 커플 정보 가져오기
class GetCoupleUseCase {
  final CoupleRepository repository;

  GetCoupleUseCase(this.repository);

  /// 커플 정보 조회 실행
  ///
  /// [userId]: 조회할 사용자 ID
  ///
  /// Returns:
  /// - Right(Couple): 조회 성공
  /// - Left(Failure): 조회 실패 또는 커플 정보 없음
  Future<Either<Failure, Couple>> call(String userId) async {
    return await repository.getCouple(userId);
  }
}
