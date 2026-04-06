/**
 * Edge Function 타입 정의
 *
 * Supabase Edge Function에서 사용하는 모든 타입 정의
 */

/**
 * 일일 말씀 플랜 (couples.daily_verse_plan JSONB)
 *
 * ⚠️ 주의: JSON 필드명은 snake_case 사용
 * (lib/data/models/daily_verse_plan_model.dart와 일치)
 */
export interface DailyVersePlan {
  start_book: string;           // 시작 성경 (예: "창", "요", "계")
  daily_amount: number;         // 하루 분량 (예: 5, 10, 1, 3)
  daily_amount_type: string;    // 분량 단위 ("verse" 또는 "chapter")
  current_book: string;         // 현재 읽는 성경
  current_chapter: number;      // 현재 읽는 장
  current_verse: number;        // 현재 읽는 절
  started_at: string;           // 플랜 시작일 (ISO 8601 형식)
}

/**
 * 커플 데이터 (couples 테이블)
 */
export interface Couple {
  couple_id: string;
  user1_id: string;
  user2_id: string;
  relationship_stage: 'dating' | 'engaged' | 'married';
  daily_verse_plan: DailyVersePlan | null;
  created_at?: string;
}

/**
 * 성경 구절 범위 (절 단위 플랜)
 */
export interface VerseRange {
  book: string;           // 책 이름 (예: "창", "요")
  chapter: number;        // 장 번호
  verseStart: number;     // 시작 절
  verseEnd: number;       // 끝 절
}

/**
 * 장 범위 (장 단위 플랜)
 */
export interface ChapterRange {
  book: string;           // 책 이름
  chapterStart: number;   // 시작 장
  chapterEnd: number;     // 끝 장
}

/**
 * daily_verses 테이블 INSERT 파라미터
 */
export interface DailyVerseInsert {
  date: string;               // YYYY-MM-DD
  bible_book: string;         // 책 이름
  chapter: number;            // 장 번호
  verse_start: number;        // 시작 절
  verse_end: number;          // 끝 절
  text_korean: string;        // 성경 구절 텍스트
  question_korean: string;    // AI 생성 질문
  topic?: string;             // 주제 (선택)
}

/**
 * daily_progress 테이블 INSERT 파라미터
 */
export interface DailyProgressInsert {
  couple_id: string;
  verse_id: string;
  date: string;               // YYYY-MM-DD
  user1_submitted: boolean;
  user2_submitted: boolean;
}

/**
 * Gemini API 응답 구조
 */
export interface GeminiResponse {
  candidates: Array<{
    content: {
      parts: Array<{
        text: string;
      }>;
    };
  }>;
}

/**
 * Edge Function 실행 결과
 */
export interface GenerationResult {
  date: string;           // 생성 날짜
  total: number;          // 총 커플 수
  success: number;        // 성공 수
  fail: number;           // 실패 수
  errors?: string[];      // 에러 메시지 (있으면)
}
