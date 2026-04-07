# Task 2.4: 일일 말씀 UI 구현

**Phase**: 2 (일일 말씀 시스템)
**상태**: 미구현
**선행 완료**: Task 2.1 (로컬 성경 데이터) ✅, Task 2.2 (AI 질문 생성) ✅, Task 2.3 (Edge Function) ✅

---

## 필수 참조 문서

- `CLAUDE.md` - 코딩 규칙, 아키텍처 원칙, 금지사항
- `docs/prd.md` 섹션 7.4 - 홈 화면 와이어프레임
- `docs/prd.md` 섹션 3.1 (US-002, US-003) - 유저 스토리
- `docs/design-guideline.md` - 디자인 시스템, 공통 위젯 사용법
- `docs/roadmap.md` 섹션 7 - Phase 2 Task 2.4 항목
- `docs/plan-codex/AGENTS.md` - 프로젝트 규약 요약

---

## 구현 목표

HomeScreen을 재구성하고, 오늘의 말씀 상세 화면과 질문 카드 UI를 구현한다.

---

## 현재 상태 분석

### 이미 구현된 것 (건드리지 말 것)
- `lib/presentation/screens/home/home_screen.dart` - 기본 홈 화면 (커플 상태 + 플레이스홀더)
- `lib/presentation/providers/auth_provider.dart` - 인증 상태
- `lib/presentation/providers/couple_provider.dart` - 커플 상태
- `lib/presentation/providers/question_generation_provider.dart` - AI 질문 생성
- `lib/data/datasources/local_bible_datasource.dart` - 로컬 성경 데이터
- `lib/data/datasources/gemini_api_datasource.dart` - Gemini API
- `lib/data/models/couple_model.dart` - 커플 모델 (hasPlan, dailyVersePlan 포함)
- `lib/app/routes.dart` - 라우팅 (Phase 2 라우트 주석 처리 상태)
- `lib/app/theme.dart` - 테마 설정
- 12개 공통 위젯 (`lib/presentation/widgets/`)

### 구현 필요한 것
1. HomeScreen 재구성 (주간 캘린더, 성령의 불, 오늘의 말씀 카드)
2. DailyVerseScreen (오늘의 말씀 상세 + 질문 카드)
3. DailyVerseModel (daily_verses 테이블 모델)
4. DailyVerse Entity
5. VerseProvider (말씀 상태 관리)
6. 라우트 활성화

---

## 단계별 구현 계획

### Step 1: Domain Entity 생성

**파일**: `lib/domain/entities/daily_verse.dart`

```dart
class DailyVerse {
  final String verseId;
  final DateTime date;
  final String bibleBook;
  final int chapter;
  final int verseStart;
  final int? verseEnd;
  final String textKorean;
  final String? textEnglish;
  final String questionKorean;
  final String? questionEnglish;
  final String? topic;
  final DateTime createdAt;

  // 편의 getter
  String get reference; // "고린도전서 13:4-7" 형식
  bool get isToday;
}
```

**규칙**:
- Domain Layer → 외부 라이브러리 import 금지
- 순수 Dart 코드만 사용
- `final` 필드, `const` 생성자

---

### Step 2: Data Model 생성

**파일**: `lib/data/models/daily_verse_model.dart`

```dart
class DailyVerseModel extends DailyVerse {
  // fromJson: Supabase daily_verses 테이블 파싱
  // toJson: Supabase 저장용
  // toEntity: Domain 변환
  // fromEntity: 역변환
}
```

**참조**: `lib/data/models/couple_model.dart`의 패턴을 동일하게 따를 것

**Supabase daily_verses 테이블 스키마** (docs/roadmap.md 섹션 4.3):
```sql
verse_id UUID PRIMARY KEY
date DATE UNIQUE NOT NULL
bible_book VARCHAR(50) NOT NULL
chapter INT NOT NULL
verse_start INT NOT NULL
verse_end INT
text_korean TEXT NOT NULL
text_english TEXT
question_korean TEXT NOT NULL
question_english TEXT
topic VARCHAR(50)
created_at TIMESTAMP
```

---

### Step 3: VerseProvider 구현

**파일**: `lib/presentation/providers/verse_provider.dart`

**상태 클래스**: `lib/presentation/providers/verse_state.dart`

```dart
// verse_state.dart
class VerseState {
  final bool isLoading;
  final DailyVerse? todayVerse;
  final String? error;
  final List<DailyVerse> weeklyVerses; // 주간 캘린더용
}
```

