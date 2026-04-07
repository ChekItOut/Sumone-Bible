import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_config.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
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
/// Feature Flag에 따라 Supabase 또는 Firebase DataSource 사용
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (AppConfig.useFirebase) {
    // Firebase 사용
    // Web 플랫폼일 경우 Google Client ID 전달
    final webClientId = kIsWeb ? dotenv.env['GOOGLE_CLIENT_ID_WEB'] : null;
    final firebaseDataSource = FirebaseAuthDataSource(
      webClientId: webClientId,
    );
    return AuthRepositoryImpl(firebaseDataSource: firebaseDataSource);
  } else {
    // Supabase 사용 (현재)
    final supabaseDataSource = SupabaseAuthDataSource();
    return AuthRepositoryImpl(supabaseDataSource: supabaseDataSource);
  }
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

  AuthNotifier(this._repository) : super(AuthState.unauthenticated()) {
    // UseCases 초기화
    _getCurrentUserUseCase = GetCurrentUserUseCase(_repository);
    _signInUseCase = SignInUseCase(_repository);
    _signInWithGoogleUseCase = SignInWithGoogleUseCase(_repository);
    _signUpUseCase = SignUpUseCase(_repository);
    _signOutUseCase = SignOutUseCase(_repository);

    // 인증 상태 변경 리스닝
    // NOTE: authStateChanges 스트림이 자동으로 현재 상태를 전달하므로
    // checkAuthStatus() 호출 불필요
    _listenToAuthStateChanges();
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
