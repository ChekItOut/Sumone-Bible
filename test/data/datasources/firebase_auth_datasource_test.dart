import 'package:flutter_test/flutter_test.dart';

import 'package:bible_sumone/core/error/exceptions.dart';
import 'package:bible_sumone/data/datasources/firebase_auth_datasource.dart';

/// Firebase Auth DataSource 통합 테스트
///
/// NOTE: 이 테스트는 실제 Firebase 프로젝트에 연결해야 실행 가능합니다.
/// 실행 방법:
/// 1. Firebase 프로젝트 초기화 필요 (main.dart의 Firebase.initializeApp())
/// 2. flutter test --dart-define=FLUTTER_TEST_ENV=integration
///
/// 또는 앱을 직접 실행하여 수동으로 테스트하세요.
void main() {
  late FirebaseAuthDataSource dataSource;

  // Firebase 초기화 (테스트 환경)
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // NOTE: 실제 Firebase 초기화는 main.dart에서 수행
    // 테스트 환경에서는 Firebase emulator 사용 권장
    // 여기서는 초기화 스킵 (실제 테스트 시 수동으로 설정)
  });

  setUp(() {
    dataSource = FirebaseAuthDataSource();
  });

  group('FirebaseAuthDataSource -', () {
    group('getCurrentUser -', () {
      test('로그인 상태가 아니면 AuthException을 던져야 함', () async {
        // Arrange
        // (로그아웃 상태)

        // Act & Assert
        expect(
          () => dataSource.getCurrentUser(),
          throwsA(isA<AuthException>()),
        );
      });

      // NOTE: 실제 로그인 테스트는 통합 테스트 또는 수동 테스트 필요
      test('로그인 상태면 UserModel을 반환해야 함', () async {
        // 이 테스트는 실제 로그인 후에만 통과
        // Skip for now
      }, skip: true);
    });

    group('signInWithEmail -', () {
      test('유효하지 않은 이메일이면 AuthException을 던져야 함', () async {
        // Arrange
        const invalidEmail = 'invalid-email';
        const password = 'password123';

        // Act & Assert
        expect(
          () => dataSource.signInWithEmail(
            email: invalidEmail,
            password: password,
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test('존재하지 않는 사용자면 AuthException을 던져야 함', () async {
        // Arrange
        const email = 'nonexistent@example.com';
        const password = 'password123';

        // Act & Assert
        expect(
          () => dataSource.signInWithEmail(email: email, password: password),
          throwsA(isA<AuthException>()),
        );
      });

      // NOTE: 실제 로그인 성공 테스트는 통합 테스트 필요
      test('올바른 이메일/비밀번호면 UserModel을 반환해야 함', () async {
        // 이 테스트는 실제 사용자가 등록되어 있어야 통과
        // Skip for now
      }, skip: true);
    });

    group('signUpWithEmail -', () {
      test('유효하지 않은 이메일이면 AuthException을 던져야 함', () async {
        // Arrange
        const invalidEmail = 'invalid-email';
        const password = 'password123';

        // Act & Assert
        expect(
          () => dataSource.signUpWithEmail(
            email: invalidEmail,
            password: password,
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test('약한 비밀번호면 AuthException을 던져야 함', () async {
        // Arrange
        const email = 'test@example.com';
        const weakPassword = '123'; // Firebase는 최소 6자 요구

        // Act & Assert
        expect(
          () =>
              dataSource.signUpWithEmail(email: email, password: weakPassword),
          throwsA(isA<AuthException>()),
        );
      });

      // NOTE: 실제 회원가입 성공 테스트는 통합 테스트 필요
      // (이메일 중복 방지를 위해 매번 다른 이메일 필요)
      test('올바른 이메일/비밀번호면 UserModel을 반환해야 함', () async {
        // 이 테스트는 통합 테스트에서 수행
        // Skip for now
      }, skip: true);
    });

    group('signInWithGoogle -', () {
      // NOTE: Google Sign-In 테스트는 실제 브라우저/앱 환경 필요
      test('Google 로그인 플로우 시작', () async {
        // 단위 테스트로는 불가능
        // 통합 테스트 또는 수동 테스트 필요
      }, skip: true);
    });

    group('signOut -', () {
      test('로그아웃이 성공해야 함', () async {
        // Arrange & Act & Assert
        // 로그아웃은 항상 성공 (로그인 상태가 아니어도 에러 없음)
        expect(() => dataSource.signOut(), returnsNormally);
      });
    });

    group('authStateChanges -', () {
      test('인증 상태 변경 스트림을 반환해야 함', () {
        // Arrange & Act
        final stream = dataSource.authStateChanges();

        // Assert
        expect(stream, isA<Stream>());
      });

      // NOTE: 실제 상태 변경 테스트는 통합 테스트 필요
      test('로그인/로그아웃 시 상태가 변경되어야 함', () async {
        // 이 테스트는 통합 테스트에서 수행
        // Skip for now
      }, skip: true);
    });

    group('에러 메시지 매핑 -', () {
      test('Firebase 에러가 한국어 메시지로 변환되어야 함', () async {
        // Arrange
        const invalidEmail = 'invalid-email';
        const password = 'password123';

        // Act & Assert
        try {
          await dataSource.signInWithEmail(
            email: invalidEmail,
            password: password,
          );
          fail('AuthException이 던져져야 함');
        } on AuthException catch (e) {
          // Firebase의 'invalid-email' 에러가 한국어로 변환되는지 확인
          expect(e.message, contains('유효하지 않은 이메일'));
        }
      });
    });
  });
}
