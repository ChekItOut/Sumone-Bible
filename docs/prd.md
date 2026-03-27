# Bible SumOne - Product Requirements Document (PRD)

**버전**: 1.0
**작성일**: 2026-03-24
**작성자**: Product Team
**상태**: Draft

---

## 📋 문서 개요

### 목적
Bible SumOne MVP의 상세한 제품 요구사항을 정의하고, 개발팀이 구현할 수 있도록 명확한 가이드를 제공합니다.

### 범위
이 PRD는 **MVP (Minimum Viable Product)** 범위를 다룹니다.
- **포함**: 핵심 기능 (일일 말씀, Dual Reveal, 스트릭, AI 큐레이션)
- **제외**: 프리미엄 기능 (AI 인사이트, 주제별 컬렉션 - 추후 버전)

---

## 1. 제품 개요 (Product Overview)

### 1.1 제품 비전
> "모든 크리스천 커플이 말씀 안에서 함께 성장하는 세상"

### 1.2 제품 설명
Bible SumOne은 크리스천 커플을 위한 성경 나눔 앱입니다. 매일 짧은 성경 구절과 대화 질문을 제공하여, 커플이 재미있고 부담 없이 말씀을 함께 읽고 나눌 수 있도록 돕습니다.

### 1.3 핵심 가치 제안
- **Together, but Async**: 각자의 시간에 읽되 함께하는 경험
- **Bite-sized**: 3-5분으로 지속 가능한 습관
- **재미 + 깊이**: SumOne의 UX + 성경의 의미

### 1.4 타겟 사용자
- **주 타겟**: 20-30대 크리스천 연애 커플
- **부 타겟**: 약혼 커플, 신혼 커플

---

## 2. 목표 및 성공 지표

### 2.1 비즈니스 목표
1. **시장 검증**: 크리스천 커플 성경 앱 수요 확인
2. **습관 형성**: 7일 리텐션 60% 달성
3. **PMF 달성**: NPS 50+ 달성

### 2.2 MVP 성공 지표

| 지표 | 목표 (3개월) | 측정 방법 |
|------|-------------|----------|
| 가입 커플 수 | 500 커플 | Supabase Auth |
| 7일 리텐션 | 60% | 첫 주 3회 이상 사용 |
| 30일 리텐션 | 40% | 한 달 후에도 활성 |
| 답변 완료율 | 80% | 두 사람 모두 답변 |
| NPS | 50+ | 인앱 설문 |

---

## 3. 사용자 스토리 (User Stories)

### 3.1 핵심 사용자 플로우

#### US-001: 가입 및 온보딩
**As a** 크리스천 커플
**I want to** 쉽고 빠르게 가입하고 파트너와 연결하고 싶다
**So that** 바로 말씀 나눔을 시작할 수 있다

**Acceptance Criteria**:
- [ ] Google 소셜 로그인 (OAuth 2.0)
- [ ] 프로필 설정 (이름, 사진, 관계 단계)
- [ ] 파트너 초대 링크 생성 및 전송
- [ ] 파트너가 수락하면 커플 연결 완료
- [ ] 온보딩 스토리 (3단계 이내)

#### US-002: 일일 말씀 받기
**As a** 사용자
**I want to** 매일 새로운 성경 구절과 질문을 받고 싶다
**So that** 무엇을 읽을지 고민하지 않아도 된다

**Acceptance Criteria**:
- [ ] 매일 자정에 새로운 말씀 & 질문 생성 (AI)
- [ ] 푸시 알림으로 "오늘의 말씀이 도착했어요!" 전송
- [ ] 홈 화면에서 오늘의 말씀 카드 확인
- [ ] 성경 구절 3-5절 분량
- [ ] AI 생성 질문 1개

#### US-003: 답변 작성
**As a** 사용자
**I want to** 말씀을 읽고 내 생각을 쉽게 작성하고 싶다
**So that** 3-5분 안에 완료할 수 있다

**Acceptance Criteria**:
- [ ] 성경 구절 읽기 (폰트 크기 조절 가능)
- [ ] 질문 확인
- [ ] 텍스트 입력 (200자 권장, 최대 500자)
- [ ] 답변 제출 후 "파트너 대기 중" 상태 표시
- [ ] 임시 저장 기능 (작성 중 나가도 저장)

#### US-004: Dual Reveal (동시 공개)
**As a** 사용자
**I want to** 두 사람 모두 답변 완료 시 동시에 공개되길 원한다
**So that** 설렘과 기대감을 느낄 수 있다

**Acceptance Criteria**:
- [ ] 한 명만 완료 시: "○○님이 답변을 기다리고 있어요" 표시
- [ ] 둘 다 완료 시: 카드 뒤집기 애니메이션으로 동시 공개
- [ ] 서로의 답변 읽기
- [ ] "좋아요" 또는 "하트" 반응 가능
- [ ] 추가 대화는 인앱 채팅 또는 외부 메신저

