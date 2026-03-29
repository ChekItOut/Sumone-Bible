import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/invite_link.dart';
import '../../repositories/couple_repository.dart';

/// 초대 링크 생성 UseCase
///
/// 단일 책임: 파트너를 초대하기 위한 링크 생성
class CreateInviteLinkUseCase {
  final CoupleRepository repository;

  CreateInviteLinkUseCase(this.repository);

  /// 초대 링크 생성 실행
  ///
  /// [userId]: 초대를 생성하는 사용자 ID
  ///
  /// Returns:
  /// - Right(InviteLink): 생성 성공
  /// - Left(Failure): 생성 실패
  Future<Either<Failure, InviteLink>> call(String userId) async {
    return await repository.createInviteLink(userId);
  }
}
