import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/couple.dart';
import '../entities/daily_verse_plan.dart';
import '../entities/invite_link.dart';

/// 커플 Repository 인터페이스 (Domain Layer)
///
/// 커플 데이터 작업을 위한 추상 인터페이스
/// Clean Architecture의 Dependency Inversion 원칙에 따라
/// Domain Layer가 Data Layer를 의존하지 않도록 인터페이스로 정의
abstract class CoupleRepository {
  /// 초대 링크 생성
  ///
  /// [userId] 초대를 생성하는 사용자 ID
  /// Returns: Either<Failure, InviteLink>
  ///   - Right: 생성된 초대 링크
  ///   - Left: 에러 (DatabaseFailure, NetworkFailure 등)
  Future<Either<Failure, InviteLink>> createInviteLink(String userId);

  /// 초대 수락 (커플 연결)
  ///
  /// [token] 초대 링크 토큰
  /// [accepterId] 초대를 수락하는 사용자 ID
  /// Returns: Either<Failure, Couple>
  ///   - Right: 생성된 커플 정보
  ///   - Left: 에러 (CoupleFailure, DatabaseFailure 등)
  ///
  /// Exceptions:
  ///   - CoupleFailure.inviteLinkExpired(): 초대 링크 만료
  ///   - CoupleFailure.invalidInviteLink(): 유효하지 않은 링크
  ///   - CoupleFailure.alreadyConnected(): 이미 연결됨
  Future<Either<Failure, Couple>> acceptInvite({
    required String token,
    required String accepterId,
  });

  /// 커플 정보 조회
  ///
  /// [userId] 조회할 사용자 ID
  /// Returns: Either<Failure, Couple>
  ///   - Right: 사용자가 속한 커플 정보
  ///   - Left: 에러 (CoupleFailure.notFound() 등)
  ///
  /// Note: 사용자가 커플에 연결되지 않은 경우 Left(CoupleFailure.notFound()) 반환
  Future<Either<Failure, Couple>> getCouple(String userId);

  /// 커플 연결 해제
  ///
  /// [coupleId] 해제할 커플 ID
  /// [userId] 해제를 요청하는 사용자 ID (권한 확인용)
  /// Returns: Either<Failure, Unit>
  ///   - Right: Unit (성공)
  ///   - Left: 에러 (CoupleFailure.unauthorized() 등)
  ///
  /// Note:
  ///   - 커플의 user1 또는 user2만 해제 가능
  ///   - 해제 시 양쪽 사용자의 couple_id가 모두 NULL로 변경
  ///   - couples 테이블에서 해당 커플 데이터 삭제 (CASCADE로 관련 데이터도 삭제)
  Future<Either<Failure, Unit>> disconnectCouple({
    required String coupleId,
    required String userId,
  });

  /// 일일 말씀 플랜 업데이트
  ///
  /// [coupleId] 플랜을 업데이트할 커플 ID
  /// [plan] 새로운 플랜 정보
  /// Returns: Either<Failure, Couple>
  ///   - Right: 업데이트된 커플 정보
  ///   - Left: 에러 (DatabaseFailure 등)
  Future<Either<Failure, Couple>> updateDailyVersePlan({
    required String coupleId,
    required DailyVersePlan plan,
  });
}