#### US-005: 스트릭 확인
**As a** 사용자
**I want to** 우리가 며칠째 함께 읽고 있는지 보고 싶다
**So that** 동기부여를 받고 습관을 유지할 수 있다

**Acceptance Criteria**:
- [ ] 홈 화면에 현재 스트릭 표시 (🔥 7일째)
- [ ] 최고 스트릭 기록 표시
- [ ] 스트릭이 끊기면 0으로 리셋 (부드러운 메시지)
- [ ] 마일스톤 달성 시 축하 애니메이션 (7일, 30일, 100일)

#### US-006: 과거 대화 보기
**As a** 사용자
**I want to** 지난주에 나눈 말씀을 다시 보고 싶다
**So that** 추억을 회상하고 성장을 확인할 수 있다

**Acceptance Criteria**:
- [ ] 과거 7일간의 말씀 & 답변 보기 (무료)
- [ ] 날짜별 정렬
- [ ] 특정 날짜 선택하여 상세 보기
- [ ] 프리미엄: 전체 기간 보기

---

## 4. 기능 명세 (Feature Specification)

### 4.1 인증 및 사용자 관리

#### F-001: 회원가입 / 로그인
**우선순위**: P0 (필수)
**설명**: Google 소셜 로그인 지원 (OAuth 2.0)

**기술 스펙**:
- Supabase Auth 사용
- OAuth 2.0 (Google)
- 간편한 원클릭 로그인

**UI/UX**:
- 로그인 화면: Google 로그인 버튼 1개
- 간단한 프로필 설정 (이름, 성별, 관계 단계)

#### F-002: 프로필 설정
**우선순위**: P0
**설명**: 이름, 성별, 프로필 사진, 관계 단계 설정

**데이터 모델**:
```typescript
interface UserProfile {
  user_id: string;
  name: string;
  gender: 'male' | 'female';
  profile_image_url?: string;
  relationship_stage: 'dating' | 'engaged' | 'married';
  created_at: timestamp;
}
```

**UI/UX**:
- 이름 입력 필드
- 성별 선택 (남성/여성 라디오 버튼)
- 관계 단계 선택 (연애 중/약혼/신혼 드롭다운)
- 프로필 사진 업로드 (선택사항)

#### F-003: 커플 매칭
**우선순위**: P0
**설명**: 파트너 초대 및 커플 계정 연결

**플로우**:
1. User A가 가입 후 "파트너 초대" 버튼 클릭
2. 초대 링크 생성 (유니크 토큰)
3. 카카오톡, 문자 등으로 공유
4. User B가 링크로 접속하여 가입
5. 자동으로 커플 연결 (couple_id 생성)

**데이터 모델**:
```typescript
interface Couple {
  couple_id: string;
  user1_id: string;
  user2_id: string;
  created_at: timestamp;
  relationship_stage: 'dating' | 'engaged' | 'married';
}
```

---

### 4.2 일일 말씀 & 질문 시스템

#### F-004: 일일 말씀 생성 (AI)
**우선순위**: P0
**설명**: 매일 자정에 모든 커플을 위한 말씀 & 질문 생성

**기술 스펙**:
- **성경 데이터**: 로컬 JSON 파일 (assets/data/bible.json)
- **AI API**: Gemini 1.5 Flash
- **실행 방식**: Supabase Edge Function (Cron Job)

**알고리즘**:
1. 주제 선택 (사랑, 용서, 감사, 소통 등 - 로테이션)
2. 로컬 JSON 파일에서 해당 주제 관련 구절 조회 (verse_topics.json)
3. Gemini API에 구절 + 커플 상태 → 질문 생성 요청
4. 생성된 질문 검증 (신학적 적절성 필터)
5. DB에 저장

**Gemini Prompt**:
```
당신은 크리스천 커플을 위한 성경 공부 가이드입니다.

성경 구절:
[고린도전서 13:4-7]
"사랑은 오래 참고 사랑은 온유하며 시기하지 아니하며..."

커플 상태: [연애 중]

위 말씀을 읽은 커플이 서로 나눌 수 있는 대화 질문 1개를 생성하세요.

요구사항:
1. 커플의 관계에 직접 적용 가능해야 함
2. 너무 무겁지 않고 자연스러운 대화 유도
3. "서로" 나눌 수 있는 질문 (한 사람만 답하는 것 X)
4. 50자 이내

출력 형식:
[질문 내용만 출력]
```

