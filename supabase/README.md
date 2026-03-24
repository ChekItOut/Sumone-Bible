# Supabase 설정 가이드

## 📋 개요

Bible SumOne 앱의 Supabase 백엔드 설정 및 마이그레이션 파일입니다.

---

## 🚀 빠른 시작 (Quick Start)

### 1. Supabase 프로젝트 생성 ✅

이미 완료하셨습니다:
- Project URL: `https://gtpzucliwqrrfcecsgzb.supabase.co`
- Publishable Key: `.env` 파일에 저장됨

### 2. 데이터베이스 테이블 생성

**중요: 순서대로 실행해야 합니다!**

#### Step 1: 테이블 생성

1. Supabase Dashboard 접속: https://supabase.com/dashboard
2. 왼쪽 메뉴 **SQL Editor** 클릭
3. **"New query"** 클릭
4. `supabase/migrations/01_create_tables.sql` 파일 내용을 복사해서 붙여넣기
5. **"Run"** 버튼 클릭 (또는 Ctrl+Enter)
6. ✅ Success 메시지 확인

#### Step 2: RLS 정책 설정

1. 같은 SQL Editor에서 **"New query"** 다시 클릭
2. `supabase/migrations/02_setup_rls.sql` 파일 내용을 복사해서 붙여넣기
3. **"Run"** 버튼 클릭
4. ✅ "RLS 정책 설정 완료!" 메시지 확인

---

## 📊 생성되는 테이블

| 테이블 | 설명 | 주요 필드 |
|--------|------|-----------|
| **users** | 사용자 프로필 | user_id, name, relationship_stage |
| **couples** | 커플 정보 | couple_id, user1_id, user2_id |
| **daily_verses** | 일일 말씀 | verse_id, date, text_korean, question_korean |
| **responses** | 답변 | response_id, user_id, content, is_submitted |
| **daily_progress** | 일일 진행 상황 | couple_id, date, user1_submitted, user2_submitted |
| **streaks** | 스트릭 기록 | couple_id, current_streak, longest_streak |
| **bible_cache** | 성경 구절 캐시 | reference, translation, text |
| **invite_links** | 초대 링크 | token, inviter_id, expires_at |

---

## 🔒 보안 (RLS 정책)

### 주요 정책

**users 테이블**:
- ✅ 자신의 프로필만 조회/수정 가능

**responses 테이블**:
- ✅ 자신과 파트너의 답변만 조회 가능
- ✅ 자신의 답변만 작성/수정/삭제 가능

**couples 테이블**:
- ✅ 자신이 속한 커플 정보만 조회 가능

**daily_verses & bible_cache**:
- ✅ 모든 인증된 사용자가 읽기 가능
- ❌ 쓰기는 서버(Edge Function)에서만 가능

---

## 🧪 테스트

### 테이블 생성 확인

1. Supabase Dashboard → **Table Editor** 클릭
2. 다음 테이블들이 보이는지 확인:
   - users
   - couples
   - daily_verses
   - responses
   - daily_progress
   - streaks
   - bible_cache
   - invite_links

### RLS 정책 확인

1. **Table Editor** → `users` 테이블 클릭
2. 우측 상단 **"RLS is enabled"** 배지 확인 ✅
3. **"View Policies"** 클릭하여 정책 확인

---

## 🔧 문제 해결 (Troubleshooting)

### SQL 실행 오류

**문제**: `relation "uuid_generate_v4" does not exist`
**해결**: SQL Editor에서 다음 명령어 먼저 실행
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

**문제**: `permission denied for table XXX`
**해결**:
1. 올바른 프로젝트에 로그인했는지 확인
2. Dashboard 우측 상단에서 프로젝트명 확인

**문제**: 테이블이 이미 존재한다는 오류
**해결**: 정상입니다! `IF NOT EXISTS`로 안전하게 처리됩니다.

---

## 📚 다음 단계

SQL 실행 완료 후:

1. ✅ Flutter 앱 실행: `flutter run`
2. ✅ Supabase 연결 테스트 (Phase 1에서 진행)
3. ✅ 회원가입/로그인 구현 (Phase 1.1)

---

## 🆘 도움이 필요하신가요?

- Supabase 공식 문서: https://supabase.com/docs
- RLS 가이드: https://supabase.com/docs/guides/auth/row-level-security
- Bible SumOne 프로젝트 문서: `docs/prd.md`, `docs/roadmap.md`

---

**작성일**: 2026-03-24
**Phase**: 0.2 - Supabase 설정
**상태**: ✅ 완료
