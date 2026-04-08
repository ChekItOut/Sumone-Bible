import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/daily_verse.dart';
import '../../domain/entities/response.dart';
import '../../domain/repositories/verse_repository.dart';
import '../datasources/firebase_verse_datasource.dart';

/// 말씀 Repository 구현 (Data Layer)
///
/// VerseRepository 인터페이스 구현
/// DataSource를 사용하여 실제 데이터 작업 수행
/// Exception → Failure 변환 및 에러 핸들링
///
/// NOTE: 현재는 Firebase만 지원 (Supabase는 추후 추가 예정)
class VerseRepositoryImpl implements VerseRepository {
  final FirebaseVerseDataSource _firebaseDataSource;

  VerseRepositoryImpl({required FirebaseVerseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;

  @override
  Future<Either<Failure, DailyVerse>> getTodayVerse() async {
    try {
      final verseModel = await _firebaseDataSource.getTodayVerse();
      return Right(verseModel.toEntity());
    } on VerseNotFoundException catch (e) {
      return Left(VerseFailure.notFound(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('오늘의 말씀 조회 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DailyVerse>>> getVerseHistory(
    String coupleId,
    int limit,
  ) async {
    try {
      final verseModels = await _firebaseDataSource.getVerseHistory(
        coupleId,
        limit,
      );
      final verses = verseModels.map((model) => model.toEntity()).toList();
      return Right(verses);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('말씀 히스토리 조회 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitResponse({
    required String verseId,
    required String userId,
    required String coupleId,
    required String content,
  }) async {
    try {
      await _firebaseDataSource.submitResponse(
        verseId: verseId,
        userId: userId,
        coupleId: coupleId,
        content: content,
      );
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('답변 제출 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<Response>>> watchResponses(
    String verseId,
    String coupleId,
  ) {
    try {
      return _firebaseDataSource
          .watchResponses(verseId, coupleId)
          .map<Either<Failure, List<Response>>>((responseModels) {
            final responses = responseModels
                .map((model) => model.toEntity())
                .toList();
            return Right(responses);
          })
          .handleError((error) {
            if (error is DatabaseException) {
              return Left(DatabaseFailure(error.message));
            } else if (error is NetworkException) {
              return Left(NetworkFailure(error.message));
            } else {
              return Left(
                UnknownFailure('답변 실시간 감시 중 알 수 없는 오류가 발생했습니다: $error'),
              );
            }
          });
    } catch (e) {
      return Stream.value(
        Left(UnknownFailure('답변 실시간 감시 중 알 수 없는 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Future<Either<Failure, Response?>> getMyResponse({
    required String verseId,
    required String userId,
  }) async {
    try {
      final responseModel = await _firebaseDataSource.getMyResponse(
        verseId: verseId,
        userId: userId,
      );

      if (responseModel == null) {
        return const Right(null);
      }

      return Right(responseModel.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('내 답변 조회 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }
}