**데이터 모델**:
```typescript
interface DailyVerse {
  verse_id: string;
  date: date; // YYYY-MM-DD
  bible_book: string; // "고린도전서"
  chapter: number;
  verse_start: number;
  verse_end: number;
  text_korean: string; // 성경 본문 (개역개정)
  text_english?: string; // 영어 (NIV)
  question_korean: string; // AI 생성 질문
  question_english?: string;
  topic: string; // "love", "forgiveness", etc.
  created_at: timestamp;
}
```

#### F-005: 로컬 성경 데이터 통합
**우선순위**: P0
**설명**: 로컬 JSON 파일을 사용하여 성경 구절 조회 (인터넷 연결 불필요)

**데이터 구조**:
```
assets/data/
├── bible.json           # 전체 성경 데이터 (개역개정)
├── bible_metadata.json  # 책 정보, 장/절 수
└── verse_topics.json    # 주제별 구절 매핑
```

**JSON 예시**:
```json
{
  "고린도전서": {
    "13": {
      "4": "사랑은 오래 참고 사랑은 온유하며 시기하지 아니하며...",
      "5": "무례히 행하지 아니하며 자기의 유익을 구하지 아니하며...",
      "6": "불의를 기뻐하지 아니하며 진리와 함께 기뻐하고",
      "7": "모든 것을 참으며 모든 것을 믿으며 모든 것을 바라며 모든 것을 견디느니라"
    }
  }
}
```

**로딩 전략**:
1. 앱 시작 시 JSON 파일을 메모리에 로드
2. 빠른 조회를 위해 메모리 캐싱
3. 인터넷 연결 불필요 (완전 오프라인 지원)

**데이터 모델**:
```typescript
interface BibleVerse {
  book: string;        // "고린도전서"
  chapter: number;     // 13
  verse: number;       // 4
  text: string;        // "사랑은 오래 참고..."
  translation: string; // "KRV" (개역개정)
}
```

#### F-006: 푸시 알림
**우선순위**: P0
**설명**: 매일 오늘의 말씀 도착 알림

**기술 스펙**:
- flutter_local_notifications (로컬 알림 스케줄링)
- timezone 패키지 (정확한 시간 스케줄링)

**알림 시간**:
- 기본: 오전 9시
- 사용자 커스터마이징 가능 (설정에서 변경)

**알림 메시지**:
```
제목: 오늘의 말씀이 도착했어요! 📖
내용: [파트너 이름]님과 함께 읽어보세요
```

---

### 4.3 답변 작성 & Dual Reveal

#### F-007: 답변 작성
**우선순위**: P0
**설명**: 말씀을 읽고 질문에 답변 작성

**UI/UX**:
1. 성경 구절 표시 (세리프 폰트, 여백 충분)
2. 질문 표시
3. 텍스트 입력 필드 (멀티라인)
4. 글자 수 표시 (200자 권장, 500자 최대)
5. "제출" 버튼

**데이터 모델**:
```typescript
interface Response {
  response_id: string;
  verse_id: string;
  user_id: string;
  couple_id: string;
  content: string;
  created_at: timestamp;
  is_submitted: boolean; // 임시 저장 vs 제출 완료
}
```

#### F-008: Dual Reveal (동시 공개)
**우선순위**: P0
**설명**: 두 사람 모두 답변 완료 시 동시 공개

**로직**:
1. User A 답변 제출 → `user_a_submitted = true`
2. User B 답변 제출 → `user_b_submitted = true`
3. 둘 다 `true`이면 → 서로 답변 볼 수 있음
4. 한 명만 `true`이면 → 대기 화면

**UI/UX - 대기 화면**:
```
[카드 뒷면 이미지]
○○님이 답변을 기다리고 있어요 💬
```

**UI/UX - 공개 애니메이션**:
```
[카드 뒤집기 애니메이션 3초]
→ 두 사람의 답변이 동시에 나타남
→ 상단: 내 답변
→ 하단: 파트너 답변
```

**데이터 모델**:
```typescript
interface DailyProgress {
  progress_id: string;
  couple_id: string;
  verse_id: string;
  date: date;
  user1_submitted: boolean;
  user2_submitted: boolean;
  both_completed_at?: timestamp;
}
```

#### F-009: 반응 (좋아요/하트)
**우선순위**: P1 (선택적)
**설명**: 파트너 답변에 하트 반응

**UI/UX**:
- 파트너 답변 하단에 하트 아이콘
- 클릭 시 애니메이션 + "♥ 1" 표시

---

### 4.4 스트릭 & 마일스톤

#### F-010: 스트릭 시스템
**우선순위**: P0
**설명**: 연속 사용 일수 추적

**로직**:
1. 두 사람 모두 답변 완료 → 스트릭 +1
2. 하루라도 둘 중 한 명이 미완료 → 스트릭 리셋
3. 최고 스트릭 기록 별도 저장

**데이터 모델**:
```typescript
interface Streak {
  couple_id: string;
  current_streak: number;
  longest_streak: number;
  last_completed_date: date;
}
```

