-- Bible SumOne 데이터베이스 테이블 생성
-- Phase 0.2: Supabase 설정
-- 실행 방법: Supabase Dashboard > SQL Editor에서 실행

-- ============================================================
-- 1. users 테이블 (Auth 확장)
-- ============================================================
-- Supabase Auth의 auth.users를 확장하는 public.users 테이블

CREATE TABLE IF NOT EXISTS public.users (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  profile_image_url TEXT,
  relationship_stage VARCHAR(20) CHECK (relationship_stage IN ('dating', 'engaged', 'married')),
  notification_time TIME DEFAULT '09:00:00',
  notification_enabled BOOLEAN DEFAULT true,
  bible_translation VARCHAR(20) DEFAULT 'KRV',
  theme VARCHAR(10) DEFAULT 'light',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- 2. couples 테이블
-- ============================================================

CREATE TABLE IF NOT EXISTS couples (
  couple_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user1_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  user2_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  relationship_stage VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user1_id, user2_id)
);

-- ============================================================
-- 3. daily_verses 테이블
-- ============================================================

CREATE TABLE IF NOT EXISTS daily_verses (
  verse_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  date DATE UNIQUE NOT NULL,
  bible_book VARCHAR(50) NOT NULL,
  chapter INT NOT NULL,
  verse_start INT NOT NULL,
  verse_end INT,
  text_korean TEXT NOT NULL,
  text_english TEXT,
  question_korean TEXT NOT NULL,
  question_english TEXT,
  topic VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- 4. responses 테이블
-- ============================================================

CREATE TABLE IF NOT EXISTS responses (
  response_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  verse_id UUID REFERENCES daily_verses(verse_id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  couple_id UUID REFERENCES couples(couple_id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_submitted BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(verse_id, user_id)
);

-- ============================================================
-- 5. daily_progress 테이블
-- ============================================================

CREATE TABLE IF NOT EXISTS daily_progress (
  progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  couple_id UUID REFERENCES couples(couple_id) ON DELETE CASCADE,
  verse_id UUID REFERENCES daily_verses(verse_id) ON DELETE CASCADE,
  date DATE NOT NULL,
  user1_submitted BOOLEAN DEFAULT false,
  user2_submitted BOOLEAN DEFAULT false,
  both_completed_at TIMESTAMP,
  UNIQUE(couple_id, date)
);

-- ============================================================
-- 6. streaks 테이블
-- ============================================================

CREATE TABLE IF NOT EXISTS streaks (
  couple_id UUID PRIMARY KEY REFERENCES couples(couple_id) ON DELETE CASCADE,
  current_streak INT DEFAULT 0,
  longest_streak INT DEFAULT 0,
  last_completed_date DATE,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- 7. bible_cache 테이블
-- ============================================================

CREATE TABLE IF NOT EXISTS bible_cache (
  cache_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference VARCHAR(100) NOT NULL,
  translation VARCHAR(20) NOT NULL,
  text TEXT NOT NULL,
  cached_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(reference, translation)
);

-- ============================================================
-- 8. invite_links 테이블 (파트너 초대)
-- ============================================================

CREATE TABLE IF NOT EXISTS invite_links (
  invite_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  inviter_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
  token VARCHAR(50) UNIQUE NOT NULL,
  is_used BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP DEFAULT NOW() + INTERVAL '7 days'
);

-- ============================================================
-- 인덱스 생성 (성능 최적화)
-- ============================================================

-- daily_verses: 날짜 조회 최적화
CREATE INDEX IF NOT EXISTS idx_daily_verses_date ON daily_verses(date);

-- responses: 사용자별 조회 최적화
CREATE INDEX IF NOT EXISTS idx_responses_user_id ON responses(user_id);
CREATE INDEX IF NOT EXISTS idx_responses_verse_id ON responses(verse_id);

-- daily_progress: 커플 및 날짜 조회 최적화
CREATE INDEX IF NOT EXISTS idx_daily_progress_couple_date ON daily_progress(couple_id, date);

-- invite_links: 토큰 조회 최적화
CREATE INDEX IF NOT EXISTS idx_invite_links_token ON invite_links(token);
