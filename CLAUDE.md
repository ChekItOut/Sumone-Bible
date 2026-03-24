# Bible SumOne - 개발 가이드라인

> **30년차 시니어 개발자처럼 생각하고 코딩하기**
>
> 이 문서는 Bible SumOne 프로젝트의 개발 철학과 규칙을 정의합니다.
> 모든 코드 작성, 수정, 리팩토링 시 **반드시** 준수해야 합니다.

**최종 업데이트**: 2026-03-24
**버전**: 1.0

---

## 📋 목차

1. [프로젝트 이해](#1-프로젝트-이해)
2. [아키텍처 원칙](#2-아키텍처-원칙)
3. [코드 작성 전 필수 체크리스트](#3-코드-작성-전-필수-체크리스트)
4. [파일 구조 및 네이밍 규칙](#4-파일-구조-및-네이밍-규칙)
5. [코딩 스타일 가이드](#5-코딩-스타일-가이드)
6. [상태 관리 규칙](#6-상태-관리-규칙)
7. [API 및 데이터 처리](#7-api-및-데이터-처리)
8. [에러 핸들링](#8-에러-핸들링)
9. [테스트 작성 규칙](#9-테스트-작성-규칙)
10. [변경 및 리팩토링 시 주의사항](#10-변경-및-리팩토링-시-주의사항)
11. [금지 사항](#11-금지-사항)
12. [문서 참조](#12-문서-참조)
13. [코드 리뷰 체크리스트](#13-코드-리뷰-체크리스트)
14. [30년차 시니어 개발자의 마인드셋](#14-30년차-시니어-개발자의-마인드셋)
15. [긴급 상황 대처](#15-긴급-상황-대처)
16. [마무리](#16-마무리)
17. [에이전트 시스템](#17-에이전트-시스템) ⭐ NEW
18. [문서 버전 관리](#18-문서-버전-관리)

---

## 1. 프로젝트 이해

### 1.1 제품 본질 이해

Bible SumOne은 단순한 앱이 아닙니다. **크리스천 커플의 영적 성장과 관계 깊이를 돕는 플랫폼**입니다.

**핵심 가치**:
- ✝️ **신학적 적절성**: 모든 기능은 성경적 가치에 부합해야 함
- 💑 **커플 중심**: 혼자가 아닌 "함께"하는 경험
- 🎯 **지속 가능한 습관**: 3-5분으로 꾸준히 할 수 있어야 함
- ✨ **재미 + 깊이**: SumOne의 UX + 성경의 의미

**이 의미는**:
- 코드가 단순히 "작동"하는 것을 넘어 **사용자의 삶에 긍정적 영향**을 주어야 함
- 버그나 장애는 단순한 기술적 문제가 아니라 **커플의 신앙 여정을 방해**하는 것
- 성능 최적화는 사치가 아니라 **매일 사용하는 습관**을 위한 필수

### 1.2 필수 문서 이해

코드 작성 전 반드시 읽어야 할 문서:
1. **docs/prd.md** - 모든 기능 명세와 요구사항
2. **docs/roadmap.md** - 프로젝트 구조와 기술 스택
3. **docs/features.md** - 기능 우선순위와 AI 통합 전략
4. **docs/personas.md** - 사용자 이해 (민지&준호, 수정&태훈, 지은&현우)

**규칙**:
- ❌ 문서를 읽지 않고 "추측"으로 코딩하지 마세요
- ✅ 불명확한 부분은 문서를 먼저 확인하세요
- ✅ 문서와 코드가 충돌하면 문서가 정답입니다 (단, 문서 업데이트 필요)

---

## 2. 아키텍처 원칙

### 2.1 Clean Architecture 엄격 준수

```
외부 (Frameworks & Drivers)
  ↓ 의존
중간 (Interface Adapters)
  ↓ 의존
내부 (Business Logic / Domain)
```

**의존성 규칙 (Dependency Rule)**:
- ✅ **외부 → 내부만 허용** (Presentation → Data → Domain)
- ❌ **내부 → 외부 절대 금지** (Domain은 Data를 모름)

**실제 예시**:
```dart
// ❌ 잘못된 예: Domain이 Data를 알고 있음
// lib/domain/entities/user.dart
import 'package:bible_sumone/data/models/user_model.dart'; // 금지!

class User {
  final UserModel model; // 금지!
}

// ✅ 올바른 예: Domain은 순수 비즈니스 로직만
// lib/domain/entities/user.dart
class User {
  final String userId;
  final String name;
  final RelationshipStage stage;

  User({required this.userId, required this.name, required this.stage});
}
```

### 2.2 레이어별 책임

#### Domain (도메인 레이어)
- **책임**: 비즈니스 로직만 포함
- **포함**: Entities, Use Cases
- **금지**: Flutter, Supabase, Dio 등 외부 라이브러리 import 금지
- **예시**: `User`, `DailyVerse`, `SignInUseCase`

#### Data (데이터 레이어)
- **책임**: 데이터 소스 관리 및 변환
- **포함**: Models, Repositories, Data Sources
- **역할**: API 호출, DB 접근, JSON ↔ Dart 변환
- **예시**: `UserModel`, `SupabaseDataSource`, `BibleApiDataSource`

#### Presentation (프레젠테이션 레이어)
- **책임**: UI 및 상태 관리
- **포함**: Screens, Widgets, Providers
- **역할**: 사용자 입력 처리, 화면 표시
- **예시**: `HomeScreen`, `AuthProvider`, `DailyVerseCard`

### 2.3 Feature-First 구조

```
lib/presentation/screens/
├── auth/           # 인증 관련 모든 것
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── widgets/
│       └── auth_button.dart
│
├── verse/          # 말씀 관련 모든 것
│   ├── daily_verse_screen.dart
│   └── widgets/
│       └── verse_card.dart
```

**규칙**:
- ✅ 기능별로 폴더 분리 (auth, verse, response, couple 등)
- ✅ 각 기능은 자체 widgets/ 폴더 포함
- ✅ 재사용 가능한 위젯만 공통 `lib/presentation/widgets/`로 이동

---

## 3. 코드 작성 전 필수 체크리스트

### 3.1 새로운 기능 추가 시

**STOP! 코드 작성 전에 다음을 확인하세요**:

- [ ] **1. PRD 확인**: 이 기능이 `docs/prd.md`에 정의되어 있는가?
- [ ] **2. 기존 코드 검색**: 비슷한 기능이 이미 구현되어 있지 않은가?
  ```bash
  # 예시: "답변 작성" 기능 추가 전
  grep -r "response" lib/
  ```
- [ ] **3. 의존성 확인**: 이 기능이 의존하는 다른 기능이 먼저 구현되었는가?
  ```
  예: Dual Reveal은 "답변 작성"이 먼저 구현되어야 함
  ```
- [ ] **4. 데이터 모델 확인**: 필요한 테이블/필드가 Supabase에 존재하는가?
- [ ] **5. 라우팅 계획**: 이 화면으로 어떻게 이동하고 돌아오는가?

### 3.2 기존 코드 수정 시

**DANGER! 수정 전에 다음을 확인하세요**:

- [ ] **1. 영향 범위 파악**: 이 파일을 import하는 다른 파일이 있는가?
  ```bash
  # 예시: user_model.dart 수정 시
  grep -r "import.*user_model" lib/
  ```
- [ ] **2. 테스트 확인**: 관련 테스트가 있는가? 수정 후 통과하는가?
- [ ] **3. Breaking Change**: 이 수정이 기존 API 시그니처를 변경하는가?
  ```dart
  // ❌ Breaking Change (금지)
  // Before
  Future<User> getUser(String userId);
  // After
  Future<User> getUser(String userId, bool includeProfile); // 기존 호출 코드 깨짐

  // ✅ Non-Breaking (권장)
  Future<User> getUser(String userId, {bool includeProfile = false}); // 기본값 제공
  ```
- [ ] **4. 마이그레이션 계획**: DB 스키마 변경이 필요한가? 기존 데이터는?

### 3.3 버그 수정 시

**THINK! 근본 원인을 찾으세요**:

- [ ] **1. 재현 가능성**: 버그를 100% 재현할 수 있는가?
- [ ] **2. 근본 원인**: 증상이 아닌 원인을 수정하는가?
  ```dart
  // ❌ 증상만 수정 (임시방편)
  if (data == null) return; // null이 왜 발생하는지 모름

  // ✅ 원인 수정
  // API 호출 실패 시 null 반환 → 에러 핸들링 추가
  ```
- [ ] **3. 다른 곳에도 있는가**: 같은 패턴의 버그가 다른 파일에도 있는가?
- [ ] **4. 테스트 추가**: 이 버그가 재발하지 않도록 테스트를 추가했는가?

---

## 4. 파일 구조 및 네이밍 규칙

### 4.1 파일 위치 규칙

**절대 규칙**:
- ✅ 모든 파일은 **정확히 한 곳**에만 위치
- ❌ 같은 로직을 여러 파일에 중복 작성 금지

**위치 결정 플로우차트**:
```
이 코드는 무엇인가?
│
├─ UI 관련?
│  └─ lib/presentation/screens/{feature}/
│
├─ 비즈니스 로직?
│  ├─ 순수 로직? → lib/domain/usecases/
│  └─ 데이터 접근? → lib/data/repositories/
│
├─ 데이터 변환?
│  └─ lib/data/models/
│
├─ API 호출?
│  └─ lib/data/datasources/
│
└─ 유틸리티?
   └─ lib/core/utils/
```

### 4.2 네이밍 컨벤션

#### 파일명 (snake_case)
```dart
// ✅ 올바른 예
daily_verse_screen.dart
user_model.dart
sign_in_usecase.dart

// ❌ 잘못된 예
DailyVerseScreen.dart  // PascalCase 금지
dailyVerseScreen.dart  // camelCase 금지
daily-verse-screen.dart  // kebab-case 금지
```

#### 클래스명 (PascalCase)
```dart
// ✅ 올바른 예
class DailyVerseScreen extends StatelessWidget {}
class UserModel {}
class SignInUseCase {}

// ❌ 잘못된 예
class daily_verse_screen {}  // snake_case 금지
class dailyVerseScreen {}    // camelCase 금지
```

#### 변수/함수명 (camelCase)
```dart
// ✅ 올바른 예
final String userId = '123';
void fetchDailyVerse() {}

// ❌ 잘못된 예
final String user_id = '123';  // snake_case 금지
void FetchDailyVerse() {}      // PascalCase 금지
```

#### 상수 (lowerCamelCase, 일부 UPPER_SNAKE_CASE)
```dart
// ✅ 전역 상수 (UPPER_SNAKE_CASE)
const String API_BASE_URL = 'https://api.example.com';
const int MAX_RESPONSE_LENGTH = 500;

// ✅ 지역 상수 (lowerCamelCase)
const primaryColor = Color(0xFF6B4DE8);
```

### 4.3 폴더 구조 예시

```
lib/
├── main.dart
├── app/
│   ├── app.dart              # MaterialApp 설정
│   ├── routes.dart           # 라우팅
│   └── theme.dart            # 테마
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── utils/
│   │   ├── logger.dart
│   │   └── date_utils.dart
│   └── error/
│       └── failures.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   └── daily_verse_model.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── datasources/
│       ├── supabase_datasource.dart
│       └── bible_api_datasource.dart
│
├── domain/
│   ├── entities/
│   │   └── user.dart
│   └── usecases/
│       └── auth/
│           └── sign_in_usecase.dart
│
└── presentation/
    ├── providers/
    │   └── auth_provider.dart
    ├── screens/
    │   ├── auth/
    │   │   ├── login_screen.dart
    │   │   └── widgets/
    │   │       └── auth_button.dart
    │   └── home/
    │       └── home_screen.dart
    └── widgets/              # 공통 위젯만
        └── primary_button.dart
```

---

## 5. 코딩 스타일 가이드

### 5.1 Dart 스타일 가이드 준수

**공식 가이드 따르기**:
- ✅ [Effective Dart](https://dart.dev/guides/language/effective-dart) 준수
- ✅ `flutter analyze` 경고 0개 유지
- ✅ `dart format .` 실행 후 커밋

### 5.2 주석 작성 규칙

#### 언제 주석을 쓰는가?

**❌ 불필요한 주석 (자명한 코드)**:
```dart
// ❌ 나쁜 예: 코드가 이미 설명하고 있음
// 사용자 ID를 가져온다
final userId = user.id;

// 로그인 함수 호출
await signIn();
```

**✅ 필요한 주석 (의도 설명)**:
```dart
// ✅ 좋은 예: "왜" 이렇게 했는지 설명
// NOTE: Supabase RLS 정책으로 인해 본인 데이터만 조회 가능
final data = await supabase.from('responses').select();

// HACK: iOS에서 키보드가 화면을 가리는 버그 임시 해결
// TODO: Flutter 3.12 업데이트 후 제거 예정
await Future.delayed(Duration(milliseconds: 100));

// IMPORTANT: 스트릭 계산 시 UTC 시간 기준 (타임존 문제 방지)
final today = DateTime.now().toUtc();
```

#### 주석 태그
```dart
// TODO: 추후 구현 필요
// FIXME: 버그 있음, 수정 필요
// HACK: 임시 방편
// NOTE: 중요한 설명
// IMPORTANT: 매우 중요한 설명
// WARNING: 주의 필요
```

### 5.3 함수 작성 규칙

#### 단일 책임 원칙 (Single Responsibility)
```dart
// ❌ 나쁜 예: 하나의 함수가 너무 많은 일을 함
Future<void> handleLogin() async {
  final email = emailController.text;
  final password = passwordController.text;

  // 검증
  if (email.isEmpty) showError('이메일을 입력하세요');
  if (!email.contains('@')) showError('잘못된 형식');

  // 로그인
  final result = await supabase.auth.signIn(email: email, password: password);

  // 프로필 조회
  final profile = await supabase.from('users').select().eq('user_id', result.user!.id);

  // 상태 저장
  await prefs.setString('user_id', result.user!.id);

  // 화면 이동
  router.push('/home');
}

// ✅ 좋은 예: 각 책임을 분리
Future<void> handleLogin() async {
  final credentials = _validateCredentials();
  if (credentials == null) return;

  final user = await _signIn(credentials);
  await _loadUserProfile(user.id);
  await _saveSession(user.id);
  _navigateToHome();
}

LoginCredentials? _validateCredentials() { /* ... */ }
Future<User> _signIn(LoginCredentials credentials) { /* ... */ }
Future<void> _loadUserProfile(String userId) { /* ... */ }
Future<void> _saveSession(String userId) { /* ... */ }
void _navigateToHome() { /* ... */ }
```

#### 함수 크기
- ✅ **최대 50줄** 이내
- ✅ **하나의 추상화 레벨** 유지
- ✅ **중첩 depth 3단계** 이내

```dart
// ❌ 나쁜 예: 너무 깊은 중첩
if (user != null) {
  if (user.isVerified) {
    if (user.hasProfile) {
      if (user.couple != null) {
        // ...
      }
    }
  }
}

// ✅ 좋은 예: Early return으로 평탄화
if (user == null) return;
if (!user.isVerified) return;
if (!user.hasProfile) return;
if (user.couple == null) return;

// 실제 로직
```

### 5.4 변수 선언 규칙

```dart
// ✅ final 우선 사용 (불변성)
final String userId = '123';
final List<User> users = [];

// ✅ var는 타입이 명확할 때만
var count = 0;  // int 명확
var name = 'John';  // String 명확

// ❌ 타입이 불명확하면 명시
// var result = await fetchData();  // 무슨 타입인지 모름
final UserProfile result = await fetchData();  // 명확!

// ✅ const는 컴파일 타임 상수에만
const String apiBaseUrl = 'https://api.example.com';
const primaryColor = Color(0xFF6B4DE8);
```

### 5.5 Null Safety

**철저한 Null 체크**:
```dart
// ❌ 위험한 코드
final name = user!.name;  // user가 null이면 크래시!

// ✅ 안전한 코드
final name = user?.name ?? 'Unknown';

// ✅ assert로 사전 검증
assert(user != null, 'User must not be null');
final name = user!.name;  // assert 통과했으므로 안전

// ✅ 조기 리턴
if (user == null) {
  logger.error('User is null');
  return;
}
final name = user.name;  // 이후 코드에서 안전
```

---

## 6. 상태 관리 규칙

### 6.1 Riverpod 사용 규칙

**Provider 위치**:
```
lib/presentation/providers/
├── auth_provider.dart        # 인증 상태
├── couple_provider.dart      # 커플 상태
├── verse_provider.dart       # 말씀 상태
└── response_provider.dart    # 답변 상태
```

**Provider 작성 규칙**:
```dart
// ✅ 올바른 예: StateNotifier 사용
class AuthProvider extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthProvider(this._repository) : super(AuthState.initial());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _repository.signIn(email, password);
      state = state.copyWith(
        isLoading: false,
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthProvider(repository);
});
```

**State 클래스**:
```dart
// ✅ Freezed 사용 (불변성 + copyWith)
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required bool isLoading,
    User? user,
    String? error,
  }) = _AuthState;

  factory AuthState.initial() => AuthState(
    isLoading: false,
    user: null,
    error: null,
  );
}
```

### 6.2 상태 접근 규칙

```dart
// ✅ Consumer로 필요한 부분만 rebuild
Consumer(
  builder: (context, ref, child) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return CircularProgressIndicator();
    }

    return Text(authState.user?.name ?? 'Guest');
  },
)

// ❌ 전체 위젯을 ConsumerWidget으로 만들지 마세요 (불필요한 rebuild)
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);  // 전체 rebuild!

    return Column(
      children: [
        // ... 100줄의 위젯 ...
      ],
    );
  }
}
```

---

## 7. API 및 데이터 처리

### 7.1 Supabase 사용 규칙

**RLS (Row Level Security) 준수**:
```dart
// ✅ RLS가 자동으로 필터링하므로 where 불필요
final myResponses = await supabase
  .from('responses')
  .select()
  .eq('user_id', currentUserId);  // 명시적으로 써도 됨

// ❌ Service Role Key로 RLS 우회 금지 (보안 위험)
final allResponses = await supabase
  .from('responses')
  .select();  // 모든 사용자 데이터 조회 가능 (위험!)
```

**에러 핸들링**:
```dart
// ✅ Supabase 에러를 캐치하여 처리
try {
  final data = await supabase.from('users').select();
} on PostgrestException catch (e) {
  if (e.code == '23505') {
    // Unique constraint violation
    throw DuplicateUserException();
  } else {
    throw DatabaseException(e.message);
  }
} catch (e) {
  throw UnknownException(e.toString());
}
```

### 7.2 성경 API 사용 규칙

**캐싱 필수**:
```dart
// ✅ 항상 캐시 확인 후 API 호출
Future<String> getVerse(String reference) async {
  // 1. 캐시 확인
  final cached = await _getCachedVerse(reference);
  if (cached != null) return cached;

  // 2. API 호출
  final verse = await _fetchFromApi(reference);

  // 3. 캐시 저장
  await _cacheVerse(reference, verse);

  return verse;
}
```

**API 실패 대비**:
```dart
// ✅ Fallback 제공
Future<String> getVerse(String reference) async {
  try {
    return await _fetchFromApi(reference);
  } catch (e) {
    // 캐시에서라도 제공
    final cached = await _getCachedVerse(reference);
    if (cached != null) return cached;

    // 최후의 수단: 기본 메시지
    return '성경 구절을 불러올 수 없습니다. 인터넷 연결을 확인해주세요.';
  }
}
```

### 7.3 Gemini API 사용 규칙

**프롬프트 일관성**:
```dart
// ✅ 프롬프트를 상수로 관리
class GeminiPrompts {
  static String questionGeneration({
    required String verseText,
    required String relationshipStage,
  }) {
    return '''
당신은 크리스천 커플을 위한 성경 공부 가이드입니다.

성경 구절: $verseText
커플 상태: $relationshipStage

위 말씀을 읽은 커플이 서로 나눌 수 있는 대화 질문 1개를 생성하세요.

요구사항:
1. 커플의 관계에 적용 가능
2. 자연스러운 대화 유도
3. 50자 이내

출력: [질문만]
''';
  }
}
```

**비용 최적화**:
```dart
// ✅ 결과 캐싱 (같은 입력에 대해 재호출 방지)
final cachedQuestions = <String, String>{};

Future<String> generateQuestion(String verseId) async {
  if (cachedQuestions.containsKey(verseId)) {
    return cachedQuestions[verseId]!;
  }

  final question = await _callGeminiApi(verseId);
  cachedQuestions[verseId] = question;

  return question;
}
```

---

## 8. 에러 핸들링

### 8.1 에러 타입 정의

```dart
// lib/core/error/failures.dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class AuthFailure extends Failure {
  AuthFailure(super.message);
}
```

### 8.2 Either 패턴 사용

```dart
// ✅ 성공/실패를 명시적으로 표현
Future<Either<Failure, User>> signIn(String email, String password) async {
  try {
    final user = await _datasource.signIn(email, password);
    return Right(user);
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } on AuthException catch (e) {
    return Left(AuthFailure(e.message));
  } catch (e) {
    return Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
  }
}

// 사용
final result = await repository.signIn(email, password);
result.fold(
  (failure) => showError(failure.message),
  (user) => navigateToHome(user),
);
```

### 8.3 사용자 친화적 에러 메시지

```dart
// ❌ 기술적 메시지 (사용자 혼란)
'PostgrestException: 23505 duplicate key value violates unique constraint'

// ✅ 사용자 친화적 메시지
'이미 사용 중인 이메일입니다.'

// ✅ 에러 메시지 매핑
String getUserFriendlyMessage(Failure failure) {
  if (failure is NetworkFailure) {
    return '인터넷 연결을 확인해주세요.';
  } else if (failure is AuthFailure) {
    return '이메일 또는 비밀번호가 올바르지 않습니다.';
  } else if (failure is ServerFailure) {
    return '일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
  } else {
    return '알 수 없는 오류가 발생했습니다.';
  }
}
```

---

## 9. 테스트 작성 규칙

### 9.1 테스트 커버리지 목표

- ✅ **Domain Layer**: 100% (비즈니스 로직 핵심)
- ✅ **Data Layer**: 80% (Repository, DataSource)
- ✅ **Presentation Layer**: 60% (주요 화면 플로우)

### 9.2 테스트 작성 패턴 (AAA)

```dart
// Arrange - Act - Assert 패턴
test('should return user when sign in succeeds', () async {
  // Arrange (준비)
  final repository = MockAuthRepository();
  final usecase = SignInUseCase(repository);

  when(repository.signIn(any, any))
      .thenAnswer((_) async => Right(testUser));

  // Act (실행)
  final result = await usecase.call(
    email: 'test@example.com',
    password: 'password123',
  );

  // Assert (검증)
  expect(result, Right(testUser));
  verify(repository.signIn('test@example.com', 'password123'));
  verifyNoMoreInteractions(repository);
});
```

### 9.3 테스트 네이밍

```dart
// ✅ 명확한 테스트 이름
test('should return DailyVerse when API call succeeds', () {});
test('should return NetworkFailure when device is offline', () {});
test('should emit loading state then success state', () {});

// ❌ 불명확한 테스트 이름
test('test 1', () {});
test('works', () {});
```

---

## 10. 변경 및 리팩토링 시 주의사항

### 10.1 변경 전 체크리스트

**CRITICAL: 코드 수정 전 반드시 확인**

- [ ] **1. 영향 범위 파악**
  ```bash
  # 이 파일을 import하는 곳 찾기
  grep -r "import.*file_name" lib/

  # 이 함수를 호출하는 곳 찾기
  grep -r "functionName" lib/
  ```

- [ ] **2. 기존 테스트 실행**
  ```bash
  flutter test
  ```

- [ ] **3. 타입 체크**
  ```bash
  flutter analyze
  ```

- [ ] **4. Breaking Change 확인**
  - 함수 시그니처 변경?
  - 클래스 필드 제거/변경?
  - API 응답 구조 변경?

### 10.2 리팩토링 원칙

**점진적 리팩토링 (Incremental Refactoring)**:
```
❌ 한 번에 모든 것을 바꾸지 마세요
✅ 한 번에 하나씩, 테스트를 유지하며 진행
```

**예시**:
```dart
// Step 1: 새로운 함수 추가 (기존 유지)
Future<User> getUserNew(String userId) async { /* ... */ }

// Step 2: 기존 함수를 새로운 함수로 위임
@deprecated
Future<User> getUser(String userId) async {
  return getUserNew(userId);
}

// Step 3: 모든 호출 코드를 새 함수로 변경
// ...

// Step 4: 기존 함수 제거
// (충분한 시간 후)
```

### 10.3 DB 스키마 변경

**마이그레이션 필수**:
```sql
-- ❌ 절대 하지 마세요: 직접 ALTER TABLE
ALTER TABLE users DROP COLUMN old_field;  -- 데이터 유실!

-- ✅ 안전한 마이그레이션
-- Step 1: 새 컬럼 추가 (nullable)
ALTER TABLE users ADD COLUMN new_field TEXT;

-- Step 2: 데이터 이관
UPDATE users SET new_field = old_field;

-- Step 3: NOT NULL 제약 추가
ALTER TABLE users ALTER COLUMN new_field SET NOT NULL;

-- Step 4: 오래된 컬럼 제거 (충분한 시간 후)
-- ALTER TABLE users DROP COLUMN old_field;
```

---

## 11. 금지 사항

### 11.1 절대 금지 (NEVER)

**코드 작성**:
- ❌ **하드코딩된 값**: 모든 상수는 `core/constants/`에 정의
  ```dart
  // ❌ 금지
  final url = 'https://bible.helloao.org/api';

  // ✅ 허용
  final url = ApiConstants.bibleApiUrl;
  ```

- ❌ **print() 사용**: 반드시 Logger 사용
  ```dart
  // ❌ 금지
  print('User logged in');

  // ✅ 허용
  logger.info('User logged in: $userId');
  ```

- ❌ **Null Safety 무시**: `!` 연산자 최소화
  ```dart
  // ❌ 위험
  final name = user!.name;

  // ✅ 안전
  final name = user?.name ?? 'Unknown';
  ```

**아키텍처 위반**:
- ❌ **Domain → Data 의존**: Domain이 Data를 import하면 안 됨
- ❌ **UI에 비즈니스 로직**: Presentation에 복잡한 계산 금지
- ❌ **God Object**: 모든 것을 아는 거대한 클래스 금지

**보안**:
- ❌ **하드코딩된 API 키**: 반드시 .env 사용
- ❌ **민감 정보 로그**: 비밀번호, 토큰 로그 금지
- ❌ **RLS 우회**: Service Role Key를 클라이언트에서 사용 금지

### 11.2 권장하지 않음 (AVOID)

- ⚠️ **setState 과다 사용**: Riverpod Provider 사용
- ⚠️ **익명 함수 남발**: 재사용 가능한 함수로 분리
- ⚠️ **Magic Number**: 의미 있는 상수로 정의
  ```dart
  // ⚠️ 권장하지 않음
  if (response.length > 500) { /* ... */ }

  // ✅ 권장
  const maxResponseLength = 500;
  if (response.length > maxResponseLength) { /* ... */ }
  ```

---

## 12. 문서 참조

### 12.1 필수 문서

개발 전 반드시 읽어야 할 문서:

1. **docs/prd.md** - Product Requirements Document
   - 모든 기능 명세
   - 데이터 모델
   - API 엔드포인트
   - UI/UX 가이드라인

2. **docs/roadmap.md** - 개발 로드맵
   - 프로젝트 구조
   - 기술 스택
   - 구현 순서
   - 에이전트 활용 계획

3. **docs/features.md** - 기능 브레인스토밍
   - 우선순위
   - AI 통합 전략
   - 성경 API 계획

4. **docs/personas.md** - 사용자 페르소나
   - 타겟 사용자 이해
   - 사용 시나리오
   - 페인 포인트

### 12.2 문서 업데이트

**코드 변경 시 문서도 업데이트**:
- ✅ PRD의 기능 명세 변경 시 → `docs/prd.md` 업데이트
- ✅ DB 스키마 변경 시 → `docs/prd.md` 업데이트
- ✅ API 엔드포인트 변경 시 → `docs/prd.md` 업데이트
- ✅ 프로젝트 구조 변경 시 → `docs/roadmap.md` 업데이트

---

## 13. 코드 리뷰 체크리스트

### 13.1 자가 리뷰 (Self Review)

**코드 커밋 전 스스로 확인**:

- [ ] ✅ `flutter analyze` 통과 (경고 0개)
- [ ] ✅ `dart format .` 실행
- [ ] ✅ 모든 테스트 통과
- [ ] ✅ 주석 불필요한 코드 제거
- [ ] ✅ Console.log / print 제거
- [ ] ✅ TODO 주석 추가 (미완성 부분)
- [ ] ✅ 하드코딩된 값 상수화
- [ ] ✅ 민감 정보 제거 (.env 사용)

### 13.2 구조 리뷰

- [ ] ✅ 올바른 레이어에 위치? (Domain/Data/Presentation)
- [ ] ✅ 의존성 규칙 준수? (외부 → 내부)
- [ ] ✅ 단일 책임 원칙? (하나의 클래스/함수 = 하나의 책임)
- [ ] ✅ 중복 코드 없음?
- [ ] ✅ 네이밍 일관성?

### 13.3 품질 리뷰

- [ ] ✅ 에러 핸들링 적절?
- [ ] ✅ Null Safety 준수?
- [ ] ✅ 성능 최적화? (불필요한 rebuild 없음)
- [ ] ✅ 메모리 누수 없음? (dispose 호출)
- [ ] ✅ 사용자 친화적 메시지?

---

## 14. 30년차 시니어 개발자의 마인드셋

### 14.1 코드는 읽히기 위해 작성된다

```
"코드는 컴퓨터보다 사람을 위한 것이다"
```

- ✅ 6개월 후의 나도 이해할 수 있는가?
- ✅ 신입 개발자도 읽고 이해할 수 있는가?
- ✅ 주석 없이도 의도가 명확한가?

### 14.2 변경을 두려워하지 말고, 준비하라

```
"소프트웨어의 유일한 상수는 변화다"
```

- ✅ 확장 가능한 구조인가?
- ✅ 테스트로 안전망이 있는가?
- ✅ Breaking Change를 최소화했는가?

### 14.3 완벽보다 점진적 개선

```
"완벽한 코드를 기다리지 말고, 작동하는 코드를 개선하라"
```

- ✅ MVP부터 빠르게 검증
- ✅ 피드백 기반 개선
- ✅ 리팩토링은 습관

### 14.4 사용자를 생각하라

```
"코드는 수단이고, 사용자 가치가 목적이다"
```

- ✅ 이 코드가 사용자에게 어떤 가치를 주는가?
- ✅ 성능 최적화는 사치가 아니라 존중
- ✅ 에러 메시지는 사용자를 위한 것

### 14.5 팀을 생각하라

```
"혼자 빠르게 가지 말고, 함께 멀리 가라"
```

- ✅ 코드 컨벤션 준수 (일관성)
- ✅ 문서 작성 (지식 공유)
- ✅ 리뷰 요청 (겸손함)

---

## 15. 긴급 상황 대처

### 15.1 프로덕션 버그 발생 시

**STOP! 패닉하지 말고 체계적으로**:

1. **재현 (Reproduce)**
   - 사용자 환경에서 100% 재현 가능한가?
   - 로그를 확인했는가?

2. **격리 (Isolate)**
   - 영향 받는 사용자 범위는? (전체? 특정 조건?)
   - 데이터 손실 가능성은?

3. **핫픽스 vs 롤백**
   - 빠른 수정 가능? → 핫픽스
   - 복잡한 문제? → 이전 버전 롤백

4. **소통**
   - 사용자에게 알림 (앱 내 공지)
   - 예상 복구 시간 공유

5. **근본 원인 분석**
   - 왜 발생했는가?
   - 테스트가 부족했는가?
   - 재발 방지 방안은?

### 15.2 성능 이슈 발생 시

**느린 화면 발견 시**:

1. **측정 (Measure)**
   ```dart
   final stopwatch = Stopwatch()..start();
   // 의심되는 코드
   stopwatch.stop();
   logger.info('Elapsed: ${stopwatch.elapsedMilliseconds}ms');
   ```

2. **프로파일링**
   ```bash
   flutter run --profile
   # DevTools에서 Performance 탭 확인
   ```

3. **병목 찾기**
   - 불필요한 rebuild?
   - 과도한 API 호출?
   - 큰 이미지 로딩?

4. **최적화**
   - Widget rebuild 최소화 (Consumer 부분 사용)
   - 이미지 캐싱 (CachedNetworkImage)
   - Lazy Loading

---

## 16. 마무리

### 16.1 핵심 원칙 요약

1. **구조를 이해하고 존중하라** (Clean Architecture)
2. **일관성을 유지하라** (코드 스타일, 네이밍)
3. **변경의 영향을 항상 고려하라** (테스트, 의존성)
4. **사용자를 생각하라** (에러 메시지, 성능)
5. **문서를 신뢰하라** (PRD, Roadmap)

### 16.2 개발 전 체크리스트 (Quick Reference)

```
[ ] 1. 문서 확인 (PRD, Roadmap)
[ ] 2. 기존 코드 검색 (중복 방지)
[ ] 3. 올바른 레이어에 배치 (Domain/Data/Presentation)
[ ] 4. 네이밍 규칙 준수 (snake_case, PascalCase)
[ ] 5. 에러 핸들링 추가
[ ] 6. 테스트 작성
[ ] 7. flutter analyze 통과
[ ] 8. dart format 실행
[ ] 9. 자가 리뷰
[ ] 10. 문서 업데이트 (필요 시)
```

### 16.3 질문이 있을 때

**우선순위**:
1. **문서 확인**: `docs/` 폴더의 모든 문서
2. **코드 검색**: 비슷한 구현이 있는지 확인
3. **질문**: 불명확한 부분은 반드시 물어보기

---

## 17. 에이전트 시스템 (Agent System)

### 17.1 에이전트 개요

**에이전트란?**
- 특정 영역의 작업을 자율적으로 수행하는 전문 AI 협업자
- Claude Code의 Task tool을 사용하여 생성
- 각 에이전트는 명확한 책임과 전문성을 가짐

**에이전트 활용 원칙**:
- ✅ **전문성**: 각 에이전트는 특정 영역의 전문가
- ✅ **자율성**: 명확한 목표만 주면 자율적으로 작업
- ✅ **일관성**: 동일한 작업은 항상 같은 에이전트가 담당
- ✅ **협업**: 복잡한 작업은 여러 에이전트가 순차적으로 수행

**에이전트 vs 직접 작업**:
```
에이전트 호출:
- 복잡한 구현 (여러 파일 생성/수정)
- 전문 지식 필요 (애니메이션, API 통합)
- 반복적 패턴 (여러 화면 UI 구현)

직접 작업:
- 간단한 수정 (1-2줄)
- 즉각적 응답 필요
- 탐색 및 분석
```

---

### 17.2 에이전트 목록 및 역할

#### 🎨 Agent 1: UI/UX Implementation Agent

**ID**: `ui-ux-agent`

**책임 범위**:
- 화면별 UI 구현 (Screens, Widgets)
- Material Design 3 적용
- 반응형 레이아웃 구현
- 테마 일관성 유지
- 접근성 고려

**호출 시점**:
- 새로운 화면 구현 시
- 복잡한 위젯 컴포넌트 개발 시
- UI 리팩토링 시

**전문 영역**:
- Flutter Widget 구조
- 테마 및 스타일링
- 애니메이션 기본 구현
- 사용자 입력 처리

**프롬프트 템플릿**:
```
[UI/UX Agent] {화면/위젯 이름} 구현

**목표**: {구현할 화면/위젯 설명}

**참조 문서**:
- docs/prd.md 섹션 {X.X}: {기능 명세}
- docs/roadmap.md 섹션 {Y.Y}: {UI 가이드라인}

**요구사항**:
1. Clean Architecture 준수 (lib/presentation/screens/{feature}/)
2. 테마 적용 (app/theme.dart 사용)
3. 반응형 디자인
4. 접근성 고려 (시맨틱 위젯)

**구현 파일**:
- lib/presentation/screens/{feature}/{screen_name}_screen.dart
- lib/presentation/screens/{feature}/widgets/{widget_name}.dart

**체크리스트**:
- [ ] 네이밍 규칙 준수 (snake_case 파일명, PascalCase 클래스명)
- [ ] 재사용 가능한 위젯 분리
- [ ] 불필요한 rebuild 방지 (Consumer 부분 적용)
- [ ] flutter analyze 통과
- [ ] dart format 적용
```

**호출 예시**:
```
"UI/UX Agent를 생성하여 홈 화면을 구현해줘.

docs/prd.md의 7.4절 '홈 화면 와이어프레임'과 docs/roadmap.md의 2.2절 '디자인 시스템'을 참고하여:
- lib/presentation/screens/home/home_screen.dart
- lib/presentation/screens/home/widgets/daily_verse_card.dart
- lib/presentation/screens/home/widgets/streak_widget.dart
- lib/presentation/screens/home/widgets/quick_actions.dart

위 파일들을 구현해줘."
```

---

#### 🔌 Agent 2: Backend Integration Agent

**ID**: `backend-agent`

**책임 범위**:
- Supabase 연동
- 인증 시스템 구현
- 데이터베이스 CRUD
- Realtime Subscription
- RLS 정책 준수

**호출 시점**:
- 새로운 데이터 소스 추가 시
- Repository 구현 시
- Supabase 설정 변경 시

**전문 영역**:
- Supabase Flutter SDK
- PostgreSQL / RLS
- 실시간 데이터 동기화
- 에러 핸들링

**프롬프트 템플릿**:
```
[Backend Agent] {기능} Supabase 연동

**목표**: {구현할 백엔드 기능}

**참조 문서**:
- docs/prd.md 섹션 6: 데이터 아키텍처
- docs/roadmap.md 섹션 4: Supabase 연동 계획

**요구사항**:
1. Clean Architecture 준수
   - lib/data/datasources/{name}_datasource.dart
   - lib/data/repositories/{name}_repository.dart
   - lib/data/models/{name}_model.dart
2. RLS 정책 준수
3. Either 패턴 사용 (성공/실패 명시)
4. 사용자 친화적 에러 메시지

**데이터베이스 테이블**: {테이블명}

**체크리스트**:
- [ ] Null Safety 철저히 적용
- [ ] 에러 타입 정의 (lib/core/error/failures.dart)
- [ ] 테스트 작성 (mock repository)
- [ ] RLS 정책 검증
```

**호출 예시**:
```
"Backend Agent를 생성하여 인증 시스템을 구현해줘.

docs/prd.md의 4.1절 '인증 및 사용자 관리'를 참고하여:
- Supabase Auth 통합 (이메일, Google, Apple)
- lib/data/datasources/supabase_auth_datasource.dart
- lib/data/repositories/auth_repository.dart
- lib/data/models/user_model.dart

위 파일들을 구현하고 RLS 정책을 준수해줘."
```

---

#### 📖 Agent 3: Bible API Agent

**ID**: `bible-api-agent`

**책임 범위**:
- Bible API 통합
- 성경 구절 조회
- 로컬 캐싱 구현
- API 실패 대비 (Fallback)

**호출 시점**:
- 성경 API 통합 시
- 캐싱 로직 구현 시
- API 변경 대응 시

**전문 영역**:
- bible.helloao.org API
- 캐싱 전략
- 다국어 번역본 처리

**프롬프트 템플릿**:
```
[Bible API Agent] 성경 API 통합

**목표**: Bible API를 통한 성경 구절 조회 및 캐싱

**참조 문서**:
- docs/prd.md 섹션 4.2: 일일 말씀 & 질문 시스템
- docs/roadmap.md 섹션 5: 성경 API 통합

**요구사항**:
1. bible.helloao.org API 통합
2. 캐싱 우선 (Supabase bible_cache 테이블)
3. API 실패 시 Fallback 제공
4. 다국어 지원 (KRV, NIV)

**구현 파일**:
- lib/data/datasources/bible_api_datasource.dart
- lib/data/repositories/verse_repository.dart
- lib/data/models/verse_model.dart

**체크리스트**:
- [ ] 캐시 Hit/Miss 로그 (개발 환경)
- [ ] API 타임아웃 처리
- [ ] 오프라인 대응
- [ ] 성능 최적화 (불필요한 재호출 방지)
```

---

#### 🤖 Agent 4: AI Integration Agent

**ID**: `ai-agent`

**책임 범위**:
- Gemini API 통합
- 질문 생성 프롬프트 최적화
- AI 응답 품질 검증
- 비용 최적화 (캐싱)

**호출 시점**:
- AI 기능 구현 시
- 프롬프트 개선 시
- GPT API 추가 시 (프리미엄 기능)

**전문 영역**:
- Gemini 1.5 Flash API
- Prompt Engineering
- 응답 파싱 및 검증

**프롬프트 템플릿**:
```
[AI Agent] {AI 기능} 구현

**목표**: {AI 기능 설명}

**참조 문서**:
- docs/prd.md 섹션 5: AI 기능 통합 계획
- docs/roadmap.md 섹션 6: AI 기능 통합

**요구사항**:
1. Gemini 1.5 Flash API 사용
2. 프롬프트를 상수로 관리 (lib/core/constants/ai_prompts.dart)
3. 응답 캐싱 (비용 절감)
4. 품질 검증 로직

**구현 파일**:
- lib/data/datasources/gemini_api_datasource.dart
- lib/core/constants/ai_prompts.dart

**체크리스트**:
- [ ] 프롬프트 버전 관리
- [ ] 응답 검증 (부적절한 내용 필터링)
- [ ] 비용 추적 로그
- [ ] 타임아웃 처리
```

---

#### 🔔 Agent 5: Notification Agent

**ID**: `notification-agent`

**책임 범위**:
- FCM 통합
- 푸시 알림 설정
- 로컬 알림
- Supabase Edge Function (알림 전송)

**호출 시점**:
- 알림 시스템 구현 시
- 알림 설정 화면 개발 시
- Edge Function 작성 시

**전문 영역**:
- Firebase Cloud Messaging
- flutter_local_notifications
- Supabase Edge Functions (Deno)

**프롬프트 템플릿**:
```
[Notification Agent] 알림 시스템 구현

**목표**: {알림 기능 설명}

**참조 문서**:
- docs/prd.md 섹션 4.2 F-006: 푸시 알림
- docs/roadmap.md Phase 5: 알림 시스템

**요구사항**:
1. FCM 통합 (iOS, Android)
2. 사용자 설정 반영 (알림 시간, ON/OFF)
3. 로컬 알림 (백그라운드)
4. Supabase Edge Function (서버 전송)

**구현 파일**:
- lib/data/services/notification_service.dart
- supabase/functions/send-daily-notification/index.ts

**체크리스트**:
- [ ] 권한 요청 (iOS, Android)
- [ ] 백그라운드 알림 테스트
- [ ] 알림 클릭 시 딥링크
- [ ] Cron Job 설정 (매일 오전 9시)
```

---

#### ✨ Agent 6: Animation Agent

**ID**: `animation-agent`

**책임 범위**:
- 복잡한 애니메이션 구현
- Dual Reveal 카드 뒤집기
- 마일스톤 축하 (Confetti)
- 로딩 애니메이션

**호출 시점**:
- 커스텀 애니메이션 필요 시
- 사용자 경험 향상 필요 시
- Lottie 애니메이션 통합 시

**전문 영역**:
- Flutter Animation API
- AnimationController
- Tween, Curve
- Lottie, Confetti

**프롬프트 템플릿**:
```
[Animation Agent] {애니메이션} 구현

**목표**: {애니메이션 설명}

**참조 문서**:
- docs/prd.md 섹션 7.4: UI/UX 가이드라인
- docs/roadmap.md 섹션 2.3: 애니메이션 가이드

**요구사항**:
1. 부드러운 애니메이션 (60fps)
2. 메모리 누수 방지 (dispose)
3. 성능 최적화
4. 접근성 고려 (애니메이션 비활성화 옵션)

**구현 파일**:
- lib/presentation/screens/{feature}/widgets/{animation_name}.dart

**체크리스트**:
- [ ] AnimationController dispose
- [ ] 성능 프로파일링
- [ ] 다양한 기기 테스트
- [ ] 애니메이션 duration 적절성
```

---

#### 🧪 Agent 7: Testing Agent

**ID**: `testing-agent`

**책임 범위**:
- 단위 테스트 작성
- 통합 테스트 작성
- Widget 테스트
- Mock 객체 생성

**호출 시점**:
- 새로운 기능 구현 후
- 리팩토링 후
- 버그 수정 후 (재발 방지)

**전문 영역**:
- flutter_test
- mockito
- integration_test
- AAA 패턴

**프롬프트 템플릿**:
```
[Testing Agent] {기능} 테스트 작성

**목표**: {테스트할 기능}

**참조 문서**:
- docs/roadmap.md 섹션 9: 테스트 전략
- CLAUDE.md 섹션 9: 테스트 작성 규칙

**요구사항**:
1. AAA 패턴 (Arrange-Act-Assert)
2. 테스트 커버리지 목표 달성
   - Domain: 100%
   - Data: 80%
   - Presentation: 60%
3. 명확한 테스트 이름
4. Mock 객체 적절히 사용

**구현 파일**:
- test/{layer}/{feature}/{file_name}_test.dart

**체크리스트**:
- [ ] 모든 엣지 케이스 커버
- [ ] 테스트 독립성 (순서 무관)
- [ ] 테스트 실패 시 명확한 메시지
- [ ] flutter test 통과
```

---

### 17.3 에이전트 호출 규칙

#### 호출 문법

```dart
// Task tool 사용
Task(
  subagent_type: "general-purpose",
  description: "[Agent ID] 작업 요약",
  prompt: """
  [에이전트 프롬프트 템플릿]
  """
)
```

#### 호출 우선순위

**1순위: 복잡한 구현**
```
상황: 새로운 화면 전체 구현
→ UI/UX Agent 호출

상황: 백엔드 연동 및 데이터 처리
→ Backend Agent 호출
```

**2순위: 전문 영역**
```
상황: 복잡한 애니메이션 필요
→ Animation Agent 호출

상황: AI 프롬프트 최적화
→ AI Agent 호출
```

**3순위: 품질 보증**
```
상황: 기능 구현 완료 후
→ Testing Agent 호출 (테스트 작성)
```

#### 호출 금지 상황

❌ **간단한 수정 (1-2줄)**
```dart
// 이런 건 직접 수정
final color = Colors.blue; → final color = Colors.red;
```

❌ **탐색 및 분석**
```
"이 프로젝트의 구조를 분석해줘"
→ Explore agent 또는 직접 분석
```

❌ **즉각적 응답 필요**
```
"이 에러가 뭐야?"
→ 직접 분석
```

---

### 17.4 에이전트 자동 호출 가이드라인

**IMPORTANT**: Claude Code는 다음 상황에서 **자동으로** 적절한 에이전트를 호출해야 합니다.

#### 자동 호출 규칙

**Rule 1: 새로운 화면 구현 요청 시**
```
사용자 요청: "로그인 화면 만들어줘"
→ 자동으로 UI/UX Agent 호출

사용자 요청: "홈 화면 UI 구현해줘"
→ 자동으로 UI/UX Agent 호출
```

**Rule 2: API 통합 요청 시**
```
사용자 요청: "Supabase 인증 연동해줘"
→ 자동으로 Backend Agent 호출

사용자 요청: "성경 API 통합해줘"
→ 자동으로 Bible API Agent 호출

사용자 요청: "Gemini로 질문 생성 기능 만들어줘"
→ 자동으로 AI Agent 호출
```

**Rule 3: 복잡한 애니메이션 요청 시**
```
사용자 요청: "Dual Reveal 애니메이션 구현해줘"
→ 자동으로 Animation Agent 호출

사용자 요청: "마일스톤 축하 애니메이션 만들어줘"
→ 자동으로 Animation Agent 호출
```

**Rule 4: 테스트 작성 요청 시**
```
사용자 요청: "이 기능 테스트 작성해줘"
→ 자동으로 Testing Agent 호출

사용자 요청: "테스트 커버리지 올려줘"
→ 자동으로 Testing Agent 호출
```

**Rule 5: Phase 단위 작업 요청 시**
```
사용자 요청: "Phase 1 시작하자" (인증 및 온보딩)
→ 순차적으로:
   1. Backend Agent (인증 시스템)
   2. UI/UX Agent (로그인, 회원가입 화면)
   3. Testing Agent (테스트 작성)

사용자 요청: "Phase 2 진행해줘" (일일 말씀 시스템)
→ 순차적으로:
   1. Bible API Agent (성경 API 통합)
   2. AI Agent (질문 생성)
   3. Backend Agent (Supabase Edge Function)
   4. UI/UX Agent (말씀 카드 UI)
   5. Testing Agent (테스트)
```

#### 호출 전 확인 사항

**Claude Code는 에이전트 호출 전에 반드시**:
1. ✅ 문서 확인 (docs/prd.md, docs/roadmap.md)
2. ✅ 기존 코드 검색 (중복 방지)
3. ✅ 의존성 확인 (선행 작업 완료 여부)
4. ✅ 에이전트 프롬프트 작성 (명확한 목표, 요구사항, 체크리스트)

---

### 17.5 개발 단계별 에이전트 활용

#### Phase 0: 프로젝트 셋업 (Week 1)

```
작업: 프로젝트 초기화
→ 직접 수행 (간단한 설정)

작업: Supabase 테이블 생성
→ Backend Agent 호출
```

#### Phase 1: 인증 및 온보딩 (Week 2)

```
Task 1.1: 인증 시스템
→ Backend Agent (Supabase Auth 통합)
→ UI/UX Agent (로그인, 회원가입 화면)
→ Testing Agent (인증 플로우 테스트)

Task 1.2: 온보딩 플로우
→ UI/UX Agent (스플래시, 온보딩 3단계, 프로필 설정)

Task 1.3: 커플 매칭
→ Backend Agent (초대 링크 생성, 커플 연결)
→ UI/UX Agent (초대 화면)
```

#### Phase 2: 일일 말씀 시스템 (Week 3-4)

```
Task 2.1: 성경 API 통합
→ Bible API Agent (API 통합, 캐싱)

Task 2.2: AI 질문 생성
→ AI Agent (Gemini API, 프롬프트 최적화)

Task 2.3: Supabase Edge Function
→ Backend Agent (Cron Job, 일일 생성 함수)

Task 2.4: UI 구현
→ UI/UX Agent (홈 화면, 말씀 카드, 질문 카드)
```

#### Phase 3: 답변 & Dual Reveal (Week 5-6)

```
Task 3.1: 답변 작성
→ UI/UX Agent (텍스트 입력, 글자 수 카운터)
→ Backend Agent (답변 저장, 임시 저장)

Task 3.2: Dual Reveal 애니메이션
→ Animation Agent (카드 뒤집기 애니메이션)
→ UI/UX Agent (대기 화면, 공개 화면)

Task 3.3: 실시간 동기화
→ Backend Agent (Realtime Subscriptions)
```

#### Phase 4: 스트릭 & 마일스톤 (Week 7)

```
Task 4.1: 스트릭 시스템
→ Backend Agent (스트릭 계산 로직)
→ UI/UX Agent (스트릭 위젯)

Task 4.2: 마일스톤 축하
→ Animation Agent (Confetti 애니메이션)
→ UI/UX Agent (축하 화면, 공유 기능)
```

#### Phase 5: 알림 시스템 (Week 8)

```
Task 5.1: 푸시 알림
→ Notification Agent (FCM 통합, Edge Function)

Task 5.2: 로컬 알림
→ Notification Agent (flutter_local_notifications)
→ UI/UX Agent (알림 설정 화면)
```

#### Phase 6: 부가 기능 (Week 9)

```
Task 6.1: 과거 대화 보기
→ UI/UX Agent (타임라인 UI, 상세 보기)
→ Backend Agent (데이터 조회, 필터링)

Task 6.2: 설정
→ UI/UX Agent (설정 화면)
```

#### Phase 7: 테스트 & 최적화 (Week 10)

```
Task 7.1: 테스트
→ Testing Agent (전체 테스트 작성, 커버리지 목표 달성)

Task 7.2: 성능 최적화
→ 직접 수행 (프로파일링, 최적화)
```

---

### 17.6 에이전트 협업 패턴

#### 순차 협업 (Sequential)

**패턴**: A → B → C
```
예시: 새로운 기능 추가
1. Backend Agent (API 연동)
   ↓
2. UI/UX Agent (화면 구현)
   ↓
3. Testing Agent (테스트 작성)
```

#### 병렬 협업 (Parallel)

**패턴**: A + B (동시)
```
예시: 독립적인 화면들
- UI/UX Agent (홈 화면) || UI/UX Agent (설정 화면)
```

#### 피드백 협업 (Feedback)

**패턴**: A → 리뷰 → A (수정)
```
예시: 애니메이션 개선
1. Animation Agent (초안 구현)
   ↓
2. 사용자 피드백
   ↓
3. Animation Agent (수정)
```

---

### 17.7 에이전트 프롬프트 예시 (실전)

#### 예시 1: 홈 화면 구현

```markdown
[UI/UX Agent] 홈 화면 구현

**목표**: Bible SumOne MVP의 홈 화면을 구현합니다.

**참조 문서**:
- docs/prd.md 섹션 7.4: 홈 화면 와이어프레임
- docs/roadmap.md 섹션 2: UI 디자인 시스템
- CLAUDE.md 섹션 2-5: 아키텍처 및 코딩 스타일

**요구사항**:
1. **구조**:
   - lib/presentation/screens/home/home_screen.dart (메인 화면)
   - lib/presentation/screens/home/widgets/daily_verse_card.dart (오늘의 말씀 카드)
   - lib/presentation/screens/home/widgets/streak_widget.dart (스트릭 위젯)
   - lib/presentation/screens/home/widgets/quick_actions.dart (빠른 액션)

2. **디자인**:
   - Material Design 3
   - 테마 적용 (app/theme.dart의 primaryColor, 폰트)
   - 반응형 레이아웃 (다양한 화면 크기)

3. **기능**:
   - 스트릭 표시 (🔥 7일째 함께 읽고 있어요!)
   - 오늘의 말씀 카드 (성경 구절 미리보기)
   - "읽으러 가기" 버튼 → /verse/daily 화면으로 이동
   - 하단: "📚 과거 대화 보기", "⚙️ 설정" 링크

4. **상태 관리**:
   - Riverpod Provider 사용 (verseProvider, streakProvider)
   - Consumer로 필요한 부분만 rebuild

**체크리스트**:
- [ ] 네이밍 규칙 (snake_case 파일명, PascalCase 클래스명)
- [ ] Clean Architecture (Presentation 레이어만)
- [ ] 재사용 위젯 분리 (DailyVerseCard, StreakWidget)
- [ ] 불필요한 rebuild 방지
- [ ] 접근성 (Semantics)
- [ ] flutter analyze 통과
- [ ] dart format 적용

**구현 후 알려줄 것**:
- 생성된 파일 목록
- 주요 구현 내용
- 다음 단계 제안 (예: Provider 구현, 라우팅 추가)
```

#### 예시 2: Supabase 인증 통합

```markdown
[Backend Agent] Supabase 인증 시스템 구현

**목표**: Supabase Auth를 통한 회원가입, 로그인, 로그아웃 구현

**참조 문서**:
- docs/prd.md 섹션 4.1: 회원가입 / 로그인 (F-001)
- docs/roadmap.md 섹션 4: Supabase 연동 계획
- CLAUDE.md 섹션 7.1: Supabase 사용 규칙

**요구사항**:
1. **인증 방식**:
   - 이메일/비밀번호
   - Google OAuth
   - Apple OAuth (iOS)

2. **구현 파일**:
   - lib/data/datasources/supabase_auth_datasource.dart
   - lib/data/repositories/auth_repository.dart
   - lib/data/models/user_model.dart
   - lib/domain/entities/user.dart
   - lib/domain/usecases/auth/sign_in_usecase.dart
   - lib/domain/usecases/auth/sign_up_usecase.dart
   - lib/domain/usecases/auth/sign_out_usecase.dart

3. **에러 핸들링**:
   - Either 패턴 사용
   - 에러 타입 정의 (lib/core/error/failures.dart에 AuthFailure 추가)
   - 사용자 친화적 메시지

4. **보안**:
   - RLS 정책 준수
   - 비밀번호 로그 금지
   - 토큰 안전 저장 (Supabase가 자동 처리)

**데이터베이스**:
- 테이블: public.users (이미 생성됨)
- RLS 정책: 본인 데이터만 조회/수정

**체크리스트**:
- [ ] Clean Architecture 의존성 규칙 (Domain → Data X)
- [ ] Null Safety
- [ ] Either<Failure, User> 반환
- [ ] 에러 메시지 매핑
- [ ] 테스트 작성 (mockito)

**구현 후 알려줄 것**:
- 생성된 파일 및 주요 함수 시그니처
- 사용 예시 (Provider에서 호출하는 방법)
- 다음 단계 (AuthProvider 구현 필요)
```

---

### 17.8 에이전트 호출 체크리스트

**에이전트 호출 전 (Claude Code가 확인)**:

- [ ] **1. 문서 확인**: docs/prd.md, docs/roadmap.md에서 해당 기능 확인
- [ ] **2. 기존 코드 검색**: 비슷한 구현이 있는지 확인 (Grep, Glob)
- [ ] **3. 의존성 확인**: 선행 작업이 완료되었는지 확인
- [ ] **4. 적절한 에이전트 선택**: 작업 성격에 맞는 에이전트
- [ ] **5. 명확한 프롬프트 작성**:
  - 목표 명시
  - 참조 문서 제공
  - 요구사항 리스트
  - 체크리스트 포함

**에이전트 작업 완료 후 (Claude Code가 확인)**:

- [ ] **1. 결과 검토**: 에이전트가 제공한 파일 목록 확인
- [ ] **2. 품질 확인**:
  - flutter analyze 통과
  - dart format 적용
  - 네이밍 규칙 준수
- [ ] **3. 다음 단계 계획**: 추가 작업 필요한지 확인
- [ ] **4. 사용자 보고**: 간결한 요약 + 다음 단계 제안

---

### 17.9 FAQ

**Q1: 모든 작업을 에이전트에게 맡겨야 하나요?**
A: 아니요. 간단한 수정(1-2줄)이나 탐색 작업은 직접 수행하는 것이 빠릅니다. 에이전트는 복잡한 구현, 전문 지식이 필요한 작업에 활용하세요.

**Q2: 에이전트가 실수하면 어떻게 하나요?**
A: 에이전트 결과를 검토하고, 문제가 있으면 수정 요청하거나 직접 수정합니다. 에이전트는 도구이며, 최종 책임은 개발자에게 있습니다.

**Q3: 여러 에이전트를 동시에 실행할 수 있나요?**
A: Task tool은 순차적으로 실행됩니다. 병렬 작업이 필요하면 각 에이전트를 순차적으로 호출하되, 독립적인 작업을 먼저 모두 시작하세요.

**Q4: 에이전트 프롬프트를 매번 작성해야 하나요?**
A: 이 문서의 템플릿을 사용하면 됩니다. Claude Code가 자동으로 적절한 템플릿을 채워서 호출합니다.

**Q5: 에이전트가 문서를 읽을 수 있나요?**
A: 네, Task tool로 생성된 에이전트는 모든 파일에 접근 가능합니다. 프롬프트에 "docs/prd.md 참조"라고 명시하면 자동으로 읽습니다.

---

## 18. 문서 버전 관리

**이 문서는 살아있는 문서입니다**:
- ✅ 새로운 패턴 발견 시 추가
- ✅ 문제 발생 시 교훈 추가
- ✅ 팀 합의 사항 반영
- ✅ 에이전트 활용 패턴 업데이트

**변경 히스토리**:
- v1.0 (2026-03-24): 초안 작성
- v1.1 (2026-03-24): 에이전트 시스템 추가 (섹션 17)
- v1.2 (2026-03-24): Claude Code 필수 워크플로우 규칙 추가 (섹션 19)

---

## 19. Claude Code 필수 워크플로우 규칙 ⭐

**CRITICAL**: 이 섹션의 규칙은 **모든 작업에서 예외 없이** 준수해야 합니다.

### 19.1 Roadmap 진행 상황 업데이트 (필수!)

#### 규칙: Task/Phase 완료 시 ✅ 표시

**언제 적용하는가**:
- ✅ docs/roadmap.md의 Task 항목 완료 시
- ✅ Phase의 모든 Task 완료 시
- ✅ 체크리스트 항목 완료 시

**어떻게 적용하는가**:

```markdown
# ❌ 잘못된 예 (완료했는데 표시 안 함)
#### Task 0.2: Supabase 설정
- [ ] Supabase 프로젝트 생성
- [ ] 데이터베이스 테이블 생성 (SQL 실행)
- [ ] RLS 정책 설정

# ✅ 올바른 예 (완료 즉시 ✅ 표시)
#### Task 0.2: Supabase 설정
- [✅] Supabase 프로젝트 생성
- [✅] 데이터베이스 테이블 생성 (SQL 실행)
- [✅] RLS 정책 설정
```

**프로세스**:
1. Task 또는 항목 완료
2. **즉시** docs/roadmap.md 파일 열기
3. 해당 항목 찾기
4. `[ ]` → `[✅]` 변경
5. 파일 저장

**Phase 완료 표시**:
```markdown
# ✅ Phase 전체 완료 시
### Phase 0: 프로젝트 셋업 (Week 1) ✅

#### Task 0.1: 프로젝트 초기화 ✅
- [✅] Flutter 프로젝트 생성
- [✅] pubspec.yaml에 모든 패키지 추가

#### Task 0.2: Supabase 설정 ✅
- [✅] Supabase 프로젝트 생성
- [✅] 데이터베이스 테이블 생성
```

**왜 중요한가**:
- ✅ 프로젝트 진행 상황 실시간 파악
- ✅ 다음 작업 우선순위 결정
- ✅ 팀원 간 중복 작업 방지
- ✅ 프로젝트 완성도 추적

---

### 19.2 Git Commit 워크플로우 (필수!)

#### 규칙: 작업 완료 시 자동 커밋

**언제 커밋하는가**:

**✅ 커밋해야 하는 시점**:
1. **기능 구현 완료 시**
   - 새로운 파일 생성 완료
   - 기존 파일 수정 완료
   - 테스트 작성 완료

2. **설정 변경 완료 시**
   - .env 파일 업데이트
   - pubspec.yaml 변경
   - 라우팅 추가

3. **문서 업데이트 완료 시**
   - docs/roadmap.md 체크리스트 업데이트
   - README.md 수정
   - 주석 추가

4. **리팩토링 완료 시**
   - 코드 구조 변경
   - 파일 이동/이름 변경

5. **버그 수정 완료 시**
   - 버그 픽스 완료
   - 관련 테스트 추가

**커밋 프로세스**:

```bash
# Step 1: 변경 사항 확인
git status

# Step 2: 변경 파일 스테이징
git add <파일명>  # 또는 git add . (신중하게!)

# Step 3: 커밋 메시지 작성 (한국어)
git commit -m "커밋 메시지

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

**커밋 메시지 규칙**:

```bash
# ✅ 좋은 예
git commit -m "feat: Supabase 클라이언트 설정 및 초기화 추가

- lib/core/constants/supabase_client.dart 생성
- main.dart에 Supabase.initialize() 추가
- .env 파일에 API 키 설정

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# ✅ 좋은 예 (간단한 수정)
git commit -m "fix: 로그인 버튼 색상 수정

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# ❌ 나쁜 예
git commit -m "수정"  # 무엇을 수정했는지 모름
git commit -m "WIP"  # 불명확
git commit -m "ㅇㅇ"  # 의미 없음
```

**커밋 메시지 prefix**:
- `feat:` 새로운 기능 추가
- `fix:` 버그 수정
- `refactor:` 코드 리팩토링
- `docs:` 문서 수정
- `style:` 코드 스타일 변경 (포맷팅)
- `test:` 테스트 추가/수정
- `chore:` 기타 변경 사항 (빌드, 패키지 등)

**커밋 타이밍**:

```
작업 시작
  ↓
코드 작성
  ↓
flutter analyze 통과
  ↓
dart format 적용
  ↓
✅ git commit  ← 여기서 커밋!
  ↓
다음 작업 시작
```

**예외: 커밋하지 않는 경우**:
- ❌ 코드가 작동하지 않을 때
- ❌ 테스트가 실패할 때
- ❌ flutter analyze 에러가 있을 때
- ❌ 임시 실험 코드

**왜 중요한가**:
- ✅ 작업 이력 추적 가능
- ✅ 문제 발생 시 롤백 가능
- ✅ 협업 시 변경 사항 공유
- ✅ 코드 리뷰 용이

---

### 19.3 워크플로우 체크리스트

**모든 작업 완료 시 확인**:

```
[ ] 1. 코드 품질 확인
    [ ] flutter analyze 통과
    [ ] dart format 적용
    [ ] 네이밍 규칙 준수

[ ] 2. 문서 업데이트
    [ ] docs/roadmap.md 체크리스트 ✅ 표시
    [ ] 필요시 주석 추가

[ ] 3. Git 커밋
    [ ] git status 확인
    [ ] 변경 파일 스테이징
    [ ] 명확한 커밋 메시지 작성
    [ ] Co-Authored-By 추가
    [ ] git commit 실행

[ ] 4. 다음 단계 확인
    [ ] roadmap.md에서 다음 Task 확인
    [ ] 의존성 확인
```

---

### 19.4 자동화 스크립트 (선택사항)

**빠른 커밋 스크립트**:

```bash
# commit.sh (Git Bash)
#!/bin/bash

# 사용법: ./commit.sh "feat: 커밋 메시지"

if [ -z "$1" ]; then
  echo "❌ 커밋 메시지를 입력하세요"
  echo "사용법: ./commit.sh \"feat: 메시지\""
  exit 1
fi

echo "📝 변경 사항 확인..."
git status

echo ""
echo "✅ 스테이징 중..."
git add .

echo ""
echo "💬 커밋 메시지: $1"
git commit -m "$1

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

echo ""
echo "🎉 커밋 완료!"
git log -1 --oneline
```

**사용 예시**:
```bash
chmod +x commit.sh
./commit.sh "feat: 홈 화면 UI 구현 완료"
```

---

### 19.5 FAQ

**Q: 작은 수정(1-2줄)도 커밋해야 하나요?**
A: 네! 작은 수정도 의미 있는 변경이라면 커밋하세요. 단, 여러 개의 작은 수정을 모아서 한 번에 커밋할 수도 있습니다.

**Q: roadmap.md 업데이트를 잊었어요!**
A: 지금 즉시 업데이트하고 별도로 커밋하세요:
```bash
git add docs/roadmap.md
git commit -m "docs: Phase 0.2 완료 상태 업데이트

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

**Q: 커밋 메시지를 잘못 작성했어요!**
A: 마지막 커밋이라면 수정 가능합니다:
```bash
git commit --amend
```
단, 이미 push한 커밋은 수정하지 마세요!

**Q: 여러 Task를 한꺼번에 완료했어요. 커밋을 어떻게 하나요?**
A: Task별로 별도 커밋하세요. 하나의 거대한 커밋보다 여러 개의 작은 커밋이 좋습니다.

---

### 19.6 Quick Reference (빠른 참조)

**작업 완료 후 3단계**:

```
1️⃣ 문서 업데이트
   docs/roadmap.md → [ ] 를 [✅]로 변경

2️⃣ 코드 검증
   flutter analyze
   dart format .

3️⃣ Git 커밋
   git add .
   git commit -m "prefix: 메시지

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

**Claude Code는 이 규칙을 항상 준수합니다! 🤖✅**

---

## 🎯 Remember

```
"좋은 코드는 작동하는 코드가 아니라,
 6개월 후에도 이해 가능한 코드다"

"완벽한 코드를 쓰려 하지 말고,
 지속적으로 개선 가능한 코드를 써라"

"혼자 빠르게 가지 말고,
 함께 멀리 가라"

"복잡한 작업은 에이전트에게,
 핵심 결정은 개발자가"
```

---

**이 가이드를 지키면**:
- ✅ 버그가 줄어듭니다
- ✅ 유지보수가 쉬워집니다
- ✅ 팀 협업이 원활해집니다
- ✅ 사용자가 행복해집니다
- ✅ **에이전트와의 협업으로 개발 속도가 향상됩니다**

**Let's Build with Excellence! 🚀🤖**

---

**문서 작성자**: Senior Development Team
**검토자**: Architecture Team
**승인**: Product Team