**UI/UX**:
- 홈 화면 상단: "🔥 7일째 함께 읽고 있어요!"
- 스트릭 끊김 시: "새로운 시작! 다시 함께 읽어볼까요?"

#### F-011: 마일스톤 축하
**우선순위**: P0
**설명**: 특정 일수 달성 시 축하 메시지

**마일스톤**:
- 7일: "일주일 함께 읽었어요! 🎉"
- 30일: "한 달 축하해요! 💕"
- 100일: "100일! 놀라운 습관이에요! 🏆"
- 365일: "1년! 함께한 여정을 축하해요! 🎊"

**UI/UX**:
- 풀스크린 축하 애니메이션 (컨페티)
- 공유 기능 (인스타 스토리, 카톡)

#### F-015: 성령의 불 캐릭터 시스템 (Holy Fire Character)
**우선순위**: P0
**설명**: 스트릭에 반응하는 동적 캐릭터로 습관 형성 동기부여 강화

**핵심 개념**:
- 성령의 불 모양의 귀여운 캐릭터
- 스트릭에 따라 3단계로 변화 (Level 1 → Level 2 → Level 3)
- 불꽃이 점점 강해지거나 약해지는 시각적 피드백

**레벨 시스템**:
```
Level 1 (약한 불꽃): 0-2일 연속
  - 작고 약한 불꽃
  - 천천히 흔들리는 애니메이션

Level 2 (중간 불꽃): 3-6일 연속
  - 중간 크기, 활기찬 불꽃
  - 더 역동적인 움직임

Level 3 (강한 불꽃): 7일 이상 연속
  - 크고 강렬한 불꽃
  - 빠르고 강렬한 애니메이션
```

**기술 스펙**:
- **포맷**: PNG (투명 배경, 알파 채널)
- **저장 위치**: `assets/images/holy_fire/`
  - `level1.png` (약 50KB)
  - `level2.png` (약 50KB)
  - `level3.png` (약 50KB)
- **총 용량**: 약 150KB (비디오 대비 95% 감소)
- **애니메이션**: Flutter AnimationController (코드 기반)
  - Float: 위아래로 둥실둥실 움직임
  - Pulse: 크기 맥동 효과
  - Glow: 캐릭터 테두리 빛남 (ImageFilter + ColorFilter)
  - Shake: 탭 시 흔들림 (선택적)
  - Drag: 드래그로 위치 이동 (선택적)

**레벨 계산 로직**:
```typescript
function calculateFireLevel(currentStreak: number): number {
  if (currentStreak >= 7) return 3;
  if (currentStreak >= 3) return 2;
  return 1;
}
```

**데이터 모델 확장**:
```typescript
interface Streak {
  couple_id: string;
  current_streak: number;
  longest_streak: number;
  last_completed_date: date;
  holy_fire_level: number; // 1, 2, 3 (NEW)
  updated_at: timestamp;
}
```

**UI/UX**:
- **위치**: 홈 화면 상단 (스트릭 위젯 근처 또는 통합)
- **크기**: 80-120px
- **배경**: 완전 투명 (PNG 알파 채널)
- **애니메이션**:
  - Float: 2초 주기 위아래 움직임
  - Pulse: 1.5초 주기 크기 맥동
  - Glow: 1.8초 주기 테두리 빛남 (진한 주황색)
- **인터랙션** (선택적):
  - 탭: 흔들림 효과
  - 드래그: 위치 이동 후 2초 뒤 복귀
- **레벨 업 알림**: "성령의 불이 더 강해졌어요! 🔥"

**이미지 제작 가이드**:
- 포맷: PNG (알파 채널 필수)
- 배경: 완전 투명 (Alpha = 0)
- 해상도: 500x500px 이상 권장
- 디자인: 불꽃 캐릭터 (귀여운 스타일)
- 레벨별 차이점:
  - Level 1: 작고 약한 불꽃 (밝은 색상)
  - Level 2: 중간 크기 불꽃 (중간 색상)
  - Level 3: 크고 강렬한 불꽃 (진한 색상)
- 애니메이션은 Flutter 코드로 구현 (이미지는 정적)

---

### 4.5 과거 대화 보기

#### F-012: 타임라인 뷰
**우선순위**: P1
**설명**: 과거 말씀 & 답변 아카이브

**무료 vs 프리미엄**:
- 무료: 최근 7일
- 프리미엄: 전체 기간

**UI/UX**:
- 날짜별 리스트
- 각 항목: 날짜, 성경 구절 요약, 답변 미리보기
- 클릭 시 전체 내용 표시

---

### 4.6 설정 & 기타

#### F-013: 설정
**우선순위**: P1
**설명**: 사용자 설정

