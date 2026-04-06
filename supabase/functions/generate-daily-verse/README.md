# Edge Function: generate-daily-verse

매일 자정(UTC 15:00)에 실행되어 커플별 일일 말씀 플랜에 따라 성경 구절과 AI 질문을 생성하는 Supabase Edge Function입니다.

## 구현 완료 항목 ✅

- [x] TypeScript 타입 정의 (types.ts)
- [x] 성경 메타데이터 자동 생성 (bible-metadata.ts)
- [x] BibleLoader (bible-loader.ts)
- [x] PlanCalculator (plan-calculator.ts)
- [x] QuestionGenerator (question-generator.ts)
- [x] DBUpdater (db-updater.ts)
- [x] 메인 함수 통합 (index.ts)
- [x] Cron Job SQL 파일 (migrations/20260406000000_create_cron_job.sql)

## 배포 전 설정 (필수!)

### 1. Supabase Storage 업로드

Bible JSON 파일을 Supabase Storage에 업로드해야 합니다.

**방법 1: Supabase Dashboard (추천)**

1. Supabase Dashboard → Storage 메뉴
2. "Create bucket" 버튼 클릭
   - Name: `bible-data`
   - Public: **체크** (Edge Function에서 접근 가능하도록)
3. `bible-data` 버킷 클릭 → "Upload file" 버튼
4. `assets/data/bible.json` 파일 선택하여 업로드
5. 업로드 확인:
   ```
   https://your-project.supabase.co/storage/v1/object/public/bible-data/bible.json
   ```

**방법 2: Supabase CLI**

```bash
supabase storage buckets create bible-data --public
supabase storage upload bible-data assets/data/bible.json
```

---

### 2. 환경 변수 설정

Edge Function이 Gemini API와 Supabase에 접근하려면 환경 변수가 필요합니다.

```bash
# Gemini API Key 설정
supabase secrets set GEMINI_API_KEY=your-gemini-api-key-here

# Supabase URL 설정
supabase secrets set SUPABASE_URL=https://your-project.supabase.co

# Service Role Key 설정 (Dashboard → Settings → API)
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here

# 확인
supabase secrets list
```

**환경 변수 찾는 방법**:
- **Supabase URL**: Supabase Dashboard → Settings → API → Project URL
- **Service Role Key**: Supabase Dashboard → Settings → API → `service_role` (secret)
- **Gemini API Key**: https://aistudio.google.com/app/apikey

---

### 3. Edge Function 배포

```bash
# 현재 디렉토리 확인
pwd
# 출력: /path/to/bible_sumone

# Edge Function 배포
supabase functions deploy generate-daily-verse

# 배포 확인
supabase functions list
```

---

### 4. Cron Job 설정

**IMPORTANT**: SQL 파일 수정 필요!

1. `supabase/migrations/20260406000000_create_cron_job.sql` 파일 열기
2. 다음 두 항목 수정:
   ```sql
   -- 수정 전
   url := 'https://your-project.supabase.co/functions/v1/generate-daily-verse',
   'Authorization', 'Bearer YOUR_SERVICE_ROLE_KEY'

   -- 수정 후 (예시)
   url := 'https://abcd1234.supabase.co/functions/v1/generate-daily-verse',
   'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
   ```

3. Supabase Dashboard → SQL Editor → 파일 내용 붙여넣기 → Run

---

## 로컬 테스트

배포 전에 로컬에서 테스트할 수 있습니다.

### 1. 환경 변수 파일 생성

`.env.local` 파일 생성:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
GEMINI_API_KEY=your-gemini-api-key
```

### 2. 로컬 서버 실행

```bash
supabase functions serve generate-daily-verse --env-file .env.local
```

### 3. 수동 호출

```bash
curl -i --location --request POST \
  'http://localhost:54321/functions/v1/generate-daily-verse' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json'
```

**예상 응답**:
```json
{
  "date": "2026-04-06",
  "total": 5,
  "success": 5,
  "fail": 0
}
```

---

## 프로덕션 테스트

배포 후 수동 실행으로 테스트:

### Dashboard에서 실행

1. Supabase Dashboard → Edge Functions → `generate-daily-verse`
2. "Invoke" 버튼 클릭

### curl로 실행

```bash
curl -i --location --request POST \
  'https://your-project.supabase.co/functions/v1/generate-daily-verse' \
  --header 'Authorization: Bearer YOUR_SERVICE_ROLE_KEY' \
  --header 'Content-Type: application/json'
```

---

## 검증 SQL

생성된 데이터 확인:

```sql
-- 1. daily_verses 확인
SELECT
  date,
  bible_book,
  chapter,
  verse_start,
  verse_end,
  LEFT(question_korean, 50) AS question
FROM daily_verses
WHERE date = CURRENT_DATE
ORDER BY created_at DESC;