```dart
// verse_provider.dart
class VerseProvider extends StateNotifier<VerseState> {
  // 의존성: SupabaseClient (또는 VerseRepository)

  Future<void> loadTodayVerse(String coupleId);
  Future<void> loadWeeklyVerses(String coupleId);
}

final verseProvider = StateNotifierProvider<VerseProvider, VerseState>(...);
```

**패턴 참조**: `lib/presentation/providers/couple_provider.dart` 동일 패턴

**데이터 조회 로직**:
1. Supabase `daily_verses` 테이블에서 오늘 날짜 기준 조회
2. 결과 없으면 Edge Function 호출하여 생성 트리거
3. 주간 데이터: 최근 7일치 조회

---

### Step 4: HomeScreen 재구성

**파일**: `lib/presentation/screens/home/home_screen.dart` (기존 파일 수정)

**와이어프레임** (docs/prd.md 섹션 7.4):
```
┌─────────────────────────────┐
│  [커플 상태 섹션]            │  ← 기존 유지
├─────────────────────────────┤
│         🔥                   │  ← 성령의 불 (Step 4-2)
│      [애니메이션]             │
├─────────────────────────────┤
│  [주간 캘린더 UI]            │  ← Step 4-1
│   월 화 수 목 금 토 일        │
│   ✓  ✓  ✗  ✓  ✓  ✓  ●      │
├─────────────────────────────┤
│   [오늘의 말씀 카드]          │  ← Step 4-3
│   고린도전서 13:4-7          │
│   "사랑은 오래 참고..."       │
│   [읽으러 가기 버튼]          │
└─────────────────────────────┘
```

#### Step 4-1: WeeklyCalendar 위젯

**파일**: `lib/presentation/screens/home/widgets/weekly_calendar.dart`

**기능**:
- 최근 7일 표시 (월~일)
- 각 날짜: 원형 아이콘
  - ✓ (완료): `primaryColor` 배경 + 체크 아이콘
  - ✗ (미완료): 회색 배경 + X 아이콘
  - ● (오늘): `primaryColor` 테두리 + 강조
- 날짜 클릭 시 → 달별 기록 화면 이동 (Phase 6 예정, 지금은 SnackBar)
- `weeklyVerses` 데이터 기반

**UI 규칙**:
- BaseCard로 감싸기 (borderRadius 24px)
- 내부 padding 16px
- 날짜 레이블: `bodyMedium` 스타일
- 상태 아이콘: 32px 원형

```dart
class WeeklyCalendar extends StatelessWidget {
  final List<DailyVerseStatus> weekData; // [{date, isCompleted}]
  final VoidCallback? onTapDate;
}
```

#### Step 4-2: HolyFireWidget 배치

**참조**: `lib/presentation/screens/_test/holy_fire_test_screen.dart` (이미 구현된 테스트 화면)

**NOTE**: 성령의 불 위젯이 이미 구현되어 있을 수 있음. 확인 후:
- 이미 있으면 → import하여 HomeScreen에 배치
- 없으면 → 간단한 플레이스홀더 (아이콘 + 스트릭 텍스트) 배치, Phase 4에서 본격 구현

**배치 위치**: 커플 상태 섹션과 주간 캘린더 사이
**크기**: 80-120px, 투명 배경

#### Step 4-3: DailyVerseCard 위젯

**파일**: `lib/presentation/screens/home/widgets/daily_verse_card.dart`

**기능**:
- 오늘의 말씀 요약 표시
- 성경 구절 reference (예: "고린도전서 13:4-7")
- 본문 미리보기 (최대 2줄, ellipsis)
- "읽으러 가기" 버튼 → DailyVerseScreen 이동
- 로딩 상태: SkeletonLoader
- 말씀 없음 상태: 안내 메시지

```dart
class DailyVerseCard extends StatelessWidget {
  final DailyVerse? verse;
  final bool isLoading;
  final VoidCallback? onTap;
}
```

**UI 규칙**:
- ElevatedCard 또는 BaseCard 사용
- 성경 구절 폰트: `displayLarge` (Noto Serif KR) - 없으면 Pretendard로 대체
- 구절 reference: `titleMedium` + bold
- 버튼: PrimaryButton 사용

#### Step 4-4: HomeScreen body 수정

기존 `_buildDailyVerseSection` 메서드를 실제 데이터 연결로 교체:

```dart
// 변경 사항:
// 1. VerseProvider watch 추가
// 2. 플레이스홀더 → DailyVerseCard 교체
// 3. WeeklyCalendar 추가
// 4. 성령의 불 위젯 배치 (플레이스홀더 또는 실제)
// 5. initState에서 loadTodayVerse 호출 추가
```

