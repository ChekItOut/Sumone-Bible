-- Bible SumOne Row Level Security (RLS) 정책 설정
-- Phase 0.2: Supabase 설정
-- 실행 방법: Supabase Dashboard > SQL Editor에서 실행
-- 주의: 01_create_tables.sql을 먼저 실행해야 합니다!

-- ============================================================
-- RLS 활성화
-- ============================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE invite_links ENABLE ROW LEVEL SECURITY;

-- daily_verses와 bible_cache는 모든 사용자가 읽을 수 있어야 함
-- 하지만 쓰기는 Edge Function에서만 (Service Role Key)

-- ============================================================
-- public.users 정책
-- ============================================================

-- 자신의 프로필 조회
CREATE POLICY "Users can view own profile"
ON public.users FOR SELECT
USING (auth.uid() = user_id);

-- 자신의 프로필 수정
CREATE POLICY "Users can update own profile"
ON public.users FOR UPDATE
USING (auth.uid() = user_id);

-- 자신의 프로필 생성 (회원가입 시)
CREATE POLICY "Users can insert own profile"
ON public.users FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- couples 정책
-- ============================================================

-- 자신이 속한 커플 정보 조회
CREATE POLICY "Users can view own couple"
ON couples FOR SELECT
USING (
  auth.uid() = user1_id OR auth.uid() = user2_id
);

-- 커플 생성 (초대 수락 시)
CREATE POLICY "Users can create couple"
ON couples FOR INSERT
WITH CHECK (
  auth.uid() = user1_id OR auth.uid() = user2_id
);

-- ============================================================
-- responses 정책
-- ============================================================

-- 자신과 파트너의 답변 조회
CREATE POLICY "Users can view own and partner responses"
ON responses FOR SELECT
USING (
  user_id = auth.uid()
  OR user_id IN (
    SELECT user1_id FROM couples WHERE user2_id = auth.uid()
    UNION
    SELECT user2_id FROM couples WHERE user1_id = auth.uid()
  )
);

-- 자신의 답변 작성
CREATE POLICY "Users can insert own responses"
ON responses FOR INSERT
WITH CHECK (user_id = auth.uid());

-- 자신의 답변 수정
CREATE POLICY "Users can update own responses"
ON responses FOR UPDATE
USING (user_id = auth.uid());

-- 자신의 답변 삭제
CREATE POLICY "Users can delete own responses"
ON responses FOR DELETE
USING (user_id = auth.uid());

-- ============================================================
-- daily_progress 정책
-- ============================================================

-- 자신이 속한 커플의 진행 상황 조회
CREATE POLICY "Users can view own couple progress"
ON daily_progress FOR SELECT
USING (
  couple_id IN (
    SELECT couple_id FROM couples
    WHERE user1_id = auth.uid() OR user2_id = auth.uid()
  )
);

-- 진행 상황 업데이트 (답변 제출 시)
CREATE POLICY "Users can update own couple progress"
ON daily_progress FOR UPDATE
USING (
  couple_id IN (
    SELECT couple_id FROM couples
    WHERE user1_id = auth.uid() OR user2_id = auth.uid()
  )
);

-- 진행 상황 생성
CREATE POLICY "Users can insert own couple progress"
ON daily_progress FOR INSERT
WITH CHECK (
  couple_id IN (
    SELECT couple_id FROM couples
    WHERE user1_id = auth.uid() OR user2_id = auth.uid()
  )
);

-- ============================================================
-- streaks 정책
-- ============================================================

-- 자신이 속한 커플의 스트릭 조회
CREATE POLICY "Users can view own couple streaks"
ON streaks FOR SELECT
USING (
  couple_id IN (
    SELECT couple_id FROM couples
    WHERE user1_id = auth.uid() OR user2_id = auth.uid()
  )
);

-- 스트릭 생성
CREATE POLICY "Users can insert own couple streaks"
ON streaks FOR INSERT
WITH CHECK (
  couple_id IN (
    SELECT couple_id FROM couples
    WHERE user1_id = auth.uid() OR user2_id = auth.uid()
  )
);

-- ============================================================
-- invite_links 정책
-- ============================================================

-- 자신이 생성한 초대 링크 조회
CREATE POLICY "Users can view own invite links"
ON invite_links FOR SELECT
USING (inviter_id = auth.uid());

-- 초대 링크 생성
CREATE POLICY "Users can create invite links"
ON invite_links FOR INSERT
WITH CHECK (inviter_id = auth.uid());

-- 초대 링크 사용 처리 (누구나 가능)
CREATE POLICY "Anyone can update invite links"
ON invite_links FOR UPDATE
USING (true);

-- ============================================================
-- daily_verses & bible_cache (읽기 전용)
-- ============================================================

-- 모든 인증된 사용자가 일일 말씀 조회 가능
ALTER TABLE daily_verses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can view daily verses"
ON daily_verses FOR SELECT
TO authenticated
USING (true);

-- 모든 인증된 사용자가 성경 캐시 조회 가능
ALTER TABLE bible_cache ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can view bible cache"
ON bible_cache FOR SELECT
TO authenticated
USING (true);

-- ============================================================
-- 완료 메시지
-- ============================================================

DO $$
BEGIN
  RAISE NOTICE '✅ RLS 정책 설정 완료!';
  RAISE NOTICE '✅ 보안 규칙이 활성화되었습니다.';
  RAISE NOTICE '✅ 사용자는 본인과 파트너의 데이터만 조회/수정할 수 있습니다.';
END $$;
