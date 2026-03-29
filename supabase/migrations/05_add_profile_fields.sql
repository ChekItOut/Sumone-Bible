-- 마이그레이션: 사용자 프로필 필드 추가
-- 작성일: 2026-03-29
-- 설명: users 테이블에 프로필 사진, 생년월일, 관계 시작일, 결혼일 필드 추가

-- 1. 프로필 이미지 URL 컬럼 추가
ALTER TABLE users
ADD COLUMN IF NOT EXISTS profile_image_url TEXT;

-- 2. 생년월일 컬럼 추가
ALTER TABLE users
ADD COLUMN IF NOT EXISTS birth_date DATE;

-- 3. 사귀기 시작한 날짜 컬럼 추가
ALTER TABLE users
ADD COLUMN IF NOT EXISTS relationship_start_date DATE;

-- 4. 결혼 날짜 컬럼 추가 (NULL 가능, married인 경우만)
ALTER TABLE users
ADD COLUMN IF NOT EXISTS marriage_date DATE;

-- 5. 인덱스 추가 (날짜 필드 검색 최적화)
CREATE INDEX IF NOT EXISTS idx_users_birth_date ON users(birth_date);
CREATE INDEX IF NOT EXISTS idx_users_relationship_start_date ON users(relationship_start_date);

-- 6. 코멘트 추가
COMMENT ON COLUMN users.profile_image_url IS '프로필 사진 URL (Supabase Storage)';
COMMENT ON COLUMN users.birth_date IS '사용자 생년월일';
COMMENT ON COLUMN users.relationship_start_date IS '사귀기 시작한 날짜';
COMMENT ON COLUMN users.marriage_date IS '결혼 날짜 (married인 경우만, NULL 가능)';

-- 7. 제약 조건 추가
-- 생년월일은 1950년 이후여야 함
ALTER TABLE users
ADD CONSTRAINT check_birth_date_valid
CHECK (birth_date >= '1950-01-01' AND birth_date <= CURRENT_DATE);

-- 관계 시작일은 2000년 이후여야 함
ALTER TABLE users
ADD CONSTRAINT check_relationship_start_date_valid
CHECK (relationship_start_date >= '2000-01-01' AND relationship_start_date <= CURRENT_DATE);

-- 결혼 날짜는 관계 시작일 이후여야 함 (NULL이 아닌 경우)
ALTER TABLE users
ADD CONSTRAINT check_marriage_date_after_relationship_start
CHECK (marriage_date IS NULL OR marriage_date >= relationship_start_date);

-- 8. 트리거: 결혼 날짜는 relationship_stage가 'married'인 경우에만 설정 가능
CREATE OR REPLACE FUNCTION validate_marriage_date()
RETURNS TRIGGER AS $$
BEGIN
  -- married가 아닌데 marriage_date가 설정된 경우
  IF NEW.relationship_stage != 'married' AND NEW.marriage_date IS NOT NULL THEN
    RAISE EXCEPTION 'marriage_date는 relationship_stage가 married인 경우에만 설정할 수 있습니다';
  END IF;

  -- married인데 marriage_date가 NULL인 경우 (선택사항, 경고만)
  -- IF NEW.relationship_stage = 'married' AND NEW.marriage_date IS NULL THEN
  --   RAISE WARNING 'married 상태인데 marriage_date가 설정되지 않았습니다';
  -- END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validate_marriage_date
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION validate_marriage_date();

-- 9. 마이그레이션 완료 로그
DO $$
BEGIN
  RAISE NOTICE '✅ 마이그레이션 05: 프로필 필드 추가 완료';
  RAISE NOTICE '   - profile_image_url 추가';
  RAISE NOTICE '   - birth_date 추가';
  RAISE NOTICE '   - relationship_start_date 추가';
  RAISE NOTICE '   - marriage_date 추가';
  RAISE NOTICE '   - 인덱스 및 제약 조건 추가 완료';
END $$;
