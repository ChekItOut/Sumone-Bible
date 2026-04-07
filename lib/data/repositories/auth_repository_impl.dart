import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../core/constants/app_config.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/supabase_auth_datasource.dart';

/// AuthRepository 구현체 (Data Layer)
///
/// Repository 인터페이스를 실제로 구현
/// DataSource를 호출하고, Exception을 Failure로 변환
///
/// Feature Flag 패턴을 사용하여 Supabase/Firebase 병행 운영
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource? _supabaseDataSource;
  final FirebaseAuthDataSource? _firebaseDataSource;

  AuthRepositoryImpl({
    SupabaseAuthDataSource? supabaseDataSource,
    FirebaseAuthDataSource? firebaseDataSource,
  }) : _supabaseDataSource = supabaseDataSource,
       _firebaseDataSource = firebaseDataSource {
    // Feature Flag에 따라 DataSource가 제공되었는지 확인
    if (AppConfig.useFirebase) {
      assert(
        _firebaseDataSource != null,
        'FirebaseAuthDataSource must be provided when useFirebase is true',
      );
    } else {
      assert(
        _supabaseDataSource != null,
        'SupabaseAuthDataSource must be provided when useFirebase is false',
      );
    }
  }

  /// 현재 활성화된 DataSource 가져오기
  ///
  /// AppConfig.useFirebase에 따라 Firebase 또는 Supabase DataSource 반환
  dynamic get _dataSource {
    return AppConfig.useFirebase ? _firebaseDataSource! : _supabaseDataSource!;
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = await _dataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure.fromCode(e.code ?? 'unknown'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _dataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure.fromCode(e.code ?? 'unknown'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final userModel = await _dataSource.signInWithGoogle();
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure.fromCode(e.code ?? 'unknown'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _dataSource.signUpWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure.fromCode(e.code ?? 'unknown'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _dataSource.authStateChanges().map((userModel) {
      return userModel?.toEntity();
    });
  }
}
