/**
 * PlanCalculator - 플랜 계산 로직
 *
 * 일일 말씀 플랜에서 오늘 읽을 구절/장 계산 및
 * 다음 날 위치 계산
 */

import { DailyVersePlan, VerseRange, ChapterRange } from './types.ts';
import {
  getMaxVerseInChapter,
  getMaxChapterInBook,
  getNextBook,
} from './bible-metadata.ts';

export class PlanCalculator {
  /**
   * 절 단위 플랜: 오늘 읽을 구절 범위 계산
   *
   * @param plan 일일 말씀 플랜
   * @returns 구절 범위
   *
   * @example
   * // 창1:10에서 5절씩 읽는 플랜
   * const range = calculator.calculateVerseRange({
   *   current_book: "창",
   *   current_chapter: 1,
   *   current_verse: 10,
   *   daily_amount: 5,
   *   daily_amount_type: "verse",
   *   ...
   * });
   * // 결과: { book: "창", chapter: 1, verseStart: 10, verseEnd: 14 }
   */
  calculateVerseRange(plan: DailyVersePlan): VerseRange {
    const { current_book, current_chapter, current_verse, daily_amount } = plan;

    // 1. 오늘 읽을 범위 계산
    const startVerse = current_verse;
    let endVerse = current_verse + daily_amount - 1;

    // 2. 장 최대 절 수 확인
    const maxVerse = getMaxVerseInChapter(current_book, current_chapter);

    if (maxVerse === 0) {
      throw new Error(
        `잘못된 성경 참조: ${current_book}${current_chapter}장이 존재하지 않습니다.`
      );
    }

    // 3. 범위 조정 (장 경계를 넘지 않음)
    if (endVerse > maxVerse) {
      endVerse = maxVerse;
      console.log(
        `📖 ${current_book}${current_chapter}장 끝 도달: ${startVerse}절-${endVerse}절`
      );
    }

    return {
      book: current_book,
      chapter: current_chapter,
      verseStart: startVerse,
      verseEnd: endVerse,
    };
  }

  /**
   * 장 단위 플랜: 오늘 읽을 장 범위 계산
   *
   * @param plan 일일 말씀 플랜
   * @returns 장 범위
   *
   * @example
   * // 창1장에서 3장씩 읽는 플랜
   * const range = calculator.calculateChapterRange({
   *   current_book: "창",
   *   current_chapter: 1,
   *   daily_amount: 3,
   *   daily_amount_type: "chapter",
   *   ...
   * });
   * // 결과: { book: "창", chapterStart: 1, chapterEnd: 3 }
   */
  calculateChapterRange(plan: DailyVersePlan): ChapterRange {
    const { current_book, current_chapter, daily_amount } = plan;

    // 1. 오늘 읽을 장 범위 계산
    const startChapter = current_chapter;
    let endChapter = current_chapter + daily_amount - 1;

    // 2. 책 최대 장 수 확인
    const maxChapter = getMaxChapterInBook(current_book);

    if (maxChapter === 0) {
      throw new Error(
        `잘못된 성경책: ${current_book}이(가) 존재하지 않습니다.`
      );
    }

    // 3. 범위 조정 (책 경계를 넘지 않음)
    if (endChapter > maxChapter) {
      endChapter = maxChapter;
      console.log(
        `📖 ${current_book} 끝 도달: ${startChapter}장-${endChapter}장`
      );
    }

    return {
      book: current_book,
      chapterStart: startChapter,
      chapterEnd: endChapter,
    };
  }

