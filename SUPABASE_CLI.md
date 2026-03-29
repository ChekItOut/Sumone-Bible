# Supabase CLI 사용 가이드

## 🎯 개요

이 프로젝트는 Supabase CLI를 사용하여 데이터베이스 스키마를 버전 관리합니다.
모든 DB 변경사항은 migration 파일로 관리되며, 팀원 간 동기화가 자동으로 이루어집니다.

## 📦 설치 완료

Supabase CLI가 이미 설치되어 있습니다:
```bash
# 설치 확인
npx supabase --version
```

## 🔗 프로젝트 연결 상태

- **프로젝트 ID**: `gtpzucliwqrrfcecsgzb`
- **연결 상태**: ✅ Connected
- **Migration 동기화**: ✅ Synced (01~04)

## 🚀 주요 명령어

### 1. DB 스키마 변경하기

**자동 방법 (권장)**:
```bash
# 원격 DB와 로컬 스키마 비교하여 migration 생성
npm run sb:diff -- -f <migration_name>

# 예시: users 테이블에 새 컬럼 추가 후
npm run sb:diff -- -f add_nickname_to_users
```

**수동 방법**:
```bash
# 빈 migration 파일 생성
npm run sb:migration <migration_name>

# 예시
npm run sb:migration add_nickname_to_users

# 생성된 파일 (supabase/migrations/YYYYMMDDHHMMSS_add_nickname_to_users.sql)을 편집
```

### 2. Migration 적용하기

```bash
# 로컬 → 원격 DB로 push
npm run sb:push

# 원격 → 로컬로 pull (동기화)
npm run sb:pull
```

### 3. Migration 상태 확인

```bash
# 로컬/원격 migration 목록 확인
npx supabase migration list
```

### 4. 로컬 DB 리셋 (개발 환경)

```bash
# 로컬 DB 재시작 + 모든 migration 재적용
npm run sb:reset
```

## 📝 DB 변경 워크플로우

### 시나리오 1: 새 테이블 추가

```bash
# 1. Supabase Dashboard에서 테이블 생성
#    (또는 직접 SQL 작성)

# 2. 변경사항을 migration으로 캡처
npm run sb:diff -- -f create_notifications_table

# 3. 생성된 migration 파일 확인 (supabase/migrations/)
cat supabase/migrations/YYYYMMDDHHMMSS_create_notifications_table.sql

# 4. Git에 커밋
git add supabase/migrations/
git commit -m "feat: notifications 테이블 추가"

# 5. 원격 DB에 적용 (이미 Dashboard에서 했다면 skip)
# npm run sb:push
```

### 시나리오 2: 컬럼 추가/수정

```bash
# 1. 로컬에서 SQL 파일 작성
npm run sb:migration add_email_verified_to_users

# 2. 생성된 파일 편집
# supabase/migrations/YYYYMMDDHHMMSS_add_email_verified_to_users.sql
ALTER TABLE public.users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;

# 3. 원격 DB에 적용
npm run sb:push

# 4. Git 커밋
git add supabase/migrations/
git commit -m "feat: users 테이블에 email_verified 컬럼 추가"
```

### 시나리오 3: RLS 정책 변경

```bash
# 1. migration 파일 생성
npm run sb:migration update_responses_rls

# 2. 파일 편집
# 예시: responses 테이블 RLS 정책 수정
DROP POLICY IF EXISTS "Users can view own responses" ON public.responses;

CREATE POLICY "Users can view own responses"
ON public.responses
FOR SELECT
USING (auth.uid() = user_id);

# 3. 적용 및 커밋
npm run sb:push
git add supabase/migrations/
git commit -m "fix: responses RLS 정책 수정"
```

## 🤖 자동화된 DB 관리 (AI Assistant)

**중요**: 이제 모든 DB 변경은 AI가 자동으로 처리합니다!

### AI가 자동으로 하는 것:

