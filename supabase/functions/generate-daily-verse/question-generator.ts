/**
 * QuestionGenerator - AI 질문 생성
 *
 * Gemini API를 사용하여 성경 구절 기반 커플 대화 질문 생성
 * 하이브리드 전략: 분량에 따라 API 호출 또는 템플릿 사용
 */

import { GeminiResponse } from './types.ts';

export class QuestionGenerator {
  private apiKey: string;
  private readonly API_TIMEOUT = 10000; // 10초
  private readonly MAX_RETRIES = 3;

  constructor(apiKey: string) {
    if (!apiKey) {
      throw new Error('GEMINI_API_KEY가 설정되지 않았습니다.');
    }
    this.apiKey = apiKey;
  }

  /**
   * 하이브리드 전략: 분량별 처리
   *
   * - 5절 이하: 전체 텍스트 → Gemini API
   * - 6-50절: 핵심 구절 추출 → Gemini API
   * - 51절 이상: 템플릿 질문 (API 호출 없음)
   *
   * @param verseText 성경 구절 텍스트
   * @param relationshipStage 커플 관계 단계
   * @returns 생성된 질문
   */
  async generateQuestion(
    verseText: string,
    relationshipStage: string
  ): Promise<string> {
    const verseCount = this.estimateVerseCount(verseText);

    console.log(`🤖 질문 생성: ${verseCount}절 (전략 선택 중...)`);

    // 1. 5절 이하: 전체 텍스트 → Gemini
    if (verseCount <= 5) {
      console.log('   전략: 전체 텍스트 → Gemini API');
      return await this.callGeminiAPI(verseText, relationshipStage);
    }

    // 2. 6-50절: 핵심 구절 추출 → Gemini
    if (verseCount <= 50) {
      console.log('   전략: 핵심 구절 추출 → Gemini API');
      const keyText = this.extractKeyVerses(verseText, 5);
      return await this.callGeminiAPI(keyText, relationshipStage);
    }

    // 3. 51절 이상: 템플릿 질문 (API 호출 없음)
    console.log('   전략: 템플릿 질문 (API 호출 생략)');
    return this.getTemplateQuestion(relationshipStage);
  }

