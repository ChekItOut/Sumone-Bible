-- Migration: 사용자 테이블에 gender 컬럼 추가
-- Date: 2026-03-24
-- Description: 프로필 설정 시 성별 정보를 입력받을 수 있도록 gender 컬럼 추가

-- users 테이블에 gender 컬럼 추가
ALTER TABLE public.users
ADD COLUMN gender VARCHAR(10) CHECK (gender IN ('male', 'female'));

-- 컬럼 설명 추가 (문서화)
COMMENT ON COLUMN public.users.gender IS '사용자 성별 (male: 남성, female: 여성)';
