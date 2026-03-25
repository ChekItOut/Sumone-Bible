import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// 인증 상태 클래스
///
/// Freezed를 사용한 불변 상태 클래스
/// copyWith를 통해 안전하게 상태 업데이트
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    /// 로딩 중인지 여부
    required bool isLoading,

    /// 현재 로그인한 사용자 (null이면 로그인 안 된 상태)
    User? user,

    /// 에러 메시지 (null이면 에러 없음)
    String? error,
  }) = _AuthState;

  /// 초기 상태
  factory AuthState.initial() =>
      const AuthState(isLoading: false, user: null, error: null);

  /// 로딩 상태
  factory AuthState.loading() =>
      const AuthState(isLoading: true, user: null, error: null);

  /// 인증 성공 상태
  factory AuthState.authenticated(User user) =>
      AuthState(isLoading: false, user: user, error: null);

  /// 인증 실패 상태
  factory AuthState.unauthenticated() =>
      const AuthState(isLoading: false, user: null, error: null);

  /// 에러 상태
  factory AuthState.error(String message) =>
      AuthState(isLoading: false, user: null, error: message);
}

/// AuthState 확장
extension AuthStateX on AuthState {
  /// 로그인 상태인지 확인
  bool get isAuthenticated => user != null;

  /// 에러가 있는지 확인
  bool get hasError => error != null;
}
