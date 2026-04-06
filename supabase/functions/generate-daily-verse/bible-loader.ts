/**
 * BibleLoader - 성경 데이터 로딩 및 조회
 *
 * Supabase Storage에서 bible.json을 다운로드하고
 * 구절 범위 또는 장 범위 조회 기능 제공
 */

import { SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { VerseRange, ChapterRange } from './types.ts';
import { getMaxVerseInChapter } from './bible-metadata.ts';

export class BibleLoader {
  private bibleData: Record<string, string> | null = null;

  /**
   * Supabase Storage에서 bible.json 로드
   *
   * @param supabase Supabase 클라이언트
   */
  async initialize(supabase: SupabaseClient): Promise<void> {
    if (this.bibleData) {
      console.log('✅ 성경 데이터 이미 초기화됨');
      return;
    }

    try {
      console.log('📖 Supabase Storage에서 bible.json 다운로드 중...');

      const { data, error } = await supabase.storage
        .from('bible-data')
        .download('bible.json');

      if (error) {
        throw new Error(`Storage 다운로드 실패: ${error.message}`);
      }

      if (!data) {
        throw new Error('bible.json 파일이 비어있습니다.');
      }

      const text = await data.text();
      this.bibleData = JSON.parse(text);

      const verseCount = Object.keys(this.bibleData).length;
      console.log(`✅ 성경 데이터 로드 완료: ${verseCount.toLocaleString()}개 구절`);
    } catch (error) {
      console.error('❌ 성경 데이터 로드 실패:', error);
      throw new Error(`BibleLoader 초기화 실패: ${error.message}`);
    }
  }

  /**
   * 구절 범위 조회 (절 단위 플랜)
   *
   * @param range 구절 범위
   * @returns 성경 구절 텍스트 (여러 절을 공백으로 연결)
   *
   * @example
   * // "창1:1-3" 조회
   * const text = bibleLoader.getVerseRange({
   *   book: "창",
   *   chapter: 1,
   *   verseStart: 1,
   *   verseEnd: 3
   * });
   * // 결과: "태초에 하나님이 천지를 창조하시니라 땅이 혼돈하고..."
   */
  getVerseRange(range: VerseRange): string {
    if (!this.bibleData) {
      throw new Error('BibleLoader가 초기화되지 않았습니다. initialize()를 먼저 호출하세요.');
    }

    const verses: string[] = [];
    const missingVerses: string[] = [];

    for (let v = range.verseStart; v <= range.verseEnd; v++) {
      const key = `${range.book}${range.chapter}:${v}`;
      const verseText = this.bibleData[key];

      if (verseText) {
        verses.push(verseText);
      } else {
        missingVerses.push(key);
      }
    }

    // 경고: 누락된 구절
    if (missingVerses.length > 0) {
      console.warn(`⚠️ 누락된 구절: ${missingVerses.join(', ')}`);
    }

    if (verses.length === 0) {
      throw new Error(`구절을 찾을 수 없습니다: ${range.book}${range.chapter}:${range.verseStart}-${range.verseEnd}`);
    }

    return verses.join(' ');
  }

  /**
   * 장 범위 조회 (장 단위 플랜)
   *
   * @param range 장 범위
   * @returns 성경 구절 텍스트 (장 전체 텍스트를 공백으로 연결)
   *
   * @example
   * // "창1-2장" 조회
   * const text = bibleLoader.getChapterRange({
   *   book: "창",
   *   chapterStart: 1,
   *   chapterEnd: 2
   * });
   */
  getChapterRange(range: ChapterRange): string {
    if (!this.bibleData) {
      throw new Error('BibleLoader가 초기화되지 않았습니다. initialize()를 먼저 호출하세요.');
    }

    const verses: string[] = [];
    let totalVerses = 0;

    for (let chapter = range.chapterStart; chapter <= range.chapterEnd; chapter++) {
      // 해당 장의 최대 절 수 가져오기
      const maxVerse = getMaxVerseInChapter(range.book, chapter);

      if (maxVerse === 0) {
        console.warn(`⚠️ ${range.book}${chapter}장을 찾을 수 없습니다.`);
        continue;
      }

      // 1절부터 마지막 절까지 조회
      for (let verse = 1; verse <= maxVerse; verse++) {
        const key = `${range.book}${chapter}:${verse}`;
        const verseText = this.bibleData[key];

        if (verseText) {
          verses.push(verseText);
          totalVerses++;
        }
      }
    }

    console.log(`📖 ${range.book}${range.chapterStart}-${range.chapterEnd}장: ${totalVerses}절 조회됨`);

    if (verses.length === 0) {
      throw new Error(`장을 찾을 수 없습니다: ${range.book}${range.chapterStart}-${range.chapterEnd}`);
    }

    return verses.join(' ');
  }

  /**
   * 특정 구절 하나만 조회
   *
   * @param book 책 이름
   * @param chapter 장 번호
   * @param verse 절 번호
   * @returns 성경 구절 텍스트
   */
  getSingleVerse(book: string, chapter: number, verse: number): string | null {
    if (!this.bibleData) {
      throw new Error('BibleLoader가 초기화되지 않았습니다.');
    }

    const key = `${book}${chapter}:${verse}`;
    return this.bibleData[key] ?? null;
  }

  /**
   * 초기화 여부 확인
   */
  isInitialized(): boolean {
    return this.bibleData !== null;
  }
}