**항목**:
- [ ] 알림 시간 변경
- [ ] 알림 ON/OFF
- [ ] 프로필 수정 (이름, 사진)
- [ ] 성경 번역본 선택 (개역개정, 개역한글, NIV 등)
- [ ] 테마 (라이트, 다크)
- [ ] 계정 설정 (비밀번호 변경, 로그아웃, 탈퇴)

#### F-014: 온보딩
**우선순위**: P0
**설명**: 첫 사용자를 위한 가이드

**3단계 온보딩**:
1. **환영**: "두 사람의 신앙 여정을 함께 시작해요 ✨"
2. **설명**: "매일 짧은 말씀과 질문으로 서로를 더 깊이 알아가요"
3. **초대**: "파트너를 초대하고 첫 말씀을 나눠보세요"

---

## 5. AI 기능 통합 계획

### 5.1 Gemini API 활용

#### 목적
- 일일 질문 자동 생성
- 커플 맞춤형 개인화

#### 기술 스펙
- **API**: Google Gemini 1.5 Flash
- **Pricing**: $0.075 / 1M input tokens, $0.30 / 1M output tokens
- **월 예상 비용**: $3.6 (1,000 커플 기준)

#### 품질 관리
1. **Prompt Engineering**: 최적화된 프롬프트 설계
2. **피드백 루프**: 사용자가 "이 질문이 적절하지 않아요" 신고 가능
3. **수동 검증**: 베타 기간 동안 목회자 검토
4. **필터링**: 부적절한 키워드 자동 차단

#### 개인화 전략
- **입력**: 커플 상태 (연애/약혼/신혼) + 과거 답변 패턴
- **출력**: 맞춤형 질문

**예시**:
- 연애 커플: "이 말씀을 통해 상대방을 어떻게 더 사랑할 수 있을까요?"
- 약혼 커플: "결혼 생활에서 이 말씀을 어떻게 적용할 수 있을까요?"
- 신혼 커플: "오늘 하루 중 이 말씀을 실천할 수 있는 순간은 언제일까요?"

### 5.2 GPT API 활용 (프리미엄 기능 - 추후)

#### 목적
- 두 사람의 답변 분석
- 관계 인사이트 제공

#### 예시
```
입력:
- 질문: "이 말씀을 우리 관계에 어떻게 적용할 수 있을까요?"
- A 답변: "서로에게 더 인내심을 가져야 할 것 같아."
- B 답변: "상대방이 힘들 때 더 이해하려고 노력해야겠어."

출력:
"두 분 모두 '인내'와 '이해'의 중요성을 느끼셨네요. 특히 상대방의 어려움을
헤아리려는 마음이 보여요. 오늘 저녁, 서로에게 '오늘 힘든 일이 있었어?'라고
먼저 물어보는 건 어떨까요?"
```

---

## 6. 데이터 아키텍처

### 6.1 데이터베이스 스키마 (Supabase PostgreSQL)