**수정 순서 (기존 코드 보존)**:
1. `_buildDailyVerseSection` → DailyVerseCard + VerseProvider 연동
2. `_buildWeeklyCalendarSection` 새로 추가
3. `_buildHolyFireSection` 새로 추가 (플레이스홀더)
4. `build` 메서드의 Column children 순서 변경

---

### Step 5: DailyVerseScreen 구현

**파일**: `lib/presentation/screens/verse/daily_verse_screen.dart`

**와이어프레임** (docs/prd.md):
```
┌─────────────────────────────┐
│  ← 오늘의 말씀                │  ← CustomAppBar
├─────────────────────────────┤
│  고린도전서 13:4-7            │  ← 구절 reference
│                             │
│  "사랑은 오래 참고 사랑은      │  ← 성경 본문 (Noto Serif KR)
│   온유하며 시기하지 아니하며..." │
│                             │
├─────────────────────────────┤
│  💬 오늘의 질문                │  ← QuestionCard 위젯
│  "이 말씀을 우리 관계에        │
│   어떻게 적용할 수 있을까요?"  │
│                             │
├─────────────────────────────┤
│          [소감 쓰기]           │  ← PrimaryButton (Phase 3 연결)
└─────────────────────────────┘
```

**기능**:
- `verseId` 또는 날짜 파라미터로 말씀 로드
- 성경 본문 전체 표시 (스크롤 가능)
- AI 생성 질문 표시 (QuestionCard)
- "소감 쓰기" 버튼 (Phase 3에서 ResponseScreen 연결, 지금은 SnackBar)

**하위 위젯**:

#### Step 5-1: VerseText 위젯

**파일**: `lib/presentation/screens/verse/widgets/verse_text.dart`

```dart
class VerseText extends StatelessWidget {
  final String reference;  // "고린도전서 13:4-7"
  final String text;       // 성경 본문
}
```

- reference: `headlineMedium` 스타일 + bold
- 본문: `displayLarge` 스타일 (Noto Serif KR 또는 Pretendard)
- 줄 간격: 1.8
- BaseCard로 감싸기, padding 24px

#### Step 5-2: QuestionCard 위젯

**파일**: `lib/presentation/screens/verse/widgets/question_card.dart`

```dart
class QuestionCard extends StatelessWidget {
  final String question;
  final bool isLoading;
}
```

- 💬 아이콘 + "오늘의 질문" 레이블
- 질문 텍스트: `bodyLarge` 스타일
- ElevatedCard 사용, primaryColor 테두리 또는 배경 살짝 틴트
- 로딩 시: SkeletonLoader

---

### Step 6: 라우트 활성화

**파일**: `lib/app/routes.dart`

**변경 사항**:
1. DailyVerseScreen import 추가
2. 주석 해제 및 수정:

```dart
// 기존 주석 해제
GoRoute(
  path: '/verse/daily',
  name: 'daily_verse',
  builder: (context, state) => const DailyVerseScreen(),
),

// 추가: verseId로 특정 말씀 보기
GoRoute(
  path: '/verse/:verseId',
  name: 'verse_detail',
  builder: (context, state) {
    final verseId = state.pathParameters['verseId']!;
    return DailyVerseScreen(verseId: verseId);
  },
),
```

---

### Step 7: 연결 확인 및 정리

1. **flutter analyze** 통과 확인
2. **dart format .** 실행
3. 모든 import 경로 확인
4. 사용하지 않는 import 제거

---

## 파일 생성/수정 목록 (Summary)

### 새로 생성할 파일 (7개)
| # | 파일 경로 | 설명 |
|---|---------|------|
| 1 | `lib/domain/entities/daily_verse.dart` | DailyVerse 엔티티 |
| 2 | `lib/data/models/daily_verse_model.dart` | DailyVerse 데이터 모델 |
| 3 | `lib/presentation/providers/verse_state.dart` | 말씀 상태 클래스 |
| 4 | `lib/presentation/providers/verse_provider.dart` | 말씀 상태 관리 Provider |
| 5 | `lib/presentation/screens/home/widgets/weekly_calendar.dart` | 주간 캘린더 위젯 |
| 6 | `lib/presentation/screens/home/widgets/daily_verse_card.dart` | 오늘의 말씀 카드 |
| 7 | `lib/presentation/screens/verse/daily_verse_screen.dart` | 말씀 상세 화면 |

### 선택적 생성 (2개)
| # | 파일 경로 | 설명 |
|---|---------|------|
| 8 | `lib/presentation/screens/verse/widgets/verse_text.dart` | 성경 구절 표시 위젯 |
| 9 | `lib/presentation/screens/verse/widgets/question_card.dart` | 질문 카드 위젯 |

