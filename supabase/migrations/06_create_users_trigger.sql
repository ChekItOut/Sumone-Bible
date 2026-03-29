-- Bible SumOne - auth.users 생성 시 public.users 자동 생성 트리거
-- Phase 0: 인증 시스템 개선
-- 목적: 회원가입/로그인 시 public.users 테이블에 자동으로 프로필 레코드 생성

-- ============================================================
-- 1. 트리거 함수: handle_new_user()
-- ============================================================
-- auth.users에 새 사용자 생성 시 호출되는 함수
-- Google OAuth의 경우 raw_user_meta_data에 name, avatar_url 존재
-- 이메일 가입의 경우 기본값 사용

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- public.users에 기본 프로필 레코드 생성
  INSERT INTO public.users (
    user_id,
    name,
    profile_image_url,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    -- Google OAuth: raw_user_meta_data->>'name' 사용
    -- 이메일 가입: 'User' 기본값 (온보딩에서 변경 가능)
    COALESCE(NEW.raw_user_meta_data->>'name', 'User'),
    -- Google OAuth: avatar_url 사용
    -- 이메일 가입: NULL (온보딩에서 업로드 가능)
    NEW.raw_user_meta_data->>'avatar_url',
    NOW(),
    NOW()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 2. 트리거 생성: on_auth_user_created
-- ============================================================
-- auth.users에 INSERT 발생 시 handle_new_user() 실행

-- 기존 트리거가 있으면 삭제
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 새 트리거 생성
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- 3. 설명 (주석)
-- ============================================================
-- 이 트리거는 다음 시나리오에서 작동합니다:
--
-- 1. 이메일 회원가입:
--    auth.users (id, email) 생성
--    → public.users (user_id, name='User') 자동 생성
--
-- 2. Google OAuth 로그인:
--    auth.users (id, email, raw_user_meta_data->'name') 생성
--    → public.users (user_id, name=구글이름, profile_image_url) 자동 생성
--
-- 3. 온보딩:
--    사용자가 프로필 설정 화면에서 이름, 관계 단계 등을 입력
--    → public.users UPDATE (name, relationship_stage, ...)
--
-- 주의사항:
-- - relationship_stage는 NULL로 시작 (온보딩에서 설정)
-- - notification_time 등은 기본값 사용 (테이블 정의에 DEFAULT 존재)
-- - RLS 정책은 02_setup_rls.sql에서 이미 설정됨
