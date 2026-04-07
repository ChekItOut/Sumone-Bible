import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/couple.dart';
import '../../entities/daily_verse_plan.dart';
import '../../repositories/couple_repository.dart';

/// 일일 말씀 플랜 업데이트 UseCase
///
/// 단일 책임: 커플의 일일 말씀 플랜 설정/변경하기
class UpdateDailyVersePlanUseCase {
  final CoupleRepository repository;

  UpdateDailyVersePlanUseCase(this.repository);

  /// 플랜 업데이트 실행
  ///
  /// [params]: 플랜 업데이트 파라미터 (coupleId, plan)
  ///
  /// Returns:
  /// - Right(Couple): 업데이트 성공
  /// - Left(Failure): 업데이트 실패
  Future<Either<Failure, Couple>> call(
    UpdateDailyVersePlanParams params,
  ) async {
    return await repository.updateDailyVersePlan(
      coupleId: params.coupleId,
      plan: params.plan,
    );
  }
}

/// 일일 말씀 플랜 업데이트 파라미터
class UpdateDailyVersePlanParams {
  final String coupleId;
  final DailyVersePlan plan;

  const UpdateDailyVersePlanParams({
    required this.coupleId,
    required this.plan,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateDailyVersePlanParams &&
        other.coupleId == coupleId &&
        other.plan == plan;
  }

  @override
  int get hashCode => coupleId.hashCode ^ plan.hashCode;
}
