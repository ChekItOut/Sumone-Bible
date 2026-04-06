/**
 * Supabase Edge Function: generate-daily-verse
 *
 * 매일 UTC 15:00 (KST 00:00)에 실행되어:
 * 1. 모든 커플의 daily_verse_plan 조회
 * 2. 플랜에 따라 오늘 읽을 성경 구절 선택
 * 3. Gemini API로 AI 질문 생성
 * 4. daily_verses 테이블에 INSERT
 * 5. daily_progress 테이블 초기화
 * 6. 커플 플랜 진행 상황 업데이트
 *
 * 실행 방법:
 * - Cron Job (자동): 매일 UTC 15:00
 * - 수동 호출: curl POST /functions/v1/generate-daily-verse
 */

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

import { Couple, DailyVersePlan, GenerationResult } from './types.ts';
import { BibleLoader } from './bible-loader.ts';
import { PlanCalculator } from './plan-calculator.ts';
import { QuestionGenerator } from './question-generator.ts';
import { DBUpdater } from './db-updater.ts';

serve(async (req) => {
  try {
    console.log('🚀 generate-daily-verse Edge Function 시작');

    // 1. 환경 변수 검증
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    const geminiApiKey = Deno.env.get('GEMINI_API_KEY');

    if (!supabaseUrl || !supabaseKey || !geminiApiKey) {
      throw new Error(
        '환경 변수 누락: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, GEMINI_API_KEY를 확인하세요.'
      );
    }

    const supabase = createClient(supabaseUrl, supabaseKey);

    // 2. 오늘 날짜 (UTC)
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
    console.log(`📅 오늘 날짜: ${today} (UTC)`);

    // 3. 이미 생성되었는지 확인 (중복 실행 방지)
    const dbUpdater = new DBUpdater(supabase);
    const alreadyExists = await dbUpdater.checkDailyVerseExists(today);

    if (alreadyExists) {
      console.log('✅ 오늘 날짜의 말씀이 이미 생성되어 있습니다. 종료합니다.');
      return new Response(
        JSON.stringify({ message: 'Already generated for today' }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        }
      );
    }

    // 4. 플랜이 있는 커플 조회
    const couples = await dbUpdater.getCouplesWithPlan();
    console.log(`👥 플랜이 있는 커플: ${couples.length}명`);

    if (couples.length === 0) {
      console.log('⚠️ 플랜이 있는 커플이 없습니다. 종료합니다.');
      return new Response(
        JSON.stringify({
          date: today,
          total: 0,
          success: 0,
          fail: 0,
          message: 'No couples with plan',
        }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        }
      );
    }

    // 5. Bible JSON 초기화 (한 번만)
    const bibleLoader = new BibleLoader();
    await bibleLoader.initialize(supabase);

    // 6. 각 커플별 말씀 생성
    const questionGenerator = new QuestionGenerator(geminiApiKey);
    const planCalculator = new PlanCalculator();

    let successCount = 0;
    let failCount = 0;
    const errors: string[] = [];

    for (const couple of couples as Couple[]) {
      try {
        console.log(`\n🔄 커플 처리 시작: ${couple.couple_id}`);

        await generateVerseForCouple(
          couple,
          today,
          bibleLoader,
          planCalculator,
          questionGenerator,
          dbUpdater
        );

        successCount++;
        console.log(`✅ 커플 처리 완료: ${couple.couple_id}`);
      } catch (error) {
        console.error(`❌ 커플 처리 실패: ${couple.couple_id}`, error);
        failCount++;
        errors.push(`${couple.couple_id}: ${error.message}`);
      }
    }

    // 7. 결과 반환
    const result: GenerationResult = {
      date: today,
      total: couples.length,
      success: successCount,
      fail: failCount,
      errors: errors.length > 0 ? errors : undefined,
    };

    console.log('\n🎉 Edge Function 완료');
    console.log(`   - 성공: ${successCount}`);
    console.log(`   - 실패: ${failCount}`);

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('❌ Edge Function 실행 실패:', error);

    return new Response(
      JSON.stringify({
        error: error.message,
        stack: error.stack,
      }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
});

/**
 * 커플별 말씀 생성 처리
 */
async function generateVerseForCouple(
  couple: Couple,
  today: string,
  bibleLoader: BibleLoader,
  planCalculator: PlanCalculator,
  questionGenerator: QuestionGenerator,
  dbUpdater: DBUpdater
) {
  const plan = couple.daily_verse_plan!;

  // 1. 플랜 검증
  const validation = planCalculator.validatePlan(plan);
  if (!validation.isValid) {
    throw new Error(`플랜 검증 실패: ${validation.error}`);
  }

  console.log(
    `   📖 현재 위치: ${plan.current_book}${plan.current_chapter}:${plan.current_verse} (${plan.daily_amount_type}: ${plan.daily_amount})`
  );

  // 2. 오늘 읽을 구절/장 계산
  const isVerse = plan.daily_amount_type === 'verse';
  const verseRange = isVerse
    ? planCalculator.calculateVerseRange(plan)
    : null;
  const chapterRange = !isVerse
    ? planCalculator.calculateChapterRange(plan)
    : null;

  // 3. 성경 구절 조회
  const verseText = isVerse
    ? bibleLoader.getVerseRange(verseRange!)
    : bibleLoader.getChapterRange(chapterRange!);

  console.log(`   📖 구절 조회 완료: ${verseText.length}자`);

  // 4. AI 질문 생성
  const question = await questionGenerator.generateQuestion(
    verseText,
    couple.relationship_stage
  );

  console.log(`   🤖 질문 생성 완료: "${question}"`);

  // 5. daily_verses 저장
  const verseInsert = {
    date: today,
    bible_book: verseRange?.book ?? chapterRange!.book,
    chapter: verseRange?.chapter ?? chapterRange!.chapterStart,
    verse_start: verseRange?.verseStart ?? 1,
    verse_end: verseRange?.verseEnd ?? 1,
    text_korean: verseText,
    question_korean: question,
  };

  const verseId = await dbUpdater.saveDailyVerse(verseInsert);

  if (!verseId) {
    console.log('   ⚠️ daily_verses 이미 존재, 스킵');
    return; // 이미 존재하면 스킵
  }

  // 6. daily_progress 생성
  await dbUpdater.initializeDailyProgress(couple.couple_id, verseId, today);

  // 7. 플랜 업데이트 (다음 날 위치)
  const nextPosition = isVerse
    ? planCalculator.calculateNextPositionForVerse(plan, verseRange!)
    : planCalculator.calculateNextPositionForChapter(plan, chapterRange!);

  await dbUpdater.updateCouplePlan(couple.couple_id, nextPosition);

  console.log(
    `   ✅ 다음 위치: ${nextPosition.current_book}${nextPosition.current_chapter}:${nextPosition.current_verse}`
  );
}

console.log('✅ Edge Function 등록 완료: generate-daily-verse');
