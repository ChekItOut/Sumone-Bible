import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/supabase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/sign_in_usecase.dart';
import '../../domain/usecases/auth/sign_in_with_google_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/sign_up_usecase.dart';
import 'auth_state.dart';

/// AuthRepository Provider
///
/// Repository 싱글톤 제공
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = SupabaseAuthDataSource();
  return AuthRepositoryImpl(dataSource: dataSource);
});

/// AuthProvider (StateNotifier)
///
/// 인증 상태를 관리하고, 로그인/회원가입/로그아웃 등의 작업 수행
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  // UseCases
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final SignInUseCase _signInUseCase;
  late final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  late final SignUpUseCase _signUpUseCase;
  late final SignOutUseCase _signOutUseCase;

  // 인증 상태 변경 구독
  StreamSubscription? _authStateSubscription;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    // UseCases 초기화
    _getCurrentUserUseCase = GetCurrentUserUseCase(_repository);
    _signInUseCase = SignInUseCase(_repository);
    _signInWithGoogleUseCase = SignInWithGoogleUseCase(_repository);
    _signUpUseCase = SignUpUseCase(_repository);
    _signOutUseCase = SignOutUseCase(_repository);

    // 인증 상태 변경 리스닝
    _listenToAuthStateChanges();

    // 앱 시작 시 현재 인증 상태 확인
    checkAuthStatus();
  }

  /// 인증 상태 변경 리스닝
  ///
  /// Supabase Auth 상태가 변경되면 자동으로 상태 업데이트
  void _listenToAuthStateChanges() {
    _authStateSubscription = _repository.authStateChanges().listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  /// 앱 시작 시 현재 인증 상태 확인
  Future<void> checkAuthStatus() async {
    state = AuthState.loading();

    final result = await _getCurrentUserUseCase.call();

    result.fold(
      (failure) => state = AuthState.unauthenticated(),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// 이메일/비밀번호 로그인
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _signInUseCase.call(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Google OAuth 로그인
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _signInWithGoogleUseCase.call();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// 이메일/비밀번호 회원가입
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _signUpUseCase.call(
      SignUpParams(email: email, password: password),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// 로그아웃
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _signOutUseCase.call();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = AuthState.unauthenticated(),
    );
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

/// AuthProvider
///
/// AuthNotifier를 제공하는 Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});