### 수정할 파일 (2개)
| # | 파일 경로 | 변경 내용 |
|---|---------|----------|
| 1 | `lib/presentation/screens/home/home_screen.dart` | 재구성 (WeeklyCalendar, DailyVerseCard 추가, 플레이스홀더 제거) |
| 2 | `lib/app/routes.dart` | Phase 2 라우트 활성화 |

---

## 구현 순서 (의존성 기반)

```
Step 1: daily_verse.dart (Entity)
  ↓
Step 2: daily_verse_model.dart (Model)
  ↓
Step 3: verse_state.dart + verse_provider.dart (Provider)
  ↓
Step 4-1: weekly_calendar.dart (위젯)
Step 4-3: daily_verse_card.dart (위젯)   ← 병렬 가능
  ↓
Step 4-4: home_screen.dart 수정 (통합)
  ↓
Step 5-1: verse_text.dart (위젯)
Step 5-2: question_card.dart (위젯)     ← 병렬 가능
  ↓
Step 5: daily_verse_screen.dart (상세 화면)
  ↓
Step 6: routes.dart 수정 (라우트 활성화)
  ↓
Step 7: flutter analyze + dart format
```

---

## 주의사항

### 반드시 지킬 것
1. **기존 코드 패턴 따르기**: `couple_model.dart`, `couple_provider.dart`의 패턴을 참고
2. **공통 위젯 재사용**: PrimaryButton, BaseCard, ElevatedCard, CustomAppBar, LoadingIndicator, SkeletonLoader 사용
3. **AppTheme 색상 사용**: 하드코딩 색상 금지, `AppTheme.primaryColor` 등 사용
4. **null safety**: `?`, `??` 사용, `!` 최소화
5. **한국어 주석**: 코드 주석은 한국어로
6. **Domain Layer 순수성**: `daily_verse.dart`에 Flutter/Supabase import 금지

### 하지 말 것
1. **Phase 3 기능 구현 금지**: 소감 작성(ResponseScreen), Dual Reveal은 Phase 3 범위
2. **Phase 4 기능 구현 금지**: 성령의 불 본격 구현은 Phase 4. 지금은 플레이스홀더만
3. **기존 커플 관련 코드 변경 금지**: CoupleStatusCard, CoupleProvider 등 건드리지 않기
4. **새로운 패키지 추가 금지**: pubspec.yaml에 이미 있는 패키지만 사용
5. **print() 사용 금지**: `logger.info()`, `logger.error()` 사용

### Edge Case 처리
- 커플 미연결 시: 오늘의 말씀 카드에 "파트너와 연결 후 이용 가능" 안내
- 플랜 미설정 시: "플랜 설정 후 말씀을 받아보세요" 안내 + 플랜 설정 버튼
- 말씀 데이터 없음: SkeletonLoader → 에러 메시지 + 새로고침 버튼
- 네트워크 오류: 사용자 친화적 에러 메시지 ("인터넷 연결을 확인해주세요")

---

## 완료 기준

- [ ] HomeScreen에 주간 캘린더 UI 표시됨
- [ ] HomeScreen에 성령의 불 플레이스홀더 표시됨
- [ ] HomeScreen에 오늘의 말씀 카드가 실제 데이터로 표시됨
- [ ] 오늘의 말씀 카드 클릭 시 DailyVerseScreen으로 이동
- [ ] DailyVerseScreen에서 성경 본문 + 질문 표시됨
- [ ] 로딩/에러/빈 상태가 모두 처리됨
- [ ] `flutter analyze` 경고 0개
- [ ] `dart format .` 적용 완료
- [ ] 기존 기능 (인증, 온보딩, 커플) 정상 동작 확인
---

## Codex Check Update (2026-04-07)

- [x] HomeScreen weekly calendar UI implemented
- [x] HomeScreen Holy Fire placeholder placement implemented
- [x] HomeScreen daily verse card connected to real provider data
- [x] Daily verse card navigation to `DailyVerseScreen` implemented
- [x] DailyVerseScreen verse text and question UI implemented
- [x] Loading, empty, and error states implemented in the current flow
- [ ] `flutter analyze` verified in this shell
- [ ] `dart format .` verified in this shell
- [ ] Existing auth/onboarding/couple flows regression-tested manually

Notes:
- `flutter` and `dart` executables were not available from the current shell.
- Based on this checklist, roadmap Task 2.4 implementation items are covered in code, while verification items remain pending.
