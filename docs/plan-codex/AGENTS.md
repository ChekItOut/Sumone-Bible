# Bible SumOne - Codex Agent 가이드

## 프로젝트 개요

Bible SumOne은 크리스천 커플을 위한 성경 나눔 Flutter 앱입니다.
Clean Architecture (Domain / Data / Presentation) + Feature-First 구조를 따릅니다.

---

## 필수 참조 문서 (작업 전 반드시 읽기)

| 문서 | 경로 | 내용 |
|------|------|------|
| 개발 가이드라인 | `CLAUDE.md` (프로젝트 루트) | 아키텍처, 코딩 스타일, 금지사항 등 모든 규칙 |
| PRD | `docs/prd.md` | 기능 명세, 와이어프레임, 데이터 모델 |
| 로드맵 | `docs/roadmap.md` | 구현 순서, Phase/Task 정의, 완료 상태 |
| 디자인 가이드라인 | `docs/design-guideline.md` | 색상, 타이포그래피, 공통 위젯 사용법 |

---

## 핵심 아키텍처 규칙

### 레이어 구조 (의존성 방향: 외부 → 내부만 허용)
```
Presentation (UI, Provider)
    ↓ 의존
Data (Model, Repository, DataSource)
    ↓ 의존
Domain (Entity, UseCase) ← 외부 라이브러리 import 금지
```

### 파일 위치 규칙
- UI 관련 → `lib/presentation/screens/{feature}/`
- 상태 관리 → `lib/presentation/providers/`
- 데이터 모델 → `lib/data/models/`
- API/DB 접근 → `lib/data/datasources/`
- 비즈니스 엔티티 → `lib/domain/entities/`
- 공통 위젯 → `lib/presentation/widgets/`

### 네이밍 규칙
- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- 변수/함수명: `camelCase`
- 주석/커밋: 한국어

### 코딩 규칙
- `final` 우선 사용 (불변성)
- `!` 연산자 최소화, null safety 준수
- `print()` 금지 → `logger` 사용 (`lib/core/utils/logger.dart`)
- 하드코딩 금지 → 상수는 `core/constants/`에 정의
- 함수 최대 50줄, 중첩 depth 3단계 이내
- Early return 패턴 사용

---

## 기술 스택

| 영역 | 기술 |
|------|------|
| Framework | Flutter 3.x |
| 상태관리 | Riverpod (StateNotifier + Provider) |
| 라우팅 | GoRouter |
| Backend | Supabase (Auth, DB, Realtime, Edge Functions) |
| HTTP | Dio |
| AI | Gemini API |
| 성경 데이터 | 로컬 JSON (`assets/data/bible.json`) |
| 테마 | Material Design 3, AppTheme 클래스 |

---

## 사용 가능한 공통 위젯 (재사용 필수)

| 위젯 | 경로 | 용도 |
|------|------|------|
| PrimaryButton | `lib/presentation/widgets/buttons/primary_button.dart` | 주요 액션 버튼 |
| SecondaryButton | `lib/presentation/widgets/buttons/secondary_button.dart` | 보조 버튼 |
| TextButtonCustom | `lib/presentation/widgets/buttons/text_button_custom.dart` | 텍스트 버튼 |
| BaseCard | `lib/presentation/widgets/cards/base_card.dart` | 기본 카드 |
| ElevatedCard | `lib/presentation/widgets/cards/elevated_card.dart` | 강조 카드 |
| TextFieldCustom | `lib/presentation/widgets/inputs/text_field_custom.dart` | 텍스트 입력 |
| TextAreaCustom | `lib/presentation/widgets/inputs/text_area_custom.dart` | 긴 텍스트 입력 |
| LoadingIndicator | `lib/presentation/widgets/loading/loading_indicator.dart` | 로딩 표시 |
| SkeletonLoader | `lib/presentation/widgets/loading/skeleton_loader.dart` | 스켈레톤 UI |
| ConfirmDialog | `lib/presentation/widgets/dialogs/confirm_dialog.dart` | 확인 대화상자 |
| ErrorDialog | `lib/presentation/widgets/dialogs/error_dialog.dart` | 에러 대화상자 |
| CustomAppBar | `lib/presentation/widgets/app_bar/custom_app_bar.dart` | 커스텀 앱바 |

---

## 테마 색상 (AppTheme)

```dart
// lib/app/theme.dart
primaryColor: Color(0xFF11BC78)      // 녹색/민트
secondaryColor: Color(0xFFFFC857)    // 노란색
accentColor: Color(0xFFFF6B9D)       // 핑크
backgroundColor: Color(0xFFF1F5F9)   // 연한 청회색
surfaceLight: Color(0xFFFFFFFF)      // 카드 배경
```

**카드 스타일**: borderRadius 24px, elevation 4
**버튼 스타일**: borderRadius 16px

---

## 커밋 메시지 규칙

```
prefix: 한국어 설명

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

prefix: `feat:`, `fix:`, `refactor:`, `docs:`, `style:`, `test:`, `chore:`

---

## 구현 계획 파일

각 Task별 구현 계획은 이 폴더의 `task-*.md` 파일을 참조하세요.
현재 계획:
- `task-2-4-ui-implementation.md` - Phase 2 Task 2.4: 일일 말씀 UI 구현
