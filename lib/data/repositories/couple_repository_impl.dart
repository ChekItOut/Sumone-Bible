import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/couple.dart';
import '../../domain/entities/daily_verse_plan.dart';
import '../../domain/entities/invite_link.dart';
import '../../domain/repositories/couple_repository.dart';
import '../datasources/supabase_couple_datasource.dart';
import '../models/daily_verse_plan_model.dart';

/// 커플 Repository 구현 (Data Layer)
///
/// CoupleRepository 인터페이스 구현
/// DataSource를 사용하여 실제 데이터 작업 수행
/// Exception → Failure 변환 및 에러 핸들링
class CoupleRepositoryImpl implements CoupleRepository {
  final SupabaseCoupleDataSource _dataSource;

  CoupleRepositoryImpl({required SupabaseCoupleDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, InviteLink>> createInviteLink(String userId) async {
    try {
      final inviteLink = await _dataSource.createInviteLink(userId);
      return Right(inviteLink.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('초대 링크 생성 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<Failure, Couple>> acceptInvite({
    required String token,
    required String accepterId,
  }) async {
    try {
      final couple = await _dataSource.acceptInvite(
        token: token,
        accepterId: accepterId,
      );
      return Right(couple.toEntity());
    } on ExpiredInviteLinkException {
      return Left(CoupleFailure.inviteLinkExpired());
    } on InvalidInviteLinkException {
      return Left(CoupleFailure.invalidInviteLink());
    } on AlreadyConnectedException {
      return Left(CoupleFailure.alreadyConnected());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('초대 수락 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<Failure, Couple>> getCouple(String userId) async {
    try {
      final couple = await _dataSource.getCouple(userId);
      return Right(couple.toEntity());
    } on NoCoupleException {
      return Left(CoupleFailure.notFound());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('커플 정보 조회 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> disconnectCouple({
    required String coupleId,
    required String userId,
  }) async {
    try {
      await _dataSource.disconnectCouple(coupleId: coupleId, userId: userId);
      return const Right(unit);
    } on UnauthorizedException {
      return Left(CoupleFailure.unauthorized());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('커플 연결 해제 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<Failure, Couple>> updateDailyVersePlan({
    required String coupleId,
    required DailyVersePlan plan,
  }) async {
    try {
      final couple = await _dataSource.updateDailyVersePlan(
        coupleId: coupleId,
        plan: DailyVersePlanModel.fromEntity(plan),
      );
      return Right(couple.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('플랜 업데이트 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }
}
