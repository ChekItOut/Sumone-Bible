import 'package:dartz/dartz.dart';

import '../../core/constants/app_config.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/daily_verse.dart';
import '../../domain/entities/response.dart';
import '../../domain/repositories/verse_repository.dart';
import '../datasources/firebase_verse_datasource.dart';
import '../datasources/supabase_verse_datasource.dart';

/// 말씀 Repository 구현 (Data Layer)
///
/// VerseRepository 인터페이스 구현
/// DataSource를 사용하여 실제 데이터 작업 수행
/// Exception → Failure 변환 및 에러 핸들링
///
/// Feature Flag (AppConfig.useFirebase)에 따라 Firebase 또는 Supabase 사용
class VerseRepositoryImpl implements VerseRepository {
  final FirebaseVerseDataSource? _firebaseDataSource;
  final SupabaseVerseDataSource? _supabaseDataSource;
  final bool _useFirebase = AppConfig.useFirebase;

  VerseRepositoryImpl({
    FirebaseVerseDataSource? firebaseDataSource,
    SupabaseVerseDataSource? supabaseDataSource,
  }) : _firebaseDataSource = firebaseDataSource,
       _supabaseDataSource = supabaseDataSource {
    // 최소 하나의 DataSource는 필요
    assert(
      _firebaseDataSource != null || _supabaseDataSource != null,
      'At least one DataSource must be provided',
    );
  }

  @override
  Future<Either<Failure, DailyVerse>> getTodayVerse() async {
    try {
      final verseModel = _useFirebase
          ? await _firebaseDataSource!.getTodayVerse()
          : await _supabaseDataSource!.getTodayVerse();
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
      final verseModels = _useFirebase
          ? await _firebaseDataSource!.getVerseHistory(coupleId, limit)
          : await _supabaseDataSource!.getVerseHistory(coupleId, limit);
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
      if (_useFirebase) {
        await _firebaseDataSource!.submitResponse(
          verseId: verseId,
          userId: userId,
          coupleId: coupleId,
          content: content,
        );
      } else {
        await _supabaseDataSource!.submitResponse(
          verseId: verseId,
          userId: userId,
          coupleId: coupleId,
          content: content,
        );
      }
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
      final stream = _useFirebase
          ? _firebaseDataSource!.watchResponses(verseId, coupleId)
          : _supabaseDataSource!.watchResponses(verseId, coupleId);

      return stream
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
      final responseModel = _useFirebase
          ? await _firebaseDataSource!.getMyResponse(
              verseId: verseId,
              userId: userId,
            )
          : await _supabaseDataSource!.getMyResponse(
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