  /**
   * Gemini API 호출 (재시도 로직 포함)
   *
   * @param verseText 성경 구절 텍스트
   * @param relationshipStage 커플 관계 단계
   * @param retries 재시도 횟수
   * @returns 생성된 질문
   */
  private async callGeminiAPI(
    verseText: string,
    relationshipStage: string,
    retries = this.MAX_RETRIES
  ): Promise<string> {
    for (let attempt = 1; attempt <= retries; attempt++) {
      try {
        const prompt = this.buildPrompt(verseText, relationshipStage);
        const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${this.apiKey}`;

        // Timeout 설정
        const controller = new AbortController();
        const timeout = setTimeout(() => controller.abort(), this.API_TIMEOUT);

        const response = await fetch(url, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }],
            generationConfig: {
              temperature: 0.7,
              topP: 0.9,
              topK: 40,
              maxOutputTokens: 200,
            },
          }),
          signal: controller.signal,
        });

        clearTimeout(timeout);

        if (!response.ok) {
          // 할당량 초과 (429)
          if (response.status === 429) {
            throw new Error('Gemini API 할당량 초과 (429)');
          }
          throw new Error(`Gemini API 오류: ${response.status}`);
        }

        const data: GeminiResponse = await response.json();
        const question = this.parseResponse(data);

        console.log(`✅ Gemini API 성공: "${question.substring(0, 30)}..."`);
        return question;
      } catch (error) {
        console.error(
          `❌ Gemini API 호출 실패 (시도 ${attempt}/${retries}):`,
          error.message
        );

        // 최종 실패 시 템플릿 질문 반환
        if (attempt === retries) {
          console.warn('⚠️ Gemini API 최종 실패, 템플릿 질문 사용');
          return this.getTemplateQuestion(relationshipStage);
        }

        // 재시도 대기 (1초, 2초, 3초)
        await this.sleep(1000 * attempt);
      }
    }

    // Fallback (도달하지 않지만 TypeScript 만족을 위해)
    return this.getTemplateQuestion(relationshipStage);
  }

  /**
   * 프롬프트 생성
   *
   * lib/data/datasources/gemini_api_datasource.dart와 동일한 프롬프트 사용
   */
  private buildPrompt(verseText: string, relationshipStage: string): string {
    const stageContext: Record<string, string> = {
      'dating': '연애 중인',
      'engaged': '약혼한',
      'married': '결혼한',
    };

    const context = stageContext[relationshipStage] ?? '크리스천';

    return `
당신은 크리스천 커플을 위한 성경 공부 가이드입니다.

성경 구절:
${verseText}

커플 상태: ${context} 커플

위 말씀을 읽은 커플이 서로 나눌 수 있는 대화 질문 1개를 생성하세요.

요구사항:
1. 커플의 관계에 직접 적용 가능해야 함
2. 너무 무겁지 않고 자연스러운 대화 유도
3. "서로" 나눌 수 있는 질문 (한 사람만 답하는 것 X)
4. 50자 이내
5. 질문 형식으로 끝나야 함 (물음표 필수)

출력 형식:
[질문 내용만 출력, 추가 설명 없이]

예시:
- 이 말씀이 우리의 관계에 어떤 의미가 있을까요?
- 우리가 이 말씀을 실천하려면 무엇을 바꿔야 할까요?
- 이 말씀을 통해 서로에게 어떤 사랑을 보여줄 수 있을까요?
`;
  }

  /**
   * Gemini 응답 파싱
   *
   * @param data Gemini API 응답
   * @returns 파싱된 질문 텍스트
   */
  private parseResponse(data: GeminiResponse): string {
    const text = data?.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!text) {
      throw new Error('Gemini 응답에 text가 없습니다.');
    }

    // 정제: 따옴표, 별표, 개행 제거
    return text
      .replaceAll('"', '')
      .replaceAll('*', '')
      .replaceAll('\n', ' ')
      .trim();
  }

  /**
   * 구절 개수 추정 (휴리스틱)
   *
   * 문장 부호(. ! ?)로 대략적으로 추정
   */
  private estimateVerseCount(verseText: string): number {
    const sentences = verseText
      .split(/[.!?]/)
      .filter((s) => s.trim().length > 0);
    return Math.max(sentences.length, 1);
  }

  /**
   * 핵심 구절 추출 (간단한 휴리스틱)
   *
   * 전체 텍스트를 균등하게 샘플링하여 핵심 구절 추출
   *
   * @param verseText 전체 성경 구절 텍스트
   * @param count 추출할 구절 개수
   * @returns 핵심 구절 텍스트
   */
  private extractKeyVerses(verseText: string, count: number): string {
    const sentences = verseText
      .split(/[.!?]/)
      .filter((s) => s.trim().length > 0);

    if (sentences.length <= count) {
      return verseText; // 전체 반환
    }

    const step = Math.floor(sentences.length / count);
    const keyVerses: string[] = [];

    for (let i = 0; i < count && i * step < sentences.length; i++) {
      keyVerses.push(sentences[i * step].trim());
    }

    return keyVerses.join('. ') + '.';
  }

  /**
   * 템플릿 질문 (Fallback)
   *
   * Gemini API 실패 또는 51절 이상 장문일 때 사용
   */
  private getTemplateQuestion(relationshipStage: string): string {
    const templates: Record<string, string> = {
      'dating': '오늘 말씀에서 우리 관계에 적용할 수 있는 교훈이 있을까요?',
      'engaged': '결혼 준비 과정에서 이 말씀을 어떻게 실천할 수 있을까요?',
      'married': '부부로서 이 말씀을 일상에서 어떻게 살아낼 수 있을까요?',
    };

    return templates[relationshipStage] ?? '오늘 말씀이 우리에게 주는 메시지는 무엇일까요?';
  }

  /**
   * Sleep 유틸리티
   */
  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
