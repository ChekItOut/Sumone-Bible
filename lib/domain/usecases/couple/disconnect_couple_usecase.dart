import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../repositories/couple_repository.dart';

/// 커플 연결 해제 UseCase
///
/// 단일 책임: 커플 연결 해제하기
class DisconnectCoupleUseCase {
  final CoupleRepository repository;

  DisconnectCoupleUseCase(this.repository);

  /// 커플 연결 해제 실행
  ///
  /// [params]: 연결 해제 파라미터 (coupleId, userId)
  ///
  /// Returns:
  /// - Right(Unit): 해제 성공
  /// - Left(Failure): 해제 실패
  Future<Either<Failure, Unit>> call(DisconnectCoupleParams params) async {
    return await repository.disconnectCouple(
      coupleId: params.coupleId,
      userId: params.userId,
    );
  }
}

/// 커플 연결 해제 파라미터
class DisconnectCoupleParams {
  final String coupleId;
  final String userId;

  const DisconnectCoupleParams({
    required this.coupleId,
    required this.userId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DisconnectCoupleParams &&
        other.coupleId == coupleId &&
        other.userId == userId;
  }

  @override
  int get hashCode => coupleId.hashCode ^ userId.hashCode;
}
