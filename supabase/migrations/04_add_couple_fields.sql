-- Bible SumOne 커플 매칭 시스템 필드 추가
-- Phase 1.3: 커플 매칭 시스템
-- 실행 방법: Supabase Dashboard > SQL Editor에서 실행

-- ============================================================
-- 1. users 테이블에 couple_id 컬럼 추가
-- ============================================================

-- couple_id 컬럼 추가 (nullable, 연결되지 않은 사용자는 NULL)
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS couple_id UUID REFERENCES couples(couple_id) ON DELETE SET NULL;

-- couple_id 인덱스 생성 (조회 성능 최적화)
CREATE INDEX IF NOT EXISTS idx_users_couple_id ON public.users(couple_id);

-- ============================================================
-- 2. couples 테이블에 daily_verse_plan 컬럼 추가
-- ============================================================

-- daily_verse_plan JSONB 컬럼 추가 (nullable, 플랜 미설정 시 NULL)
-- 구조: {
--   "startBook": "창세기",
--   "dailyAmount": 3,
--   "dailyAmountType": "verse",
--   "currentBook": "창세기",
--   "currentChapter": 1,
--   "currentVerse": 1,
--   "startedAt": "2026-03-29T00:00:00Z"
-- }
ALTER TABLE couples
ADD COLUMN IF NOT EXISTS daily_verse_plan JSONB;

-- daily_verse_plan 인덱스 생성 (JSONB 필드 검색 최적화)
CREATE INDEX IF NOT EXISTS idx_couples_daily_verse_plan ON couples USING GIN(daily_verse_plan);

-- ============================================================
-- 3. couples 테이블 RLS 정책 업데이트 (업데이트 권한 추가)
-- ============================================================

-- 기존 정책이 있으면 삭제 후 재생성
DROP POLICY IF EXISTS "Users can update own couple" ON couples;

-- 커플 업데이트 (플랜 설정, 진행 상황 업데이트 등)
CREATE POLICY "Users can update own couple"
ON couples FOR UPDATE
USING (
  auth.uid() = user1_id OR auth.uid() = user2_id
)
WITH CHECK (
  auth.uid() = user1_id OR auth.uid() = user2_id
);

-- 커플 삭제 (연결 해제)
CREATE POLICY "Users can delete own couple"
ON couples FOR DELETE
USING (
  auth.uid() = user1_id OR auth.uid() = user2_id
);

-- ============================================================
-- 4. users 테이블 RLS 정책 업데이트 (couple_id 업데이트 허용)
-- ============================================================

-- 기존 "Users can update own profile" 정책은 이미 couple_id 업데이트 허용
-- (auth.uid() = user_id 조건이면 모든 컬럼 업데이트 가능)

-- ============================================================
-- 완료 메시지
-- ============================================================

DO $$
BEGIN
  RAISE NOTICE '✅ 커플 매칭 시스템 필드 추가 완료!';
  RAISE NOTICE '✅ users.couple_id 컬럼 추가';
  RAISE NOTICE '✅ couples.daily_verse_plan JSONB 컬럼 추가';
  RAISE NOTICE '✅ RLS 정책 업데이트 완료';
END $$;
