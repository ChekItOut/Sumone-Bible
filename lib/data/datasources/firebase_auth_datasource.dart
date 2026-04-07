import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Firebase 인증 DataSource
///
/// Firebase Authentication API를 호출하는 실제 구현
/// Repository가 이 DataSource를 사용하여 인증 작업 수행
class FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn =
           googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile']);

  /// 현재 로그인한 사용자 가져오기
  ///
  /// Throws:
  /// - [AuthException]: 로그인 상태가 아닐 때
  Future<UserModel> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const AuthException(
          'No user is currently signed in',
          code: 'user-not-found',
        );
      }

      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to get current user', originalError: e);
    }
  }

  /// 이메일/비밀번호로 로그인
  ///
  /// [email]: 사용자 이메일
  /// [password]: 비밀번호
  ///
  /// Throws:
  /// - [AuthException]: 로그인 실패
  /// - [NetworkException]: 네트워크 연결 실패
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(
          'Sign in failed - no user returned',
          code: 'sign-in-failed',
        );
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        _mapFirebaseErrorMessage(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw AuthException('Sign in failed', originalError: e);
    }
  }

  /// Google OAuth로 로그인
  ///
  /// google_sign_in 패키지를 사용하여 Google Sign-In 실행 후
  /// Firebase에 인증 정보 전달
  ///
  /// Throws:
  /// - [AuthException]: 로그인 실패 또는 취소
  /// - [NetworkException]: 네트워크 연결 실패
  Future<UserModel> signInWithGoogle() async {
    try {
      // 1. Google Sign In 플로우 시작
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException(
          'Google sign in was cancelled',
          code: 'sign-in-cancelled',
        );
      }

      // 2. Google 인증 정보 가져오기
      final googleAuth = await googleUser.authentication;

      // 3. Firebase 인증 정보 생성
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Firebase에 로그인
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw const AuthException(
          'Google sign in failed - no user returned',
          code: 'sign-in-failed',
        );
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        _mapFirebaseErrorMessage(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      if (e is NetworkException) rethrow;
      throw AuthException('Google sign in failed', originalError: e);
    }
  }

  /// 이메일/비밀번호로 회원가입
  ///
  /// [email]: 사용자 이메일
  /// [password]: 비밀번호
  ///
  /// Throws:
  /// - [AuthException]: 회원가입 실패
  /// - [NetworkException]: 네트워크 연결 실패
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(
          'Sign up failed - no user returned',
          code: 'sign-up-failed',
        );
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        _mapFirebaseErrorMessage(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw AuthException('Sign up failed', originalError: e);
    }
  }

  /// 로그아웃
  ///
  /// Throws:
  /// - [AuthException]: 로그아웃 실패
  Future<void> signOut() async {
    try {
      // Google Sign In도 함께 로그아웃
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed', originalError: e);
    }
  }

  /// 인증 상태 변경 스트림
  ///
  /// Returns:
  /// - Stream<UserModel?>: 로그인 상태면 UserModel, 아니면 null
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  /// 사용자 프로필 업데이트 (displayName)
  ///
  /// [displayName]: 표시 이름
  ///
  /// Throws:
  /// - [AuthException]: 업데이트 실패
  Future<UserModel> updateDisplayName(String displayName) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const AuthException(
          'No user is currently signed in',
          code: 'user-not-found',
        );
      }

      await user.updateDisplayName(displayName);
      await user.reload();

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw const AuthException(
          'Failed to reload user',
          code: 'reload-failed',
        );
      }

      return UserModel.fromFirebaseUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        _mapFirebaseErrorMessage(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Update display name failed', originalError: e);
    }
  }

  /// Firebase 에러 코드를 사용자 친화적 메시지로 변환
  String _mapFirebaseErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return '유효하지 않은 이메일 주소입니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다.';
      case 'user-not-found':
        return '존재하지 않는 사용자입니다.';
      case 'wrong-password':
        return '잘못된 비밀번호입니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'operation-not-allowed':
        return '허용되지 않은 작업입니다.';
      case 'weak-password':
        return '비밀번호가 너무 약합니다. 6자 이상 입력해주세요.';
      case 'network-request-failed':
        return '네트워크 연결을 확인해주세요.';
      case 'too-many-requests':
        return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
      default:
        return '인증 오류가 발생했습니다: $code';
    }
  }
}