  /**
   * 절 단위: 다음 날 위치 계산
   *
   * 오늘 읽은 구절 다음부터 시작하도록 계산
   * 장/책 경계를 넘을 경우 자동으로 다음 장/책으로 이동
   *
   * @param plan 현재 플랜
   * @param todayRange 오늘 읽은 구절 범위
   * @returns 업데이트할 플랜 필드 (Partial)
   *
   * @example
   * // 창1:28-31절을 읽었고, 창1장은 31절까지 (끝)
   * const nextPosition = calculator.calculateNextPositionForVerse(plan, {
   *   book: "창", chapter: 1, verseStart: 28, verseEnd: 31
   * });
   * // 결과: { current_book: "창", current_chapter: 2, current_verse: 1 }
   */
  calculateNextPositionForVerse(
    plan: DailyVersePlan,
    todayRange: VerseRange
  ): Partial<DailyVersePlan> {
    const { current_book, current_chapter } = plan;

    // 1. 다음 절 계산
    let nextVerse = todayRange.verseEnd + 1;
    let nextChapter = current_chapter;
    let nextBook = current_book;

    // 2. 장 넘김 체크
    const maxVerse = getMaxVerseInChapter(current_book, current_chapter);
    if (nextVerse > maxVerse) {
      // 다음 장으로 이동
      nextVerse = 1;
      nextChapter++;

      // 3. 책 넘김 체크
      const maxChapter = getMaxChapterInBook(current_book);
      if (nextChapter > maxChapter) {
        // 다음 책으로 이동
        nextChapter = 1;
        nextBook = getNextBook(current_book);

        console.log(
          `📖 ${current_book} 완독! 다음 책: ${nextBook}`
        );
      }
    }

    return {
      current_book: nextBook,
      current_chapter: nextChapter,
      current_verse: nextVerse,
    };
  }

  /**
   * 장 단위: 다음 날 위치 계산
   *
   * 오늘 읽은 장 다음부터 시작하도록 계산
   * 책 경계를 넘을 경우 자동으로 다음 책으로 이동
   *
   * @param plan 현재 플랜
   * @param todayRange 오늘 읽은 장 범위
   * @returns 업데이트할 플랜 필드 (Partial)
   *
   * @example
   * // 창48-50장을 읽었고, 창세기는 50장까지 (끝)
   * const nextPosition = calculator.calculateNextPositionForChapter(plan, {
   *   book: "창", chapterStart: 48, chapterEnd: 50
   * });
   * // 결과: { current_book: "출", current_chapter: 1, current_verse: 1 }
   */
  calculateNextPositionForChapter(
    plan: DailyVersePlan,
    todayRange: ChapterRange
  ): Partial<DailyVersePlan> {
    const { current_book } = plan;

    // 1. 다음 장 계산
    let nextChapter = todayRange.chapterEnd + 1;
    let nextBook = current_book;

    // 2. 책 넘김 체크
    const maxChapter = getMaxChapterInBook(current_book);
    if (nextChapter > maxChapter) {
      // 다음 책으로 이동
      nextChapter = 1;
      nextBook = getNextBook(current_book);

      console.log(
        `📖 ${current_book} 완독! 다음 책: ${nextBook}`
      );
    }

    return {
      current_book: nextBook,
      current_chapter: nextChapter,
      current_verse: 1, // 장 단위는 항상 1절부터 시작
    };
  }

  /**
   * 플랜이 유효한지 검증
   *
   * @param plan 검증할 플랜
   * @returns 유효 여부 및 에러 메시지
   */
  validatePlan(
    plan: DailyVersePlan
  ): { isValid: boolean; error?: string } {
    // 1. 책 존재 여부
    const maxChapter = getMaxChapterInBook(plan.current_book);
    if (maxChapter === 0) {
      return {
        isValid: false,
        error: `알 수 없는 성경책: ${plan.current_book}`,
      };
    }

    // 2. 장 범위 확인
    if (plan.current_chapter < 1 || plan.current_chapter > maxChapter) {
      return {
        isValid: false,
        error: `잘못된 장 번호: ${plan.current_book}${plan.current_chapter}장 (최대 ${maxChapter}장)`,
      };
    }

    // 3. 절 범위 확인
    const maxVerse = getMaxVerseInChapter(
      plan.current_book,
      plan.current_chapter
    );
    if (plan.current_verse < 1 || plan.current_verse > maxVerse) {
      return {
        isValid: false,
        error: `잘못된 절 번호: ${plan.current_book}${plan.current_chapter}:${plan.current_verse} (최대 ${maxVerse}절)`,
      };
    }

    // 4. 분량 타입 확인
    if (
      plan.daily_amount_type !== 'verse' &&
      plan.daily_amount_type !== 'chapter'
    ) {
      return {
        isValid: false,
        error: `잘못된 분량 타입: ${plan.daily_amount_type} (verse 또는 chapter만 허용)`,
      };
    }

    // 5. 분량 값 확인
    if (plan.daily_amount < 1) {
      return {
        isValid: false,
        error: `분량은 1 이상이어야 합니다: ${plan.daily_amount}`,
      };
    }

    return { isValid: true };
  }
}
