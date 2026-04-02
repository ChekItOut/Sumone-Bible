-- question_reviews 테이블 생성
-- 목회자 검토 시스템 (베타 테스트용)

CREATE TABLE IF NOT EXISTS question_reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- 성경 구절 정보
  verse_id TEXT NOT NULL,

  -- 생성된 질문
  question TEXT NOT NULL,

  -- 생성 방법
  generation_method TEXT NOT NULL CHECK (generation_method IN ('gemini_full', 'gemini_key', 'template')),

  -- 검토 상태
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),

  -- 검토자 정보
  reviewer_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,

  -- 피드백
  feedback TEXT,

  -- 메타데이터
  metadata JSONB DEFAULT '{}'::jsonb,

  -- 타임스탬프
  submitted_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  reviewed_at TIMESTAMP WITH TIME ZONE,

  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX idx_question_reviews_verse_id ON question_reviews(verse_id);
CREATE INDEX idx_question_reviews_status ON question_reviews(status);
CREATE INDEX idx_question_reviews_submitted_at ON question_reviews(submitted_at DESC);

-- RLS 활성화
ALTER TABLE question_reviews ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 모든 사용자는 승인된 질문 조회 가능
CREATE POLICY "Anyone can view approved questions"
ON question_reviews FOR SELECT
USING (status = 'approved');

-- RLS 정책: 인증된 사용자는 검토 제출 가능
CREATE POLICY "Authenticated users can submit for review"
ON question_reviews FOR INSERT
TO authenticated
WITH CHECK (true);

-- RLS 정책: 목회자/관리자만 검토 가능
-- NOTE: 추후 역할 기반 권한으로 변경
CREATE POLICY "Reviewers can update reviews"
ON question_reviews FOR UPDATE
TO authenticated
USING (true)  -- 일단 모든 인증 사용자 허용 (베타 테스트)
WITH CHECK (true);

-- 업데이트 트리거
CREATE OR REPLACE FUNCTION update_question_reviews_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_question_reviews_updated_at
BEFORE UPDATE ON question_reviews
FOR EACH ROW
EXECUTE FUNCTION update_question_reviews_updated_at();

-- 코멘트
COMMENT ON TABLE question_reviews IS '목회자 검토 시스템 (베타 테스트용)';
COMMENT ON COLUMN question_reviews.verse_id IS '성경 구절 ID';
COMMENT ON COLUMN question_reviews.question IS '생성된 질문';
COMMENT ON COLUMN question_reviews.generation_method IS '생성 방법 (gemini_full, gemini_key, template)';
COMMENT ON COLUMN question_reviews.status IS '검토 상태 (pending, approved, rejected)';
COMMENT ON COLUMN question_reviews.reviewer_id IS '검토자 ID';
COMMENT ON COLUMN question_reviews.feedback IS '검토자 피드백';
COMMENT ON COLUMN question_reviews.metadata IS '추가 메타데이터 (JSON)';