#### Table: users
```sql
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  profile_image_url TEXT,
  relationship_stage VARCHAR(20) CHECK (relationship_stage IN ('dating', 'engaged', 'married')),
  notification_time TIME DEFAULT '09:00:00',
  notification_enabled BOOLEAN DEFAULT true,
  bible_translation VARCHAR(20) DEFAULT 'KRV',
  theme VARCHAR(10) DEFAULT 'light',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### Table: couples
```sql
CREATE TABLE couples (
  couple_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user1_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
  user2_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
  relationship_stage VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user1_id, user2_id)
);
```

#### Table: daily_verses
```sql
CREATE TABLE daily_verses (
  verse_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  date DATE UNIQUE NOT NULL,
  bible_book VARCHAR(50) NOT NULL,
  chapter INT NOT NULL,
  verse_start INT NOT NULL,
  verse_end INT,
  text_korean TEXT NOT NULL,
  text_english TEXT,
  question_korean TEXT NOT NULL,
  question_english TEXT,
  topic VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### Table: responses
```sql
CREATE TABLE responses (
  response_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  verse_id UUID REFERENCES daily_verses(verse_id),
  user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
  couple_id UUID REFERENCES couples(couple_id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_submitted BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(verse_id, user_id)
);
```

#### Table: daily_progress
```sql
CREATE TABLE daily_progress (
  progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  couple_id UUID REFERENCES couples(couple_id) ON DELETE CASCADE,
  verse_id UUID REFERENCES daily_verses(verse_id),
  date DATE NOT NULL,
  user1_submitted BOOLEAN DEFAULT false,
  user2_submitted BOOLEAN DEFAULT false,
  both_completed_at TIMESTAMP,
  UNIQUE(couple_id, date)
);
```

#### Table: streaks
```sql
CREATE TABLE streaks (
  couple_id UUID PRIMARY KEY REFERENCES couples(couple_id) ON DELETE CASCADE,
  current_streak INT DEFAULT 0,
  longest_streak INT DEFAULT 0,
  last_completed_date DATE,
  holy_fire_level INT DEFAULT 1 CHECK (holy_fire_level IN (1, 2, 3)), -- NEW
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### Table: bible_cache
```sql
CREATE TABLE bible_cache (
  cache_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference VARCHAR(100) NOT NULL, -- "고린도전서 13:4-7"
  translation VARCHAR(20) NOT NULL,
  text TEXT NOT NULL,
  cached_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(reference, translation)
);
```

### 6.2 API 엔드포인트 설계

#### Authentication
```
POST   /auth/signup          # 회원가입
POST   /auth/login           # 로그인
POST   /auth/logout          # 로그아웃
GET    /auth/me              # 현재 사용자 정보
```

#### Couples
```
POST   /couples/invite       # 파트너 초대 링크 생성
POST   /couples/accept       # 초대 수락
GET    /couples/me           # 내 커플 정보
DELETE /couples/disconnect   # 커플 연결 해제
```

#### Daily Verses
```
GET    /verses/today         # 오늘의 말씀
GET    /verses/:verse_id     # 특정 말씀 조회
GET    /verses/history       # 과거 말씀 리스트
```

#### Responses
```
POST   /responses            # 답변 작성/수정
GET    /responses/today      # 오늘 나의 답변
GET    /responses/partner    # 파트너 답변 (둘 다 제출 시만)
GET    /responses/history    # 과거 답변 조회
```

#### Streaks
```
GET    /streaks/me           # 내 스트릭 정보
```

#### Notifications
```
PUT    /notifications/settings  # 알림 설정 변경 (시간, ON/OFF)
```

---

## 7. UI/UX 가이드라인

### 7.1 디자인 원칙
1. **Simplicity**: 복잡하지 않고 직관적
2. **Warmth**: 따뜻하고 감성적인 느낌
3. **Sacred + Modern**: 성경의 경건함 + 모던한 UX
4. **Card-First Design**: 큰 카드 중심의 시각적 계층 구조
5. **Soft & Calm**: 부드러운 색상과 넉넉한 여백으로 평온함 전달

### 7.2 컬러 팔레트

**디자인 참조**: 모던하고 차분한 UI (연한 청회색 배경 + 흰색 카드)

**✅ UPDATE (2026-03-27)**: Phase 0.5에서 최종 색상 확정 완료

#### 라이트 모드
- **Primary**: #11BC78 (녹색/민트 - 성장, 생명, 신선함)
- **Primary Light**: #40D399 (밝은 민트)
- **Primary Dark**: #0D9A63 (어두운 민트)
- **Secondary**: #FFC857 (따뜻한 노란색 - 빛, 별)
- **Background**: #F1F5F9 (연한 청회색 - 부드럽고 차분함)
- **Surface (Card)**: #FFFFFF (흰색 - 깔끔하고 명확한 구분)
- **Text on Background**: #1A1A1A (어두운 회색 - 배경 위 가독성)
- **Text on Card**: #1A1A1A (어두운 회색 - 가독성)
- **Text Secondary**: #666666
- **Accent**: #FF6B9D (핑크 - 하트, 사랑)

#### 다크 모드
- **Primary**: #40D399 (밝은 민트 - 다크 모드에서 가시성)
- **Secondary**: #FFC857
- **Background**: #121212
- **Surface**: #1E1E1E
- **Text Primary**: #FFFFFF
- **Text Secondary**: #B0B0B0

### 7.3 타이포그래피

**✅ UPDATE (2026-03-28)**: Phase 0.5에서 폰트 시스템 완료

#### 폰트 패밀리
- **UI/버튼**: Pretendard (시스템 기본 폰트 사용 중)
- **성경 구절**: Noto Serif KR (향후 추가 예정)

**참고**: 자세한 타이포그래피 스타일은 [design-guideline.md 섹션 3](./design-guideline.md#3-타이포그래피-typography) 참조

#### 폰트 크기
- **Headline 1**: 24px (Bold) - 화면 제목
- **Headline 2**: 20px (Bold) - 섹션 제목
- **Body 1**: 16px (Regular) - 주요 본문
- **Body 2**: 14px (Regular) - 보조 본문
- **Caption 1**: 12px (Regular) - 캡션, 라벨
- **성경 구절**: 18px (Medium, Noto Serif KR) - 가독성 + 경건함

### 7.3.1 컴포넌트 스타일

**📝 NOTE**: 상세한 컴포넌트 스타일은 [design-guideline.md 섹션 4](./design-guideline.md#4-컴포넌트-스타일-component-styles)를 참조하세요.

#### 핵심 스타일 요약

**버튼**:
- Primary: #11BC78 배경, 흰색 텍스트, 12px 둥근 모서리
- Secondary: #F5F5F5 배경, #666666 텍스트
- Text: 배경 없음, primaryColor 텍스트

**카드**:
- 기본 카드: 16px 둥근 모서리, Elevation 2
- 강조 카드: 20px 둥근 모서리, Elevation 4
- 내부 패딩: 20px

**입력 필드**:
- 배경: Colors.grey.shade100
- 둥근 모서리: 12px
- 포커스 테두리: primaryColor, 2px

**다이얼로그**:
- 둥근 모서리: 20px
- 내부 패딩: 24px
- 버튼: Primary + Secondary 조합

**아이콘 & 이모지**:
- 하트 (좋아요): #FF6B9D (핑크)
- 별 (평점/스트릭): #FFC857 (노란색)
- 불꽃 (스트릭): #FF6B4D (주황-빨강)
- 크기: 20-24px (일반), 32-48px (강조)

**레이아웃**:
- 여백: 넉넉한 padding (16-24px)
- 카드 간격: 16px
- 섹션 간격: 24-32px

**공통 위젯 사용법은 [design-guideline.md 섹션 4.9~4.14](./design-guideline.md#49-공통-위젯-버튼-common-widgets-buttons) 참조**
- **스크롤**: 부드러운 수직/수평 스크롤

### 7.4 핵심 화면 와이어프레임

#### 홈 화면
```
┌─────────────────────────────┐
│  🔥 7일째 함께 읽고 있어요!  │ <- 스트릭
│         🔥                   │ <- 성령의 불 캐릭터 (Level 3)
│      [애니메이션]             │    (투명 배경, 80-120px)
├─────────────────────────────┤
│                             │
│   [오늘의 말씀 카드]          │ <- 카드 디자인
│   고린도전서 13:4-7          │
│   "사랑은 오래 참고..."       │
│                             │
│   [읽으러 가기 버튼]          │
│                             │
├─────────────────────────────┤
│  📚 과거 대화 보기            │
│  ⚙️ 설정                    │
└─────────────────────────────┘
```

#### 답변 작성 화면
```
┌─────────────────────────────┐
│  ← 오늘의 말씀                │
├─────────────────────────────┤
│  고린도전서 13:4-7            │
│                             │
│  "사랑은 오래 참고 사랑은      │
│   온유하며 시기하지 아니하며..." │
│                             │
├─────────────────────────────┤
│  💬 오늘의 질문                │
│  "이 말씀을 우리 관계에        │
│   어떻게 적용할 수 있을까요?"  │
│                             │
├─────────────────────────────┤
│  [텍스트 입력 영역]           │
│                             │
│                             │
│                  150 / 500자 │
├─────────────────────────────┤
│          [제출하기]           │
└─────────────────────────────┘
```

#### Dual Reveal 화면
```
┌─────────────────────────────┐
│  카드 뒤집기 애니메이션         │
├─────────────────────────────┤
│  💬 나의 답변                 │
│  "서로에게 더 인내심을..."     │
│                             │
│  ♥ 좋아요                    │
├─────────────────────────────┤
│  💬 ○○님의 답변               │
│  "상대방이 힘들 때 더..."      │
│                             │
│  ♥ 좋아요                    │
└─────────────────────────────┘
```

---

## 8. 비기능적 요구사항 (Non-Functional Requirements)

### 8.1 성능
- **로딩 시간**: 홈 화면 1초 이내
- **API 응답**: 평균 300ms 이하
- **이미지 로딩**: Progressive loading

### 8.2 확장성
- **사용자 수**: 10만 커플까지 지원 (초기)
- **데이터베이스**: Supabase 오토 스케일링
- **API**: Edge Functions로 글로벌 배포

### 8.3 가용성
- **Uptime**: 99.9% 목표
- **장애 대응**: 1시간 이내 복구

### 8.4 보안
- **인증**: Supabase Auth (JWT)
- **데이터 암호화**: HTTPS, DB 암호화
- **GDPR 준수**: 개인정보 처리 방침

### 8.5 접근성
- **폰트 크기**: 사용자 조절 가능
- **색맹 모드**: 고대비 테마 제공
- **Screen Reader**: 지원 (추후)

---

## 9. 보안 & 프라이버시

### 9.1 데이터 보호
- **커플 데이터**: 오직 두 사람만 접근 가능
- **답변**: 암호화 저장
- **프로필 사진**: Supabase Storage (Private)

### 9.2 Row Level Security (RLS)
```sql
-- 예시: responses 테이블
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only see their own and partner's responses"
ON responses
FOR SELECT
USING (
  user_id = auth.uid()
  OR user_id IN (
    SELECT user1_id FROM couples WHERE user2_id = auth.uid()
    UNION
    SELECT user2_id FROM couples WHERE user1_id = auth.uid()
  )
);
```

### 9.3 개인정보 처리 방침
- 회원가입 시 동의 필수
- 탈퇴 시 데이터 완전 삭제 (30일 유예 기간)
- 마케팅 수신 동의 별도

---

## 10. 테스트 계획

### 10.1 단위 테스트
- **커버리지**: 80% 이상
- **도구**: Jest (Flutter: flutter_test)

### 10.2 통합 테스트
- **API 엔드포인트**: Postman/Thunder Client
- **DB 트리거**: Supabase 테스트 환경

### 10.3 E2E 테스트
- **시나리오**:
  1. 회원가입 → 파트너 초대 → 커플 연결
  2. 오늘의 말씀 조회 → 답변 작성 → Dual Reveal
  3. 7일 연속 사용 → 스트릭 확인

### 10.4 베타 테스트
- **타겟**: 교회 청년부 20-30 커플
- **기간**: 2주
- **피드백**: 인앱 설문 + 1:1 인터뷰

---

## 11. 출시 계획

### 11.1 MVP 출시 (0-3개월)

#### Phase 1: 개발 (0-2개월)
- Week 1-2: 프로젝트 셋업, DB 스키마 (Phase 0 ✅ 완료)
- **Week 2.5-3: 디자인 시스템 구축 (Phase 0.5) ⏸️ 대기 중**
  - 사용자 UI 이미지 분석 및 디자인 토큰 추출
  - 폰트 파일 추가 (Pretendard, Noto Serif KR)
  - 테마 시스템 구현 및 테스트 페이지로 검증
  - 공통 위젯 라이브러리 구현 (버튼, 카드, 입력 필드 등 10개 이상)
  - 기존 UI (Phase 1.1~1.2) 리팩토링
  - UI 가이드 문서 작성 (docs/ui-guide.md)
- Week 3-4: 인증, 커플 매칭 (Phase 1, 일부 완료 ✅)
- Week 5-6: 일일 말씀, AI 통합 (Phase 2)
- Week 7-8: 답변 작성, Dual Reveal (Phase 3)
- Week 9-10: 스트릭, 알림, UI/UX 완성 (Phase 4-5)

#### Phase 2: 베타 테스트 (2-3개월)
- 20-30 커플 초대
- 피드백 수집 및 개선
- 버그 수정

#### Phase 3: 정식 출시 (3개월)
- 앱스토어 등록 (iOS, Android)
- 교회 커뮤니티 마케팅
- 500 커플 목표

### 11.2 플랫폼
- **iOS**: App Store
- **Android**: Google Play Store
- **웹**: 추후 고려

### 11.3 버전 관리
- **MVP**: v1.0.0
- **마이너 업데이트**: v1.1.0, v1.2.0 (기능 추가)
- **패치**: v1.0.1, v1.0.2 (버그 수정)

---

## 12. 위험 관리 (Risk Management)

| 위험 | 확률 | 영향 | 완화 전략 |
|------|------|------|-----------|
| AI 질문 품질 낮음 | 중 | 높음 | 베타 테스트, 목회자 검증, 피드백 루프 |
| 한 명만 사용 | 높음 | 높음 | 파트너 독려 알림, Dual 전제 UX |
| 성경 API 중단 | 낮음 | 중 | 다중 API 백업, 로컬 캐싱 |
| 리텐션 낮음 | 중 | 높음 | 스트릭, 마일스톤, 주제 다양화 |
| 보안 취약점 | 낮음 | 높음 | RLS, 암호화, 정기 감사 |

---

## 13. 다음 단계

1. ✅ 핵심 기능 브레인스토밍
2. ✅ 사용자 페르소나 & 여정
3. ✅ 전체 제품 전략
4. ✅ 경쟁사 분석
5. ✅ PRD 작성
6. ⏭️ **Flutter 개발 로드맵** (다음!)

---

## 부록

### A. 용어 정의
- **MVP**: Minimum Viable Product (최소 기능 제품)
- **Dual Reveal**: 두 사람의 답변을 동시에 공개하는 UX
- **스트릭**: 연속 사용 일수
- **RLS**: Row Level Security (행 단위 보안)

### B. 참고 자료
- [Supabase 문서](https://supabase.com/docs)
- [Gemini API 문서](https://ai.google.dev/docs)
- [Flutter 가이드](https://flutter.dev/docs)
- [로컬 성경 데이터](assets/data/bible.json) - 개역개정 전체 성경

---

**문서 버전 히스토리**:
- v1.0 (2026-03-24): 초안 작성

**검토 필요**:
- [ ] 신학적 적절성 (목회자)
- [ ] 기술 스펙 (개발팀)
- [ ] UI/UX 디자인 (디자이너)
- [ ] 비즈니스 모델 (경영진)
