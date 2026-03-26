# Bible SumOne - 페이지 구조 계획서 (Page Plan)

**버전**: 1.0
**작성일**: 2026-03-25
**목적**: 모든 화면(페이지)을 한눈에 파악하고 개발자가 즉시 구현할 수 있도록 상세 명세 제공

---

## 📋 목차

1. [문서 개요](#1-문서-개요)
2. [전체 페이지 목록](#2-전체-페이지-목록)
3. [페이지 플로우 다이어그램](#3-페이지-플로우-다이어그램)
4. [페이지별 상세 명세](#4-페이지별-상세-명세)
5. [라우팅 규칙](#5-라우팅-규칙)
6. [상태 관리 Provider 매핑](#6-상태-관리-provider-매핑)
7. [개발 우선순위 및 순서](#7-개발-우선순위-및-순서)
8. [추가 고려사항](#8-추가-고려사항)

---

## 1. 문서 개요

### 1.1 목적

이 문서는 Bible SumOne 앱의 모든 화면(페이지)을 체계적으로 관리하고, 개발자가 각 페이지를 즉시 구현할 수 있도록 다음을 제공합니다:

- **라우팅 정보**: 경로, 파라미터, 이동 조건
- **UI 구성**: 레이아웃, 위젯, 스타일
- **기능**: 사용자 액션, API 호출, 상태 변경
- **상태 관리**: 사용할 Provider
- **파일 위치**: 구현 파일 경로
- **참조**: prd.md, roadmap.md 섹션

### 1.2 참조 문서

- **docs/prd.md**: 기능 명세 (F-001 ~ F-014), UI/UX 가이드라인 (섹션 7)
- **docs/roadmap.md**: Phase별 개발 순서 (Phase 0-8)
- **lib/app/routes.dart**: 현재 라우팅 설정
- **lib/app/theme.dart**: 디자인 시스템 (색상, 폰트, 카드 스타일)

### 1.3 현재 구현 상태

- ✅ **구현 완료**: 3개 (Splash, Onboarding, ProfileSetup)
- ⏭️ **계획됨**: 12개 (Phase 1-6)
- 📊 **총 페이지**: 15개

---

## 2. 전체 페이지 목록

### 2.1 Phase별 분류

| Phase | 페이지 수 | 화면 목록 |
|-------|----------|----------|
| **Phase 0-1 (완료)** | 3 | Splash, Onboarding, ProfileSetup |
| **Phase 1.3 (커플 매칭)** | 2 | InvitePartner, ConnectCouple |
| **Phase 2 (일일 말씀)** | 2 | Home, DailyVerse |
| **Phase 3 (답변 & Dual Reveal)** | 3 | ResponseWrite, PartnerWaiting, DualReveal |
| **Phase 4 (스트릭)** | 1 | MilestoneDialog (Overlay) |
| **Phase 6 (부가 기능)** | 3 | History, Settings, ProfileEdit |
| **기타** | 1 | ErrorScreen |
| **합계** | **15** | |

### 2.2 우선순위별 분류

| 우선순위 | 설명 | 페이지 수 | 화면 목록 |
|---------|------|----------|----------|
| **P0 (필수 - MVP)** | 핵심 기능 | 10 | Splash, Onboarding, ProfileSetup, InvitePartner, ConnectCouple, Home, DailyVerse, ResponseWrite, PartnerWaiting, DualReveal |
| **P1 (중요 - 베타)** | 사용자 경험 개선 | 2 | MilestoneDialog, History |
| **P2 (추가 - 출시 후)** | 부가 기능 | 3 | Settings, ProfileEdit, ErrorScreen |

### 2.3 전체 페이지 목록 (알파벳순)

1. **ConnectCoupleScreen** (`/couple/connect`) - 커플 초대 수락
2. **DailyVerseScreen** (`/verse/daily`) - 오늘의 말씀 상세
3. **DualRevealScreen** (`/response/reveal/:verseId`) - 답변 동시 공개
4. **ErrorScreen** (라우트 에러 처리) - 404 에러 화면
5. **HistoryScreen** (`/history`) - 과거 대화 타임라인
6. **HomeScreen** (`/home`) - 홈 화면
7. **InvitePartnerScreen** (`/couple/invite`) - 파트너 초대 링크 생성
8. **MilestoneDialog** (Overlay) - 마일스톤 축하 팝업
9. **OnboardingScreen** (`/onboarding`) ✅ - 온보딩 3단계
10. **PartnerWaitingScreen** (`/response/waiting/:verseId`) - 파트너 대기 중
11. **ProfileEditScreen** (`/settings/profile`) - 프로필 수정
12. **ProfileSetupScreen** (`/profile-setup`) ✅ - 프로필 설정
13. **ResponseWriteScreen** (`/response/:verseId`) - 답변 작성
14. **SettingsScreen** (`/settings`) - 설정
15. **SplashScreen** (`/`) ✅ - 스플래시 (로딩)

---

## 3. 페이지 플로우 다이어그램

### 3.1 전체 플로우 (ASCII Diagram)

```
                    Splash (/)
                       ↓
         [첫 사용자?] → Onboarding (/onboarding)
                ↓                    ↓
         [로그인 완료]          ProfileSetup (/profile-setup)
                ↓                    ↓
         [커플 연결 완료?]    InvitePartner (/couple/invite)
                ↓                    ↓
            Home (/home)  ← ConnectCouple (/couple/connect)
                ↓
         DailyVerse (/verse/daily)
                ↓
         ResponseWrite (/response/:verseId)
                ↓
    [파트너 답변 완료?] → PartnerWaiting (/response/waiting/:verseId)
                ↓                    ↓
         DualReveal (/response/reveal/:verseId)
                ↓
         [마일스톤 달성?] → MilestoneDialog (Overlay)
                ↓
            Home (/home)
                ↓
    [설정] → Settings (/settings) → ProfileEdit (/settings/profile)
                ↓
    [과거 대화] → History (/history)
```

### 3.2 조건부 분기 요약

| 조건 | True 화면 | False 화면 |
|------|----------|-----------|
| 첫 사용자? | Onboarding | Home |
| 로그인 완료? | ProfileSetup | Onboarding |
| 커플 연결 완료? | Home | InvitePartner |
| 파트너 답변 완료? | DualReveal | PartnerWaiting |
| 마일스톤 달성? (7, 30, 100일) | MilestoneDialog → Home | Home |

---

## 4. 페이지별 상세 명세

### 4.1 SplashScreen ✅

**라우팅 정보**
- **Path**: `/`
- **Name**: `splash`
- **Parameters**: 없음
- **현재 상태**: ✅ 구현 완료

**UI 구성**
- **배경색**: `AppTheme.backgroundLight` (#78909C - slate blue)
- **로고**: 중앙 배치 (애니메이션)
- **로딩 인디케이터**: CircularProgressIndicator
- **폰트**: Pretendard Bold, 24px

**기능**
1. 앱 시작 시 자동 실행
2. Supabase 초기화
3. 로그인 상태 확인
4. 2초 후 자동 이동:
   - 로그인 완료 + 커플 연결 완료 → `/home`
   - 로그인 완료 + 커플 미연결 → `/couple/invite`
   - 미로그인 → `/onboarding`

**상태 관리**
- **Provider**: `authProvider` (인증 상태 확인)
- **Local State**: `_isLoading`, `_initializeApp()`

**이동 조건**
- 2초 후 자동 리다이렉트 (조건부)

**파일 위치**
- `lib/presentation/screens/splash/splash_screen.dart`

**참조**
- docs/roadmap.md: Task 1.2 (온보딩 플로우)
- docs/prd.md: F-014 (온보딩)

---

### 4.2 OnboardingScreen ✅

**라우팅 정보**
- **Path**: `/onboarding`
- **Name**: `onboarding`
- **Parameters**: 없음
- **현재 상태**: ✅ 구현 완료

**UI 구성**
- **배경색**: `AppTheme.backgroundLight` (#78909C)
- **카드**: PageView (3단계)
  - 카드 스타일: borderRadius 24px, elevation 4
  - 카드 배경: 흰색 (#FFFFFF)
- **버튼**: "다음", "시작하기" (Primary 버튼, borderRadius 16px)
- **인디케이터**: 페이지 인디케이터 (점 3개)

**기능**
1. 3단계 온보딩 슬라이드
   - Page 1: "두 사람의 신앙 여정을 함께 시작해요 ✨"
   - Page 2: "매일 짧은 말씀과 질문으로 서로를 더 깊이 알아가요"
   - Page 3: "파트너를 초대하고 첫 말씀을 나눠보세요"
2. PageView로 좌우 스와이프
3. 마지막 페이지에서 "시작하기" 버튼 → `/profile-setup`

**상태 관리**
- **Local State**: `PageController`, `_currentPage`

**이동 조건**
- "시작하기" 버튼 클릭 → `/profile-setup`

**파일 위치**
- `lib/presentation/screens/onboarding/onboarding_screen.dart`
- `lib/presentation/screens/onboarding/widgets/onboarding_page.dart`

**참조**
- docs/prd.md: F-014 (온보딩 3단계)
- docs/roadmap.md: Task 1.2

---

### 4.3 ProfileSetupScreen ✅

**라우팅 정보**
- **Path**: `/profile-setup`
- **Name**: `profile-setup`
- **Parameters**: 없음
- **현재 상태**: ✅ 구현 완료

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **카드**: 흰색 카드 (borderRadius 24px)
- **입력 필드**:
  - 이름 입력 (TextField)
  - 관계 단계 선택 (DropdownButton: "연애 중", "약혼", "신혼")
- **버튼**: "완료" (Primary 버튼)

**기능**
1. 이름 입력 (필수)
2. 관계 단계 선택 (필수)
3. 프로필 사진 업로드 (선택사항 - 추후 구현)
4. Supabase `users` 테이블에 프로필 저장
5. "완료" 버튼 → `/couple/invite`

**상태 관리**
- **Provider**: `authProvider` (프로필 저장)
- **Local State**: `_nameController`, `_relationshipStage`, `_isLoading`

**이동 조건**
- "완료" 버튼 클릭 + 유효성 검증 통과 → `/couple/invite`

**파일 위치**
- `lib/presentation/screens/onboarding/profile_setup_screen.dart`

**참조**
- docs/prd.md: F-002 (프로필 설정)
- docs/roadmap.md: Task 1.2

---

### 4.4 InvitePartnerScreen

**라우팅 정보**
- **Path**: `/couple/invite`
- **Name**: `invite-partner`
- **Parameters**: 없음

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **카드**: 중앙 카드
  - 제목: "파트너를 초대하세요"
  - 설명: "아래 링크를 공유하면 자동으로 연결됩니다"
- **링크 표시**: 복사 가능한 초대 링크 (Chip 위젯)
- **버튼**:
  - "링크 복사" (Secondary 버튼)
  - "공유하기" (Primary 버튼 - share_plus)
- **하단**: "나중에 하기" (텍스트 버튼)

**기능**
1. 앱 진입 시 Supabase `invite_links` 테이블에 초대 링크 생성
   - `token`: 유니크 토큰 (UUID)
   - `inviter_id`: 현재 사용자 ID
   - `expires_at`: 7일 후
2. 초대 링크 생성: `https://biblesumone.app/join?token=abc123`
3. "링크 복사" 버튼: 클립보드에 복사
4. "공유하기" 버튼: share_plus로 카카오톡, 문자 등 공유
5. "나중에 하기": `/home`으로 이동 (커플 미연결 상태)

**상태 관리**
- **Provider**: `coupleProvider` (초대 링크 생성, 상태 확인)
- **Local State**: `_inviteLink`, `_isGenerating`

**이동 조건**
- "나중에 하기" → `/home`
- 파트너가 초대 수락 시 (Realtime Subscription) → `/home`

**파일 위치**
- `lib/presentation/screens/couple/invite_partner_screen.dart`

**참조**
- docs/prd.md: F-003 (커플 매칭)
- docs/roadmap.md: Task 1.3

---

### 4.5 ConnectCoupleScreen

**라우팅 정보**
- **Path**: `/couple/connect?token=abc123`
- **Name**: `connect-couple`
- **Parameters**: `token` (초대 토큰, 필수)

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **카드**: 중앙 카드
  - 제목: "○○님이 초대했어요"
  - 설명: "함께 말씀을 나눠보세요"
- **프로필 표시**: 초대한 사람의 이름 및 프로필 사진
- **버튼**:
  - "수락하고 시작하기" (Primary 버튼)
  - "취소" (Secondary 버튼)

**기능**
1. URL 쿼리 파라미터에서 `token` 추출
2. Supabase `invite_links` 테이블에서 토큰 검증
   - 유효하지 않은 토큰 → ErrorScreen
   - 만료된 토큰 → ErrorScreen
   - 이미 사용된 토큰 → ErrorScreen
3. 초대한 사람의 프로필 조회 (이름, 사진)
4. "수락하고 시작하기" 버튼 클릭:
   - Supabase `couples` 테이블에 커플 생성
     - `user1_id`: 초대한 사람
     - `user2_id`: 현재 사용자
   - `invite_links` 테이블의 `is_used = true`
   - `/home`으로 이동

**상태 관리**
- **Provider**: `coupleProvider` (커플 연결)
- **Local State**: `_token`, `_inviterProfile`, `_isLoading`

**이동 조건**
- "수락하고 시작하기" → `/home`
- "취소" → `/onboarding`

**파일 위치**
- `lib/presentation/screens/couple/connect_couple_screen.dart`

**참조**
- docs/prd.md: F-003 (커플 매칭)
- docs/roadmap.md: Task 1.3

---

### 4.6 HomeScreen

**라우팅 정보**
- **Path**: `/home`
- **Name**: `home`
- **Parameters**: 없음

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "Bible SumOne"
  - 우측: 설정 아이콘 버튼
- **스트릭 위젯** (상단):
  - 🔥 아이콘 + "7일째 함께 읽고 있어요!"
  - 카드 스타일, borderRadius 24px
- **성령의 불 캐릭터** (스트릭 위젯 근처):
  - 크기: 80-120px
  - 투명 배경 (PNG 이미지)
  - 레벨에 따라 동적 변화 (Level 1/2/3 이미지 교체)
  - Flutter 애니메이션:
    - Float: 위아래 둥실둥실
    - Pulse: 크기 맥동
    - Glow: 테두리 빛남 (진한 주황색)
  - 위치: Stack으로 스트릭 위젯 우측 상단 또는 중앙
- **오늘의 말씀 카드** (중앙):
  - 큰 카드 (borderRadius 24px, elevation 4)
  - 성경 구절 요약: "고린도전서 13:4-7"
  - "사랑은 오래 참고..." (첫 구절 미리보기)
  - "읽으러 가기" 버튼 (Primary)
- **하단 메뉴**:
  - "과거 대화 보기" (텍스트 버튼)
  - "설정" (텍스트 버튼)

**기능**
1. 현재 스트릭 정보 조회 (Supabase `streaks` 테이블)
   - `current_streak`, `holy_fire_level` 조회
2. 성령의 불 레벨 계산 및 표시
   - `calculateFireLevel(currentStreak)` 로직 적용
   - 해당 레벨의 PNG 이미지 로드 (level1.png, level2.png, level3.png)
   - AnimationController로 Float, Pulse, Glow 애니메이션 실행
3. 오늘의 말씀 조회 (Supabase `daily_verses` 테이블)
   - 오늘 날짜 기준 (`date = CURRENT_DATE`)
4. "읽으러 가기" 버튼 → `/verse/daily`
5. "과거 대화 보기" → `/history`
6. 설정 아이콘 → `/settings`

**상태 관리**
- **Provider**:
  - `streakProvider` (스트릭 정보)
  - `verseProvider` (오늘의 말씀)
  - `authProvider` (사용자 정보)
- **Local State**: 없음 (Provider만 사용)

**이동 조건**
- "읽으러 가기" → `/verse/daily`
- "과거 대화 보기" → `/history`
- 설정 아이콘 → `/settings`

**파일 위치**
- `lib/presentation/screens/home/home_screen.dart`
- `lib/presentation/screens/home/widgets/daily_verse_card.dart`
- `lib/presentation/screens/home/widgets/streak_widget.dart`
- `lib/presentation/screens/home/widgets/holy_fire_widget.dart` (NEW)

**참조**
- docs/prd.md: 섹션 7.4 (홈 화면 와이어프레임)
- docs/roadmap.md: Task 2.4

---

### 4.7 DailyVerseScreen

**라우팅 정보**
- **Path**: `/verse/daily`
- **Name**: `daily-verse`
- **Parameters**: 없음

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "오늘의 말씀"
  - 좌측: 뒤로가기 버튼
- **성경 구절 카드** (상단):
  - 흰색 카드, borderRadius 24px
  - 제목: "고린도전서 13:4-7"
  - 본문: Noto Serif KR, 18px, 줄 간격 1.8
  - 전체 성경 구절 표시
- **질문 카드** (중앙):
  - 제목: "💬 오늘의 질문"
  - AI 생성 질문 표시
  - 폰트: Pretendard, 16px
- **버튼** (하단):
  - "답변 작성하기" (Primary 버튼, 고정 하단)

**기능**
1. 오늘의 말씀 조회 (Supabase `daily_verses`)
2. 성경 구절 전체 표시
3. AI 생성 질문 표시
4. "답변 작성하기" 버튼 → `/response/:verseId`

**상태 관리**
- **Provider**: `verseProvider` (오늘의 말씀)
- **Local State**: 없음

**이동 조건**
- "답변 작성하기" → `/response/:verseId`

**파일 위치**
- `lib/presentation/screens/verse/daily_verse_screen.dart`
- `lib/presentation/screens/verse/widgets/verse_text.dart`
- `lib/presentation/screens/verse/widgets/question_card.dart`

**참조**
- docs/prd.md: F-004 (일일 말씀), 섹션 7.4 (답변 작성 화면 와이어프레임)
- docs/roadmap.md: Task 2.4

---

### 4.8 ResponseWriteScreen

**라우팅 정보**
- **Path**: `/response/:verseId`
- **Name**: `response-write`
- **Parameters**: `verseId` (오늘의 말씀 ID, 필수)

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "오늘의 말씀"
  - 좌측: 뒤로가기 버튼
- **성경 구절** (상단, 스크롤 가능):
  - 축약 표시 (예: "고린도전서 13:4-7")
  - 클릭 시 전체 보기 (다이얼로그 또는 확장)
- **질문 카드** (중앙):
  - "💬 오늘의 질문"
  - 질문 내용
- **답변 입력** (하단):
  - TextField (멀티라인, 3-5줄 높이)
  - 글자 수 카운터: "150 / 500자" (우측 하단)
  - 힌트 텍스트: "이 말씀을 읽고 떠오르는 생각을 써보세요"
- **버튼** (하단 고정):
  - "제출하기" (Primary 버튼)

**기능**
1. URL 파라미터에서 `verseId` 추출
2. 성경 구절 및 질문 조회 (Supabase `daily_verses`)
3. 텍스트 입력 (최대 500자)
4. 임시 저장 기능:
   - 페이지 나갈 때 자동 저장 (Supabase `responses`, `is_submitted = false`)
   - 다시 진입 시 불러오기
5. "제출하기" 버튼:
   - 유효성 검증 (1자 이상)
   - Supabase `responses` 테이블 INSERT/UPDATE
     - `verse_id`, `user_id`, `couple_id`, `content`
     - `is_submitted = true`
   - Supabase `daily_progress` 테이블 업데이트
     - `user1_submitted` 또는 `user2_submitted = true`
   - 파트너 답변 확인:
     - 파트너 미완료 → `/response/waiting/:verseId`
     - 둘 다 완료 → `/response/reveal/:verseId`

**상태 관리**
- **Provider**: `responseProvider` (답변 작성, 조회)
- **Local State**: `_responseController`, `_charCount`, `_isSubmitting`

**이동 조건**
- "제출하기" + 파트너 미완료 → `/response/waiting/:verseId`
- "제출하기" + 둘 다 완료 → `/response/reveal/:verseId`

**파일 위치**
- `lib/presentation/screens/response/response_write_screen.dart`
- `lib/presentation/screens/response/widgets/response_input.dart`

**참조**
- docs/prd.md: F-007 (답변 작성), 섹션 7.4 (답변 작성 화면 와이어프레임)
- docs/roadmap.md: Task 3.1

---

### 4.9 PartnerWaitingScreen

**라우팅 정보**
- **Path**: `/response/waiting/:verseId`
- **Name**: `partner-waiting`
- **Parameters**: `verseId` (말씀 ID, 필수)

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "오늘의 말씀"
  - 좌측: 뒤로가기 → `/home`
- **카드 뒷면 이미지** (중앙):
  - 카드 뒤집힌 이미지 (또는 Lottie 애니메이션)
  - borderRadius 24px, elevation 4
- **메시지**:
  - "○○님이 답변을 기다리고 있어요 💬"
  - 폰트: Pretendard, 16px
- **하단 버튼**:
  - "홈으로 돌아가기" (Secondary 버튼)

**기능**
1. URL 파라미터에서 `verseId` 추출
2. 파트너 이름 조회 (Supabase `users`)
3. Supabase Realtime Subscription 설정:
   - `daily_progress` 테이블 변경 감지
   - `both_completed_at`이 업데이트되면 → `/response/reveal/:verseId`
4. "홈으로 돌아가기" → `/home`

**상태 관리**
- **Provider**: `responseProvider` (Realtime 구독)
- **Local State**: `_partnerName`, `_isListening`

**이동 조건**
- 파트너 답변 완료 (Realtime) → `/response/reveal/:verseId`
- "홈으로 돌아가기" → `/home`

**파일 위치**
- `lib/presentation/screens/response/partner_waiting_screen.dart`

**참조**
- docs/prd.md: F-008 (Dual Reveal), 섹션 7.4 (대기 화면 와이어프레임)
- docs/roadmap.md: Task 3.2

---

### 4.10 DualRevealScreen

**라우팅 정보**
- **Path**: `/response/reveal/:verseId`
- **Name**: `dual-reveal`
- **Parameters**: `verseId` (말씀 ID, 필수)

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "오늘의 답변"
  - 좌측: 뒤로가기 → `/home`
- **카드 뒤집기 애니메이션** (진입 시):
  - 3초 애니메이션 (FlipAnimation)
  - 카드 뒷면 → 앞면
- **내 답변 카드** (상단):
  - 제목: "💬 나의 답변"
  - 내용: 내 답변 텍스트
  - 하단: ♥ 좋아요 (추후 구현)
- **파트너 답변 카드** (하단):
  - 제목: "💬 ○○님의 답변"
  - 내용: 파트너 답변 텍스트
  - 하단: ♥ 좋아요 (추후 구현)
- **버튼** (하단):
  - "홈으로 돌아가기" (Primary 버튼)

**기능**
1. URL 파라미터에서 `verseId` 추출
2. 내 답변 조회 (Supabase `responses`)
3. 파트너 답변 조회 (Supabase `responses`)
4. 카드 뒤집기 애니메이션 자동 실행 (3초)
5. 좋아요 기능 (추후 구현, P1)
6. "홈으로 돌아가기" → `/home`
   - 마일스톤 확인 후 MilestoneDialog 표시 (조건부)

**상태 관리**
- **Provider**: `responseProvider` (답변 조회)
- **Local State**: `_myResponse`, `_partnerResponse`, `_animationController`

**이동 조건**
- "홈으로 돌아가기" → `/home` (마일스톤 확인)
- 마일스톤 달성 → MilestoneDialog 표시 → `/home`

**파일 위치**
- `lib/presentation/screens/response/dual_reveal_screen.dart`
- `lib/presentation/screens/response/widgets/my_response_card.dart`
- `lib/presentation/screens/response/widgets/partner_response_card.dart`
- `lib/presentation/screens/response/widgets/flip_animation.dart`

**참조**
- docs/prd.md: F-008 (Dual Reveal), F-009 (좋아요), 섹션 7.4 (Dual Reveal 화면 와이어프레임)
- docs/roadmap.md: Task 3.2

---

### 4.11 MilestoneDialog

**라우팅 정보**
- **Path**: 없음 (Overlay, 라우트 아님)
- **Name**: `milestone-dialog`
- **Parameters**: `streak` (달성한 스트릭 일수, 필수)

**UI 구성**
- **배경**: 반투명 검은색 (Overlay)
- **카드**: 중앙 다이얼로그
  - borderRadius 24px, elevation 8
  - 배경색: 흰색
- **컨페티 애니메이션**: 화면 가득 (confetti 패키지)
- **제목**:
  - 7일: "일주일 함께 읽었어요! 🎉"
  - 30일: "한 달 축하해요! 💕"
  - 100일: "100일! 놀라운 습관이에요! 🏆"
  - 365일: "1년! 함께한 여정을 축하해요! 🎊"
- **이미지**: 마일스톤 이미지 (Lottie 또는 PNG)
- **버튼**:
  - "공유하기" (Secondary 버튼, share_plus)
  - "닫기" (Primary 버튼)

**기능**
1. 마일스톤 달성 시 자동 표시 (7, 30, 100, 365일)
2. 컨페티 애니메이션 3초
3. "공유하기" 버튼:
   - 스크린샷 캡처 (선택사항)
   - share_plus로 인스타 스토리, 카톡 공유
4. "닫기" 버튼 → 다이얼로그 닫기 → `/home`

**상태 관리**
- **Provider**: `streakProvider` (마일스톤 감지)
- **Local State**: `_confettiController`, `_milestone`

**이동 조건**
- "닫기" 버튼 → 다이얼로그 닫기

**파일 위치**
- `lib/presentation/screens/home/widgets/milestone_dialog.dart`

**참조**
- docs/prd.md: F-011 (마일스톤 축하)
- docs/roadmap.md: Task 4.2

---

### 4.12 HistoryScreen

**라우팅 정보**
- **Path**: `/history`
- **Name**: `history`
- **Parameters**: 없음

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "과거 대화"
  - 좌측: 뒤로가기 → `/home`
- **리스트**: 날짜별 정렬 (최신순)
  - 각 항목: 카드 스타일
    - 날짜: "2026-03-25 (오늘)"
    - 성경 구절: "고린도전서 13:4-7"
    - 답변 미리보기: "서로에게 더 인내심을..." (첫 50자)
    - 우측 화살표 아이콘
- **무료/프리미엄 구분**:
  - 무료: 최근 7일만 표시
  - 프리미엄: 전체 기간 (추후 구현)

**기능**
1. 과거 답변 조회 (Supabase `responses`)
   - 최근 7일 (무료)
   - `created_at DESC` 정렬
2. 항목 클릭 → `/response/reveal/:verseId` (과거 답변 보기)

**상태 관리**
- **Provider**: `responseProvider` (과거 답변 조회)
- **Local State**: `_historyList`, `_isLoading`

**이동 조건**
- 항목 클릭 → `/response/reveal/:verseId`
- 뒤로가기 → `/home`

**파일 위치**
- `lib/presentation/screens/history/history_screen.dart`
- `lib/presentation/screens/history/widgets/history_item.dart`

**참조**
- docs/prd.md: F-012 (타임라인 뷰)
- docs/roadmap.md: Task 6.1

---

### 4.13 SettingsScreen

**라우팅 정보**
- **Path**: `/settings`
- **Name**: `settings`
- **Parameters**: 없음

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "설정"
  - 좌측: 뒤로가기 → `/home`
- **설정 항목** (리스트):
  - 프로필 수정 (→ `/settings/profile`)
  - 알림 설정 (Switch)
  - 알림 시간 (TimePicker)
  - 성경 번역본 (DropdownButton: "개역개정", "개역한글", "NIV")
  - 테마 (DropdownButton: "라이트", "다크")
  - 로그아웃 (텍스트 버튼)
  - 회원 탈퇴 (텍스트 버튼, 빨간색)

**기능**
1. 프로필 수정 → `/settings/profile`
2. 알림 ON/OFF 토글 (Supabase `users.notification_enabled`)
3. 알림 시간 선택 (TimePicker, Supabase `users.notification_time`)
4. 성경 번역본 선택 (Supabase `users.bible_translation`)
5. 테마 선택 (Supabase `users.theme`)
6. 로그아웃:
   - Supabase Auth 로그아웃
   - `/onboarding`으로 이동
7. 회원 탈퇴:
   - 확인 다이얼로그
   - Supabase Auth 계정 삭제
   - `/onboarding`으로 이동

**상태 관리**
- **Provider**: `authProvider` (사용자 설정, 로그아웃)
- **Local State**: `_notificationEnabled`, `_notificationTime`, `_theme`

**이동 조건**
- "프로필 수정" → `/settings/profile`
- "로그아웃" → `/onboarding`
- "회원 탈퇴" → `/onboarding`
- 뒤로가기 → `/home`

**파일 위치**
- `lib/presentation/screens/settings/settings_screen.dart`
- `lib/presentation/screens/settings/widgets/settings_item.dart`

**참조**
- docs/prd.md: F-013 (설정)
- docs/roadmap.md: Task 6.2

---

### 4.14 ProfileEditScreen

**라우팅 정보**
- **Path**: `/settings/profile`
- **Name**: `profile-edit`
- **Parameters**: 없음

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **AppBar**:
  - 제목: "프로필 수정"
  - 좌측: 뒤로가기 → `/settings`
- **프로필 사진** (상단):
  - 원형 이미지 (120px)
  - 하단 우측: 카메라 아이콘 버튼 (사진 변경)
- **입력 필드**:
  - 이름 (TextField)
  - 관계 단계 (DropdownButton)
- **버튼**:
  - "저장" (Primary 버튼, 하단 고정)

**기능**
1. 현재 프로필 조회 (Supabase `users`)
2. 프로필 사진 변경:
   - image_picker로 갤러리/카메라 선택
   - Supabase Storage에 업로드
   - `users.profile_image_url` 업데이트
3. 이름 수정
4. 관계 단계 수정
5. "저장" 버튼:
   - 유효성 검증
   - Supabase `users` 테이블 UPDATE
   - `/settings`로 돌아가기

**상태 관리**
- **Provider**: `authProvider` (프로필 업데이트)
- **Local State**: `_nameController`, `_relationshipStage`, `_profileImage`, `_isUploading`

**이동 조건**
- "저장" 버튼 → `/settings`
- 뒤로가기 → `/settings`

**파일 위치**
- `lib/presentation/screens/settings/profile_edit_screen.dart`

**참조**
- docs/prd.md: F-013 (설정)
- docs/roadmap.md: Task 6.2

---

### 4.15 ErrorScreen

**라우팅 정보**
- **Path**: 없음 (GoRouter errorBuilder)
- **Name**: `error`
- **Parameters**: `error` (에러 메시지, GoRouter 자동 전달)

**UI 구성**
- **배경색**: `AppTheme.backgroundLight`
- **중앙 컨텐츠**:
  - 에러 아이콘: ⚠️ (64px)
  - 제목: "페이지를 찾을 수 없습니다"
  - 설명: 에러 메시지 또는 URL 표시
  - 버튼: "홈으로 돌아가기" (Primary 버튼)

**기능**
1. GoRouter에서 자동 호출 (라우트 에러 발생 시)
2. 에러 메시지 표시
3. "홈으로 돌아가기" → `/home` (로그인 완료) 또는 `/onboarding` (미로그인)

**상태 관리**
- **Local State**: `_errorMessage`

**이동 조건**
- "홈으로 돌아가기" → `/home` 또는 `/onboarding`

**파일 위치**
- `lib/app/routes.dart` (errorBuilder 내부)

**참조**
- docs/roadmap.md: 섹션 1.1 (라우팅 설정)

---

## 5. 라우팅 규칙

### 5.1 GoRouter 설정 방법

#### 기본 라우트

```dart
GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) => const HomeScreen(),
),
```

#### 파라미터 있는 라우트

```dart
GoRoute(
  path: '/response/:verseId',
  name: 'response-write',
  builder: (context, state) {
    final verseId = state.pathParameters['verseId']!;
    return ResponseWriteScreen(verseId: verseId);
  },
),
```

#### 쿼리 파라미터 라우트

```dart
GoRoute(
  path: '/couple/connect',
  name: 'connect-couple',
  builder: (context, state) {
    final token = state.uri.queryParameters['token'] ?? '';
    return ConnectCoupleScreen(token: token);
  },
),
```

#### 중첩 라우트 (Nested Routes)

```dart
GoRoute(
  path: '/settings',
  name: 'settings',
  builder: (context, state) => const SettingsScreen(),
  routes: [
    GoRoute(
      path: 'profile', // /settings/profile
      name: 'profile-edit',
      builder: (context, state) => const ProfileEditScreen(),
    ),
  ],
),
```

### 5.2 Deep Link 처리

#### 커플 초대 링크

```
https://biblesumone.app/couple/connect?token=abc123

→ /couple/connect?token=abc123
→ ConnectCoupleScreen(token: 'abc123')
```

#### 특정 말씀 바로가기 (추후 구현)

```
https://biblesumone.app/verse/2026-03-25

→ /verse/2026-03-25
→ DailyVerseScreen(date: '2026-03-25')
```

### 5.3 권한 체크 (Redirect)

**로그인 체크**:

```dart
redirect: (context, state) {
  final authState = ref.read(authProvider);
  final isAuthenticated = authState.user != null;
  final isOnAuthPage = state.matchedLocation.startsWith('/onboarding') ||
                       state.matchedLocation.startsWith('/profile-setup');

  // 미로그인 + 인증 페이지 아님 → 온보딩으로
  if (!isAuthenticated && !isOnAuthPage) {
    return '/onboarding';
  }

  // 로그인 완료 + 인증 페이지 → 홈으로
  if (isAuthenticated && isOnAuthPage) {
    return '/home';
  }

  return null; // 정상 진행
},
```

**커플 연결 체크**:

```dart
redirect: (context, state) {
  final coupleState = ref.read(coupleProvider);
  final isConnected = coupleState.couple != null;
  final requiresCouple = ['/home', '/verse/daily', '/response/'].any(
    (path) => state.matchedLocation.startsWith(path),
  );

  // 커플 미연결 + 커플 필요 페이지 → 초대 화면으로
  if (!isConnected && requiresCouple) {
    return '/couple/invite';
  }

  return null;
},
```

### 5.4 화면 이동 메서드

#### 일반 이동 (push)

```dart
context.push('/verse/daily');
```

#### 이름으로 이동 (pushNamed)

```dart
context.pushNamed('daily-verse');
```

#### 파라미터와 함께 이동

```dart
context.push('/response/$verseId');
// 또는
context.pushNamed(
  'response-write',
  pathParameters: {'verseId': verseId},
);
```

#### 교체 이동 (go)

```dart
context.go('/home'); // 뒤로가기 불가
```

#### 뒤로가기 (pop)

```dart
context.pop();
```

---

## 6. 상태 관리 Provider 매핑

| Provider | 관리 상태 | 사용 페이지 |
|----------|----------|----------|
| **authProvider** | 인증 상태, 프로필 정보 | Splash, Onboarding, ProfileSetup, Settings, ProfileEdit |
| **coupleProvider** | 커플 정보, 초대 링크 | Splash, InvitePartner, ConnectCouple, Home |
| **verseProvider** | 오늘의 말씀, 성경 구절 | Home, DailyVerse, ResponseWrite |
| **responseProvider** | 답변 작성/조회, Dual Reveal | ResponseWrite, PartnerWaiting, DualReveal, History |
| **streakProvider** | 스트릭 정보, 마일스톤 | Home, MilestoneDialog |
| **settingsProvider** | 알림 설정, 테마 | Settings |

### 6.1 Provider 예시

#### authProvider

```dart
// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});
}

class AuthProvider extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthProvider(this._repository) : super(AuthState());

  Future<void> signIn() async { /* ... */ }
  Future<void> signOut() async { /* ... */ }
  Future<void> updateProfile(String name, String stage) async { /* ... */ }
}

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthProvider(repository);
});
```

#### verseProvider

```dart
// lib/presentation/providers/verse_provider.dart
class VerseState {
  final DailyVerse? todayVerse;
  final bool isLoading;
  final String? error;

  VerseState({this.todayVerse, this.isLoading = false, this.error});
}

class VerseProvider extends StateNotifier<VerseState> {
  final VerseRepository _repository;

  VerseProvider(this._repository) : super(VerseState());

  Future<void> getTodayVerse() async { /* ... */ }
}

final verseProvider = StateNotifierProvider<VerseProvider, VerseState>((ref) {
  final repository = ref.read(verseRepositoryProvider);
  return VerseProvider(repository);
});
```

---

## 7. 개발 우선순위 및 순서

### 7.1 Phase별 구현 순서

#### Phase 1: 커플 매칭 (Week 2)
- [ ] **InvitePartnerScreen** (`/couple/invite`)
- [ ] **ConnectCoupleScreen** (`/couple/connect?token=`)

#### Phase 2: 일일 말씀 (Week 3-4)
- [ ] **HomeScreen** (`/home`)
- [ ] **DailyVerseScreen** (`/verse/daily`)

#### Phase 3: 답변 & Dual Reveal (Week 5-6)
- [ ] **ResponseWriteScreen** (`/response/:verseId`)
- [ ] **PartnerWaitingScreen** (`/response/waiting/:verseId`)
- [ ] **DualRevealScreen** (`/response/reveal/:verseId`)

#### Phase 4: 스트릭 (Week 7)
- [ ] **MilestoneDialog** (Overlay)

#### Phase 6: 부가 기능 (Week 9)
- [ ] **HistoryScreen** (`/history`)
- [ ] **SettingsScreen** (`/settings`)
- [ ] **ProfileEditScreen** (`/settings/profile`)

### 7.2 각 화면 구현 시 UI/UX Agent 활용

**UI/UX Agent 호출 예시**:

```
"InvitePartnerScreen UI를 구현해줘.

요구사항:
- 파일: lib/presentation/screens/couple/invite_partner_screen.dart
- 배경: AppTheme.backgroundLight (#78909C)
- 카드: 흰색 카드 (borderRadius 24px, elevation 4)
- 초대 링크 표시 (Chip 위젯)
- 버튼 2개: '링크 복사', '공유하기'
- 하단: '나중에 하기' 텍스트 버튼

참조:
- docs/prd.md: F-003 (커플 매칭)
- docs/page-plan.md: 섹션 4.4

Provider:
- coupleProvider (초대 링크 생성)

테마:
- lib/app/theme.dart 사용
"
```

---

## 8. 추가 고려사항

### 8.1 에러 처리

**네트워크 에러**:
- API 호출 실패 시 SnackBar로 사용자 친화적 메시지 표시
- 예: "인터넷 연결을 확인해주세요."

**데이터 없음**:
- 빈 상태 화면 (Empty State)
  - 예: "아직 과거 대화가 없어요. 첫 말씀을 나눠보세요!"

**권한 에러**:
- 알림 권한 거부 시: "알림을 받으려면 설정에서 권한을 허용해주세요"

### 8.2 로딩 상태

**스켈레톤 로더**:
- `shimmer` 패키지 사용
- 카드 형태의 스켈레톤 표시

**CircularProgressIndicator**:
- 버튼 클릭 시 로딩 중: 버튼 내부에 작은 스피너
- 전체 화면 로딩: 중앙에 스피너

### 8.3 오프라인 지원

**로컬 성경 데이터**:
- `assets/data/bible.json` 사용
- 인터넷 연결 없이도 성경 구절 조회 가능

**답변 임시 저장**:
- 로컬에 임시 저장 (SharedPreferences 또는 Hive)
- 인터넷 연결 복구 시 자동 동기화

### 8.4 접근성 (Accessibility)

**폰트 크기 조절**:
- 시스템 폰트 크기 설정 반영
- 설정에서 성경 구절 폰트 크기 조절 (추후 구현)

**색맹 모드**:
- 고대비 테마 제공 (추후 구현)

**Screen Reader**:
- Semantics 위젯 사용 (추후 구현)

### 8.5 성능 최적화

**이미지 캐싱**:
- `cached_network_image` 패키지 사용
- 프로필 사진, 마일스톤 이미지 캐싱

**리스트 최적화**:
- `ListView.builder` 사용 (무한 스크롤)
- 과거 대화 리스트: Pagination

**메모리 관리**:
- Provider dispose 시 Subscription 해제
- 이미지 리소스 정리

---

## 9. Quick Reference

### 9.1 페이지별 파일 경로 요약

| 페이지 | 파일 경로 |
|--------|----------|
| SplashScreen | `lib/presentation/screens/splash/splash_screen.dart` |
| OnboardingScreen | `lib/presentation/screens/onboarding/onboarding_screen.dart` |
| ProfileSetupScreen | `lib/presentation/screens/onboarding/profile_setup_screen.dart` |
| InvitePartnerScreen | `lib/presentation/screens/couple/invite_partner_screen.dart` |
| ConnectCoupleScreen | `lib/presentation/screens/couple/connect_couple_screen.dart` |
| HomeScreen | `lib/presentation/screens/home/home_screen.dart` |
| DailyVerseScreen | `lib/presentation/screens/verse/daily_verse_screen.dart` |
| ResponseWriteScreen | `lib/presentation/screens/response/response_write_screen.dart` |
| PartnerWaitingScreen | `lib/presentation/screens/response/partner_waiting_screen.dart` |
| DualRevealScreen | `lib/presentation/screens/response/dual_reveal_screen.dart` |
| MilestoneDialog | `lib/presentation/screens/home/widgets/milestone_dialog.dart` |
| HistoryScreen | `lib/presentation/screens/history/history_screen.dart` |
| SettingsScreen | `lib/presentation/screens/settings/settings_screen.dart` |
| ProfileEditScreen | `lib/presentation/screens/settings/profile_edit_screen.dart` |
| ErrorScreen | `lib/app/routes.dart` (errorBuilder) |

### 9.2 라우트 요약

| 페이지 | Path | Name |
|--------|------|------|
| SplashScreen | `/` | `splash` |
| OnboardingScreen | `/onboarding` | `onboarding` |
| ProfileSetupScreen | `/profile-setup` | `profile-setup` |
| InvitePartnerScreen | `/couple/invite` | `invite-partner` |
| ConnectCoupleScreen | `/couple/connect?token=` | `connect-couple` |
| HomeScreen | `/home` | `home` |
| DailyVerseScreen | `/verse/daily` | `daily-verse` |
| ResponseWriteScreen | `/response/:verseId` | `response-write` |
| PartnerWaitingScreen | `/response/waiting/:verseId` | `partner-waiting` |
| DualRevealScreen | `/response/reveal/:verseId` | `dual-reveal` |
| MilestoneDialog | N/A (Overlay) | `milestone-dialog` |
| HistoryScreen | `/history` | `history` |
| SettingsScreen | `/settings` | `settings` |
| ProfileEditScreen | `/settings/profile` | `profile-edit` |
| ErrorScreen | N/A (errorBuilder) | `error` |

---

## 10. 마무리

### 10.1 문서 사용 방법

1. **화면 구현 전**: 해당 페이지 섹션 읽기 (라우팅, UI, 기능, Provider)
2. **UI 구현 시**: theme.dart 참조하여 일관된 스타일 적용
3. **라우팅 추가 시**: routes.dart에 GoRoute 추가
4. **상태 관리 시**: Provider 매핑 참조

### 10.2 문서 업데이트

이 문서는 **살아있는 문서**입니다:
- ✅ 새로운 페이지 추가 시 섹션 4에 추가
- ✅ 라우팅 변경 시 섹션 5 업데이트
- ✅ Provider 추가 시 섹션 6 업데이트
- ✅ prd.md, roadmap.md 변경 시 동기화

### 10.3 다음 단계

1. **Phase 1.3 시작**: InvitePartnerScreen, ConnectCoupleScreen 구현
2. **UI/UX Agent 활용**: 각 화면 구현 시 에이전트 호출
3. **테스트**: 각 화면 구현 후 실제 기기에서 테스트
4. **문서 동기화**: 구현 완료 후 이 문서 업데이트

---

**문서 버전**: v1.0
**최종 업데이트**: 2026-03-25
**작성자**: Development Team

**Let's Build! 🚀✝️**

---

**참조 문서**:
- docs/prd.md (Product Requirements Document)
- docs/roadmap.md (Flutter 개발 로드맵)
- lib/app/routes.dart (현재 라우팅 설정)
- lib/app/theme.dart (디자인 시스템)
