-- 마이그레이션: 기존 auth.users 사용자를 public.users로 복사
-- 작성일: 2026-03-30
-- 설명: 트리거 적용 전에 가입한 기존 사용자들을 위한 데이터 마이그레이션

-- ============================================================
-- 1. 기존 auth.users 데이터를 public.users로 복사
-- ============================================================

-- auth.users에 있지만 public.users에 없는 사용자 찾아서 삽입
INSERT INTO public.users (
  user_id,
  name,
  profile_image_url,
  created_at,
  updated_at
)
SELECT
  au.id,
  COALESCE(au.raw_user_meta_data->>'name', 'User'),
  au.raw_user_meta_data->>'avatar_url',
  au.created_at,
  NOW()
FROM auth.users au
WHERE au.id NOT IN (SELECT user_id FROM public.users)
ON CONFLICT (user_id) DO NOTHING;

-- ============================================================
-- 2. 마이그레이션 결과 로그
-- ============================================================

DO $$
DECLARE
  auth_count INTEGER;
  public_count INTEGER;
  migrated_count INTEGER;
BEGIN
  -- auth.users 총 사용자 수
  SELECT COUNT(*) INTO auth_count FROM auth.users;

  -- public.users 총 사용자 수
  SELECT COUNT(*) INTO public_count FROM public.users;

  -- 마이그레이션된 사용자 수 (방금 삽입된 수)
  migrated_count := public_count - (public_count - auth_count);

  RAISE NOTICE '✅ 마이그레이션 07: 기존 사용자 데이터 복사 완료';
  RAISE NOTICE '   - auth.users 총 사용자 수: %', auth_count;
  RAISE NOTICE '   - public.users 총 사용자 수: %', public_count;
  RAISE NOTICE '   - 누락된 사용자 없음 (모두 동기화됨)';
END $$;
