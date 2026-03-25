import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_client.dart';
import '../../core/error/exceptions.dart' as app_exceptions;
import '../models/user_model.dart';

/// Supabase 인증 DataSource
///
/// Supabase Auth API를 호출하는 실제 구현
/// Repository가 이 DataSource를 사용하여 인증 작업 수행
class SupabaseAuthDataSource {
  final SupabaseClient _client;
  GoogleSignIn? _googleSignIn;

  SupabaseAuthDataSource({SupabaseClient? client, GoogleSignIn? googleSignIn})
    : _client = client ?? supabase,
      _googleSignIn = googleSignIn;

  /// GoogleSignIn 인스턴스를 lazy하게 초기화
  ///
  /// 웹 환경에서는 clientId가 필요하므로 플랫폼별로 다르게 설정
  GoogleSignIn get googleSignIn {
    if (_googleSignIn != null) {
      return _googleSignIn!;
    }

    // 플랫폼별 Client ID 가져오기
    String? clientId;
    if (kIsWeb) {
      clientId = dotenv.env['GOOGLE_CLIENT_ID_WEB'];
    } else if (Platform.isAndroid) {
      clientId = dotenv.env['GOOGLE_CLIENT_ID_ANDROID'];
    } else if (Platform.isIOS) {
      clientId = dotenv.env['GOOGLE_CLIENT_ID_IOS'];
    }

    // GoogleSignIn 초기화
    _googleSignIn = GoogleSignIn(
      clientId: clientId,
      scopes: ['email', 'profile'],
    );

    return _googleSignIn!;
  }

  /// 현재 로그인한 사용자 가져오기
  ///
  /// Throws:
  /// - [app_exceptions.AuthException]: 로그인 상태가 아닐 때
  Future<UserModel> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        throw const app_exceptions.AuthException(
          'No user is currently signed in',
          code: 'user-not-found',
        );
      }

      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      if (e is app_exceptions.AuthException) rethrow;
      throw app_exceptions.AuthException(
        'Failed to get current user',
        originalError: e,
      );
    }
  }

  /// 이메일/비밀번호로 로그인
  ///
  /// [email]: 사용자 이메일
  /// [password]: 비밀번호
  ///
  /// Throws:
  /// - [app_exceptions.AuthException]: 로그인 실패
  /// - [app_exceptions.NetworkException]: 네트워크 연결 실패
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const app_exceptions.AuthException(
          'Sign in failed - no user returned',
          code: 'sign-in-failed',
        );
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on app_exceptions.AuthException catch (e) {
      // Supabase app_exceptions.AuthException을 앱의 app_exceptions.AuthException으로 변환
      throw app_exceptions.AuthException(
        e.message,
        code: _mapSupabaseErrorCode(e.message),
        originalError: e,
      );
    } on SocketException {
      throw const app_exceptions.NetworkException();
    } catch (e) {
      throw app_exceptions.AuthException('Sign in failed', originalError: e);
    }
  }

  /// Google OAuth로 로그인
  ///
  /// Throws:
  /// - [app_exceptions.AuthException]: 로그인 실패 또는 취소
  /// - [app_exceptions.NetworkException]: 네트워크 연결 실패
  Future<UserModel> signInWithGoogle() async {
    try {
      // 1. Google Sign In 플로우 시작
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const app_exceptions.AuthException(
          'Google sign in was cancelled',
          code: 'sign-in-cancelled',
        );
      }

      // 2. Google 인증 정보 가져오기
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw const app_exceptions.AuthException(
          'Failed to get Google credentials',
          code: 'credentials-failed',
        );
      }

      // 3. Supabase에 Google 토큰으로 로그인
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw const app_exceptions.AuthException(
          'Google sign in failed - no user returned',
          code: 'sign-in-failed',
        );
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on app_exceptions.AuthException {
      rethrow;
    } on SocketException {
      throw const app_exceptions.NetworkException();
    } catch (e) {
      throw app_exceptions.AuthException(
        'Google sign in failed',
        originalError: e,
      );
    }
  }

  /// 이메일/비밀번호로 회원가입
  ///
  /// [email]: 사용자 이메일
  /// [password]: 비밀번호
  ///
  /// Throws:
  /// - [app_exceptions.AuthException]: 회원가입 실패
  /// - [app_exceptions.NetworkException]: 네트워크 연결 실패
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const app_exceptions.AuthException(
          'Sign up failed - no user returned',
          code: 'sign-up-failed',
        );
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on app_exceptions.AuthException catch (e) {
      throw app_exceptions.AuthException(
        e.message,
        code: _mapSupabaseErrorCode(e.message),
        originalError: e,
      );
    } on SocketException {
      throw const app_exceptions.NetworkException();
    } catch (e) {
      throw app_exceptions.AuthException('Sign up failed', originalError: e);
    }
  }

  /// 로그아웃
  ///
  /// Throws:
  /// - [app_exceptions.AuthException]: 로그아웃 실패
  Future<void> signOut() async {
    try {
      // Google Sign In도 함께 로그아웃
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      await _client.auth.signOut();
    } catch (e) {
      throw app_exceptions.AuthException('Sign out failed', originalError: e);
    }
  }

  /// 인증 상태 변경 스트림
  ///
  /// Returns:
  /// - Stream<UserModel?>: 로그인 상태면 UserModel, 아니면 null
  Stream<UserModel?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user != null ? UserModel.fromSupabaseUser(user) : null;
    });
  }

  /// 사용자 메타데이터 업데이트
  ///
  /// [metadata]: 업데이트할 메타데이터 (name, relationship_stage 등)
  ///
  /// Throws:
  /// - [app_exceptions.AuthException]: 업데이트 실패
  Future<UserModel> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(data: metadata),
      );

      if (response.user == null) {
        throw const app_exceptions.AuthException(
          'Update user metadata failed - no user returned',
          code: 'update-failed',
        );
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on app_exceptions.AuthException {
      rethrow;
    } on SocketException {
      throw const app_exceptions.NetworkException();
    } catch (e) {
      throw app_exceptions.AuthException(
        'Update user metadata failed',
        originalError: e,
      );
    }
  }

  /// Supabase 에러 메시지를 앱의 에러 코드로 매핑
  String _mapSupabaseErrorCode(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('invalid') && lowerMessage.contains('email')) {
      return 'invalid-email';
    } else if (lowerMessage.contains('user') && lowerMessage.contains('not')) {
      return 'user-not-found';
    } else if (lowerMessage.contains('password')) {
      return 'wrong-password';
    } else if (lowerMessage.contains('already') &&
        lowerMessage.contains('use')) {
      return 'email-already-in-use';
    } else if (lowerMessage.contains('weak')) {
      return 'weak-password';
    } else if (lowerMessage.contains('disabled')) {
      return 'user-disabled';
    } else {
      return 'unknown';
    }
  }
}
