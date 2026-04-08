import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/daily_verse.dart';
import '../entities/response.dart';

/// 말씀 Repository 인터페이스 (Domain Layer)
///
/// 일일 말씀 및 답변 데이터 작업을 위한 추상 인터페이스
/// Clean Architecture의 Dependency Inversion 원칙에 따라
/// Domain Layer가 Data Layer를 의존하지 않도록 인터페이스로 정의
abstract class VerseRepository {
  /// 오늘의 말씀 조회
  ///
  /// Returns: Either<Failure, DailyVerse>
  ///   - Right: 오늘의 말씀
  ///   - Left: 에러 (VerseFailure.notFound(), DatabaseFailure 등)
  Future<Either<Failure, DailyVerse>> getTodayVerse();

  /// 말씀 히스토리 조회
  ///
  /// [coupleId] 커플 ID
  /// [limit] 조회할 개수
  /// Returns: Either<Failure, List<DailyVerse>>
  ///   - Right: 최근 말씀 리스트 (날짜 내림차순)
  ///   - Left: 에러 (DatabaseFailure 등)
  Future<Either<Failure, List<DailyVerse>>> getVerseHistory(
    String coupleId,
    int limit,
  );

  /// 답변 제출 (생성 또는 업데이트)
  ///
  /// [verseId] 말씀 ID
  /// [userId] 사용자 ID
  /// [coupleId] 커플 ID
  /// [content] 답변 내용
  /// Returns: Either<Failure, Unit>
  ///   - Right: Unit (성공)
  ///   - Left: 에러 (DatabaseFailure 등)
  Future<Either<Failure, Unit>> submitResponse({
    required String verseId,
    required String userId,
    required String coupleId,
    required String content,
  });

  /// 답변 실시간 감시 (커플의 답변 모두)
  ///
  /// [verseId] 말씀 ID
  /// [coupleId] 커플 ID
  /// Returns: Stream<Either<Failure, List<Response>>>
  ///   - Stream: 실시간 답변 리스트
  Stream<Either<Failure, List<Response>>> watchResponses(
    String verseId,
    String coupleId,
  );

  /// 특정 말씀에 대한 내 답변 조회
  ///
  /// [verseId] 말씀 ID
  /// [userId] 사용자 ID
  /// Returns: Either<Failure, Response?>
  ///   - Right: ResponseModel (없으면 null)
  ///   - Left: 에러 (DatabaseFailure 등)
  Future<Either<Failure, Response?>> getMyResponse({
    required String verseId,
    required String userId,
  });
}