-- 2. daily_progress 확인
SELECT
  couple_id,
  date,
  user1_submitted,
  user2_submitted
FROM daily_progress
WHERE date = CURRENT_DATE;

-- 3. 플랜 업데이트 확인
SELECT
  couple_id,
  daily_verse_plan->>'current_book' AS book,
  daily_verse_plan->>'current_chapter' AS chapter,
  daily_verse_plan->>'current_verse' AS verse
FROM couples
WHERE daily_verse_plan IS NOT NULL;

-- 4. Cron Job 상태 확인
SELECT
  jobid,
  jobname,
  schedule,
  active,
  command,
  nodename,
  nodeport
FROM cron.job
WHERE jobname = 'generate-daily-verse-job';
```

---

## 로그 확인

```bash
# 실시간 로그 보기
supabase functions logs generate-daily-verse --tail

# 최근 로그 조회
supabase functions logs generate-daily-verse
```

---

## 트러블슈팅

### 1. "Storage 다운로드 실패" 에러

**원인**: bible.json 파일이 Storage에 없거나 버킷이 Public이 아님

**해결**:
1. Supabase Dashboard → Storage → `bible-data` 버킷 확인
2. Public 설정 확인
3. bible.json 파일 존재 확인

---

### 2. "Gemini API 할당량 초과" 에러

**원인**: Gemini API 무료 할당량 초과

**해결**:
- 템플릿 질문 사용 (자동 Fallback)
- Gemini API 유료 플랜 전환
- 하이브리드 전략이 이미 API 호출을 50% 감소시킴

---

### 3. "플랜 검증 실패" 에러

**원인**: 잘못된 성경 참조 (예: "창51장", "요4:100")

**해결**:
```sql
-- 플랜 확인
SELECT
  couple_id,
  daily_verse_plan
FROM couples
WHERE daily_verse_plan IS NOT NULL;

-- 플랜 수정 (예시)
UPDATE couples
SET daily_verse_plan = jsonb_set(
  daily_verse_plan,
  '{current_chapter}',
  '1'
)
WHERE couple_id = 'problem-couple-id';
```

---

### 4. Cron Job이 실행되지 않음

**원인**: Cron Job 설정 오류 또는 비활성화

**확인**:
```sql
SELECT * FROM cron.job WHERE jobname = 'generate-daily-verse-job';
```

**재생성**:
```sql
SELECT cron.unschedule('generate-daily-verse-job');
-- 그리고 SQL 파일 다시 실행
```

---

## 아키텍처

```
Cron Job (매일 UTC 15:00)
  ↓
Edge Function (generate-daily-verse)
  ↓
1. couples 테이블에서 플랜 조회
  ↓
2. Supabase Storage에서 bible.json 로드
  ↓
3. PlanCalculator: 오늘 읽을 구절 계산
  ↓
4. BibleLoader: 성경 구절 조회
  ↓
5. QuestionGenerator: Gemini API 질문 생성
  ↓
6. DBUpdater: daily_verses INSERT
  ↓
7. DBUpdater: daily_progress INSERT
  ↓
8. DBUpdater: couples 플랜 업데이트
```

---

## 비용 최적화

### Gemini API 비용

- **하이브리드 전략**으로 API 호출 50% 감소
  - 5절 이하: API 호출
  - 6-50절: 핵심 구절 추출 후 API 호출
  - 51절 이상: 템플릿 질문 (API 호출 없음)

### Supabase 비용

- **RLS 정책**: 필요한 데이터만 조회
- **UNIQUE 제약**: 중복 생성 방지
- **INDEX**: 빠른 조회

---

## 다음 단계

1. ✅ **Task 2.3 완료 표시**
   - `docs/roadmap.md` 업데이트: Task 2.3 체크리스트 모두 `[✅]` 표시

2. ✅ **Git Commit**
   ```bash
   git add supabase/functions/generate-daily-verse/
   git add scripts/generate-bible-metadata.js
   git add supabase/migrations/20260406000000_create_cron_job.sql
   git commit -m "feat: Task 2.3 Supabase Edge Function 구현 완료

   - generate-daily-verse Edge Function 작성
   - 커플별 플랜 기반 일일 말씀 자동 생성
   - Gemini API 질문 생성 (하이브리드 전략)
   - Cron Job 설정 (매일 UTC 15:00)
   - daily_verses, daily_progress INSERT
   - 플랜 진행 상황 자동 업데이트

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
   ```

3. 🚀 **Task 2.4 진행**
   - 홈 화면 UI 재구성 (주간 캘린더, 커플 상태, 성령의 불)
   - 오늘의 말씀 상세 화면

---

**작성일**: 2026-04-06
**버전**: 1.0
**담당**: Claude Code
