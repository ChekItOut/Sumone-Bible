import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/couple.dart';
import '../../repositories/couple_repository.dart';

/// 초대 수락 UseCase
///
/// 단일 책임: 초대 링크를 통해 커플 연결하기
class AcceptInviteUseCase {
  final CoupleRepository repository;

  AcceptInviteUseCase(this.repository);

  /// 초대 수락 실행
  ///
  /// [params]: 초대 수락 파라미터 (token, accepterId)
  ///
  /// Returns:
  /// - Right(Couple): 연결 성공
  /// - Left(Failure): 연결 실패
  Future<Either<Failure, Couple>> call(AcceptInviteParams params) async {
    return await repository.acceptInvite(
      token: params.token,
      accepterId: params.accepterId,
    );
  }
}

/// 초대 수락 파라미터
class AcceptInviteParams {
  final String token;
  final String accepterId;

  const AcceptInviteParams({
    required this.token,
    required this.accepterId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AcceptInviteParams &&
        other.token == token &&
        other.accepterId == accepterId;
  }

  @override
  int get hashCode => token.hashCode ^ accepterId.hashCode;
}
