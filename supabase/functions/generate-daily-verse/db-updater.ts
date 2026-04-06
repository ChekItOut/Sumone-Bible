/**
 * DBUpdater - 데이터베이스 업데이트
 *
 * daily_verses, daily_progress INSERT 및 couples 플랜 업데이트
 */

import { SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2';
import {
  DailyVersePlan,
  DailyVerseInsert,
  DailyProgressInsert,
} from './types.ts';

export class DBUpdater {
  constructor(private supabase: SupabaseClient) {}

  /**
   * daily_verses 저장
   *
   * @param params 저장할 데이터
   * @returns verse_id (이미 존재하면 빈 문자열)
   */
  async saveDailyVerse(params: DailyVerseInsert): Promise<string> {
    try {
      const { data, error } = await this.supabase
        .from('daily_verses')
        .insert({
          date: params.date,
          bible_book: params.bible_book,
          chapter: params.chapter,
          verse_start: params.verse_start,
          verse_end: params.verse_end,
          text_korean: params.text_korean,
          question_korean: params.question_korean,
          topic: params.topic,
        })
        .select('verse_id')
        .single();

      if (error) {
        // UNIQUE 제약 위반 (이미 존재)
        if (error.code === '23505') {
          console.warn(
            `⚠️ daily_verses 이미 존재: ${params.date} / ${params.bible_book}${params.chapter}`
          );
          return ''; // 스킵
        }

        throw new Error(`daily_verses INSERT 실패: ${error.message}`);
      }

      if (!data) {
        throw new Error('daily_verses INSERT 성공했으나 verse_id가 없습니다.');
      }

      console.log(
        `✅ daily_verses 저장: ${params.bible_book}${params.chapter}:${params.verse_start}-${params.verse_end} (ID: ${data.verse_id})`
      );

      return data.verse_id;
    } catch (error) {
      console.error('❌ saveDailyVerse 실패:', error);
      throw error;
    }
  }

  /**
   * daily_progress 초기화
   *
   * @param couple_id 커플 ID
   * @param verse_id 말씀 ID
   * @param date 날짜 (YYYY-MM-DD)
   */
  async initializeDailyProgress(
    couple_id: string,
    verse_id: string,
    date: string
  ): Promise<void> {
    try {
      const progressData: DailyProgressInsert = {
        couple_id,
        verse_id,
        date,
        user1_submitted: false,
        user2_submitted: false,
      };

      const { error } = await this.supabase
        .from('daily_progress')
        .insert(progressData);

      if (error) {
        // UNIQUE 제약 위반 무시
        if (error.code === '23505') {
          console.warn(
            `⚠️ daily_progress 이미 존재: ${couple_id} / ${date}`
          );
          return;
        }

        throw new Error(`daily_progress INSERT 실패: ${error.message}`);
      }

      console.log(`✅ daily_progress 생성: ${couple_id} / ${date}`);
    } catch (error) {
      console.error('❌ initializeDailyProgress 실패:', error);
      throw error;
    }
  }

  /**
   * 커플 플랜 업데이트 (다음 날 위치)
   *
   * @param couple_id 커플 ID
   * @param updatedFields 업데이트할 필드 (Partial)
   */
  async updateCouplePlan(
    couple_id: string,
    updatedFields: Partial<DailyVersePlan>
  ): Promise<void> {
    try {
      // 1. 현재 플랜 조회
      const { data: couple, error: fetchError } = await this.supabase
        .from('couples')
        .select('daily_verse_plan')
        .eq('couple_id', couple_id)
        .single();

      if (fetchError) {
        throw new Error(`커플 조회 실패: ${fetchError.message}`);
      }

      if (!couple || !couple.daily_verse_plan) {
        throw new Error(
          `커플 플랜이 없습니다: ${couple_id}`
        );
      }

      // 2. 플랜 병합
      const currentPlan = couple.daily_verse_plan as DailyVersePlan;
      const newPlan: DailyVersePlan = {
        ...currentPlan,
        ...updatedFields,
      };

      // 3. 업데이트
      const { error: updateError } = await this.supabase
        .from('couples')
        .update({ daily_verse_plan: newPlan })
        .eq('couple_id', couple_id);

      if (updateError) {
        throw new Error(`플랜 업데이트 실패: ${updateError.message}`);
      }

      console.log(
        `✅ 플랜 업데이트: ${couple_id} → ${newPlan.current_book}${newPlan.current_chapter}:${newPlan.current_verse}`
      );
    } catch (error) {
      console.error('❌ updateCouplePlan 실패:', error);
      throw error;
    }
  }

  /**
   * 오늘 daily_verses가 이미 존재하는지 확인
   *
   * @param date 날짜 (YYYY-MM-DD)
   * @returns 존재 여부
   */
  async checkDailyVerseExists(date: string): Promise<boolean> {
    try {
      const { data, error } = await this.supabase
        .from('daily_verses')
        .select('verse_id')
        .eq('date', date)
        .limit(1);

      if (error) {
        throw new Error(`daily_verses 존재 확인 실패: ${error.message}`);
      }

      return (data && data.length > 0) ?? false;
    } catch (error) {
      console.error('❌ checkDailyVerseExists 실패:', error);
      return false;
    }
  }

  /**
   * 플랜이 있는 모든 커플 조회
   *
   * @returns 커플 목록
   */
  async getCouplesWithPlan(): Promise<any[]> {
    try {
      const { data, error } = await this.supabase
        .from('couples')
        .select('couple_id, user1_id, user2_id, relationship_stage, daily_verse_plan')
        .not('daily_verse_plan', 'is', null);

      if (error) {
        throw new Error(`커플 조회 실패: ${error.message}`);
      }

      return data ?? [];
    } catch (error) {
      console.error('❌ getCouplesWithPlan 실패:', error);
      throw error;
    }
  }
}