1. **Migration 파일 생성**
   ```
   사용자: "users 테이블에 profile_image_url 컬럼 추가해줘"

   AI 작업:
   1. npm run sb:migration add_profile_image_to_users 실행
   2. SQL 파일 작성
   3. npm run sb:push로 적용
   4. Git 커밋
   ```

2. **RLS 정책 설정**
   ```
   사용자: "responses 테이블에 커플 공유 정책 추가해줘"

   AI 작업:
   1. migration 파일 생성
   2. RLS 정책 SQL 작성
   3. 적용 및 커밋
   ```

3. **테이블 생성**
   ```
   사용자: "notifications 테이블 만들어줘"

   AI 작업:
   1. 테이블 스키마 설계
   2. migration 파일 생성
   3. Foreign Key 설정
   4. RLS 정책 추가
   5. 적용 및 커밋
   ```

### 사용자가 해야 할 것:

- ✅ 요구사항 명확히 전달
- ✅ Migration 적용 후 테스트
- ❌ 직접 SQL 작성 (AI가 처리)
- ❌ 수동으로 migration 파일 생성 (AI가 처리)

## 📚 기존 Migration 목록

현재 적용된 migration들:

1. **01_create_tables.sql** - 초기 테이블 생성
   - users, couples, daily_verses, responses, milestones, notifications

2. **02_setup_rls.sql** - RLS 정책 설정
   - 모든 테이블에 대한 보안 정책

3. **03_add_gender_to_users.sql** - users 테이블에 gender 컬럼 추가

4. **04_add_couple_fields.sql** - couples 테이블 필드 추가
   - invitation_code, invited_user_id 등

## ⚠️ 주의사항

### DO ✅
- Migration 파일은 **항상 Git에 커밋**
- Migration 이름은 **명확하고 구체적으로** (예: `add_email_to_users`)
- 변경 전 **로컬에서 테스트**
- **순차적으로** migration 적용 (번호 순서 유지)

### DON'T ❌
- 이미 적용된 migration 파일 **절대 수정하지 마세요**
- `supabase db reset`을 프로덕션에서 **절대 사용하지 마세요**
- Migration 없이 직접 DB 수정 **금지** (항상 migration으로 관리)
- `.supabase/` 폴더를 Git에 **커밋하지 마세요** (이미 .gitignore에 추가됨)

## 🔧 트러블슈팅

### Migration history가 맞지 않을 때

```bash
# 원격과 로컬의 migration 동기화
npx supabase migration list

# 특정 migration을 "applied"로 표시
npx supabase migration repair --status applied <migration_number>
```

### 로컬과 원격이 완전히 다를 때

```bash
# 1. 원격 스키마를 새 migration으로 가져오기
npm run sb:pull

# 2. 기존 migration 파일 확인
ls supabase/migrations/

# 3. 충돌 해결 후 push
npm run sb:push
```

### Access Token 만료 시

```bash
# .env 파일의 SUPABASE_ACCESS_TOKEN 업데이트
# Supabase Dashboard → Account → Access Tokens에서 새로 생성
```

## 🎓 학습 자료

- [Supabase CLI 공식 문서](https://supabase.com/docs/guides/cli)
- [Database Migrations 가이드](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [RLS (Row Level Security) 가이드](https://supabase.com/docs/guides/auth/row-level-security)

## 🤝 팀 협업

새로운 팀원이 프로젝트에 합류할 때:

```bash
# 1. 저장소 클론
git clone <repository_url>

# 2. 의존성 설치
npm install
flutter pub get

# 3. .env 파일 생성 (팀에게 받기)
cp .env.example .env
# SUPABASE_ACCESS_TOKEN 추가

# 4. Supabase 연결 (이미 설정됨)
npm run sb:link

# 5. Migration 동기화 (자동)
# 이미 로컬 migration 파일이 있으므로 자동 동기화됨
```

---

**Remember**:
```
"모든 DB 변경은 Migration으로!"
"AI가 자동으로 처리하므로 요구사항만 명확히!"
```

**문서 작성**: 2026-03-29
**최종 업데이트**: 2026-03-29
