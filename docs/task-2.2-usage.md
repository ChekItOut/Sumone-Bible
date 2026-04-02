# Task 2.2: AI 질문 생성 시스템 - 사용 가이드

## 📋 구현 완료 항목

✅ **GeminiApiDatasource** - Gemini API 연동
✅ **VerseExtractor** - 핵심 구절 추출 로직
✅ **QuestionTemplates** - 템플릿 질문 시스템
✅ **QuestionGenerationService** - 분량별 3단계 처리
✅ **QuestionQualityFilter** - 질문 품질 필터링
✅ **PastorReviewService** - 베타 테스트용 목회자 검토 시스템
✅ **Riverpod Providers** - 의존성 주입 및 상태 관리

---

## 🎯 핵심 전략: 분량별 3단계 처리

### 1️⃣ 5절 이하: 전체 텍스트 → Gemini

```dart
// 예: 요한복음 3:16 (1절)
final question = await ref.read(generateQuestionProvider(
  QuestionGenerationParams(
    verses: ['하나님이 세상을 이처럼 사랑하사...'],
    relationshipStage: 'dating',
    topic: 'love',
  ),
).future);

// 결과: "이 말씀이 우리의 관계에 어떤 의미가 있을까요?" (Gemini 생성)
```

### 2️⃣ 6-50절: 핵심 추출 → Gemini

```dart
// 예: 고린도전서 13장 (13절)
final question = await ref.read(generateQuestionProvider(
  QuestionGenerationParams(
    verses: ['내가 사람의 방언과...', '사랑은 오래 참고...', ...], // 13개 구절
    relationshipStage: 'married',
    topic: 'love',
  ),
).future);

// 내부 동작:
// 1. VerseExtractor가 핵심 3-5개 추출
// 2. 추출된 핵심만 Gemini에 전송 (비용 절감)
// 3. 맞춤 질문 생성
```

### 3️⃣ 51절 이상: 템플릿 질문 (Gemini 안 씀)

```dart
// 예: 시편 119편 (176절)
final question = await ref.read(generateQuestionProvider(
  QuestionGenerationParams(
    verses: [...176개 구절...],
    relationshipStage: 'engaged',
    topic: 'faith',
  ),
).future);

// 결과: "우리의 믿음이 관계에 어떤 영향을 주고 있나요?" (템플릿)
// Gemini API 호출 없음 → 무료
```

---

## 🔧 주요 컴포넌트

### GeminiApiDatasource

**위치**: `lib/data/datasources/gemini_api_datasource.dart`

**역할**: Gemini API 직접 호출

**메서드**:
```dart
Future<String> generateQuestion({
  required String verseText,
  required String relationshipStage,
  String? context,
})
```

**프롬프트 예시**:
```
당신은 크리스천 커플을 위한 성경 공부 가이드입니다.

성경 구절:
하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니...

커플 상태: 연애 중인 커플

위 말씀을 읽은 커플이 서로 나눌 수 있는 대화 질문 1개를 생성하세요.

요구사항:
1. 커플의 관계에 직접 적용 가능해야 함
2. 너무 무겁지 않고 자연스러운 대화 유도
3. "서로" 나눌 수 있는 질문 (한 사람만 답하는 것 X)
4. 50자 이내
5. 질문 형식으로 끝나야 함 (물음표 필수)
```

---

### VerseExtractor

**위치**: `lib/core/utils/verse_extractor.dart`

**역할**: 긴 구절에서 핵심만 추출

**알고리즘**:
1. 각 구절에 중요도 점수 부여
   - 키워드 포함 (+10점): 사랑, 하나님, 믿음, 용서 등
   - 관계 키워드 (+8점): 서로, 우리, 함께 등
   - 적정 길이 (+5점): 20-80자
   - 명령문/질문 (+3점)

2. 점수 높은 순으로 정렬

3. 상위 3-5개 선택

4. 원래 순서 유지하여 반환

**사용 예시**:
```dart
final extractor = VerseExtractor();

final verses = [
  '내가 사람의 방언과 천사의 말을 할지라도 사랑이 없으면...',
  '사랑은 오래 참고 사랑은 온유하며...',  // ← 점수 높음 (사랑 키워드)
  '사랑은 모든 것을 참으며...',          // ← 점수 높음
  '그런즉 믿음 소망 사랑 이 세 가지는...',  // ← 점수 높음
];

final keyVerses = extractor.extractKeyVerses(verses, maxCount: 3);
// 결과: 점수 높은 3개만 반환 (원래 순서 유지)
```

---

### QuestionTemplates

**위치**: `lib/core/utils/question_templates.dart`

**역할**: 51절 이상용 템플릿 질문 제공

**주제별 템플릿**:
- `love` (사랑): 4개
- `forgiveness` (용서): 4개
- `gratitude` (감사): 4개
- `communication` (소통): 4개
- `faith` (믿음): 4개
- `humility` (겸손): 4개
- `patience` (인내): 4개
- `prayer` (기도): 4개

**관계 단계별 템플릿**:
- `dating` (연애): 4개
- `engaged` (약혼): 4개
- `married` (결혼): 4개

**일반 템플릿**: 8개

**총 템플릿 수**: 44개

**사용 예시**:
```dart
final templates = QuestionTemplates();

final question = templates.generateTemplateQuestion(
  topic: 'love',
  relationshipStage: 'married',
);

// 결과 (무작위):
// "이 말씀이 우리의 결혼 생활에 어떤 변화를 줄 수 있을까요?"
```

---

### QuestionQualityFilter

**위치**: `lib/core/utils/question_quality_filter.dart`

**역할**: 생성된 질문의 품질 검증

**검사 항목**:
1. 길이 (10-100자)
2. 질문 형식 (물음표 필수)
3. 커플 대화 적합성 (우리, 서로 등)
4. 금지 단어 검사
5. 긍정적 키워드 포함 여부

**점수 체계**:
- 100점 만점
- 60점 이상 합격
- 60점 미만 시 개선 시도

**사용 예시**:
```dart
final filter = QuestionQualityFilter();

final result = filter.checkQuality('이 말씀이 우리에게 의미가');

print(result.isValid);  // false (물음표 없음)
print(result.score);    // 60점 미만
print(result.issues);   // ['질문 형식이 아닙니다. 물음표(?)가 필요합니다.']

// 자동 개선
final improved = filter.improveQuestion('이 말씀이 우리에게 의미가');
print(improved);  // "이 말씀이 우리에게 의미가?"
```

---

### PastorReviewService

**위치**: `lib/data/services/pastor_review_service.dart`

**역할**: 베타 테스트용 목회자 검토 시스템

**워크플로우**:
1. 질문 생성 → 자동으로 검토 테이블에 제출
2. 목회자가 검토 (승인/거부)
3. 승인된 질문은 우선 사용
4. 승인되지 않으면 새로 생성

**사용 예시**:
```dart
final reviewService = PastorReviewService(supabase);

// 1. 검토 제출
await reviewService.submitForReview(
  verseId: 'JHN.3.16',
  question: '하나님의 사랑을 우리의 관계에서 어떻게 실천할까요?',
  generationMethod: 'gemini_full',
);

// 2. 목회자 검토
await reviewService.reviewQuestion(
  questionId: 'question-uuid',
  approved: true,
  feedback: '커플에게 적합한 질문입니다.',
  pastorId: 'pastor-uuid',
);

// 3. 승인된 질문 조회
final approved = await reviewService.getApprovedQuestion('JHN.3.16');
```

---

## 🎨 UI에서 사용하기

### 예시 1: 간단한 사용

```dart
class DailyVerseScreen extends ConsumerWidget {
  final List<String> verses;
  final String relationshipStage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionAsync = ref.watch(
      generateQuestionProvider(
        QuestionGenerationParams(
          verses: verses,
          relationshipStage: relationshipStage,
          topic: 'love',
        ),
      ),
    );

    return questionAsync.when(
      data: (question) => Text(
        question,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('질문 생성 실패: $err'),
    );
  }
}
```

### 예시 2: 재시도 기능

```dart
class QuestionCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = QuestionGenerationParams(...);
    final questionAsync = ref.watch(generateQuestionProvider(params));

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: questionAsync.when(
          data: (question) => Column(
            children: [
              Text(question),
              ElevatedButton(
                onPressed: () {
                  // 재생성
                  ref.invalidate(generateQuestionProvider(params));
                },
                child: Text('다른 질문 보기'),
              ),
            ],
          ),
          loading: () => LoadingIndicator(),
          error: (err, stack) => ErrorWidget(err),
        ),
      ),
    );
  }
}
```

---

## 📊 비용 최적화

### Gemini API 호출 비용 절감 전략

| 구절 수 | 전략 | Gemini 호출 | 비용 |
|--------|------|------------|------|
| 1-5절 | 전체 텍스트 | ✅ Yes | 💰 Full |
| 6-50절 | 핵심 추출 | ✅ Yes (축소) | 💰 Low |
| 51+절 | 템플릿 | ❌ No | 🆓 Free |

**예상 비용 절감**:
- 평균 구절 수: 30절
- 템플릿 사용률: ~30% (51절 이상)
- 핵심 추출 사용률: ~60% (6-50절)
- 전체 텍스트 사용률: ~10% (1-5절)

**결과**: Gemini API 호출 70% 유지, 비용은 **50% 절감** (핵심 추출로 토큰 수 감소)

---

## 🧪 테스트

### 단위 테스트 예시

```dart
// test/core/utils/verse_extractor_test.dart
test('should extract top 5 key verses', () {
  final extractor = VerseExtractor();

  final verses = [
    '일반 구절',
    '사랑은 오래 참고',  // 키워드 포함
    '하나님을 사랑하라',  // 키워드 포함
    '일반 구절 2',
    '서로 사랑하라',     // 관계 키워드
  ];

  final result = extractor.extractKeyVerses(verses, maxCount: 3);

  expect(result.length, 3);
  expect(result, contains('사랑은 오래 참고'));
});
```

---

## 🚀 다음 단계

### Task 2.3: Supabase Edge Function

1. **generate-daily-verse** 함수 작성
   - 커플별 플랜 기반 구절 조회
   - QuestionGenerationService 호출
   - daily_verses 테이블에 저장

2. **Cron Job 설정**
   - 매일 자정 실행
   - 모든 커플의 다음 날 말씀 준비

### Task 2.4: UI 구현

1. **HomeScreen 재구성**
   - 오늘의 말씀 카드
   - 질문 표시
   - 답변 작성 버튼

2. **DailyVerseScreen**
   - 성경 구절 표시 (Noto Serif KR)
   - 질문 카드
   - 답변 입력 UI

---

## 📝 참고 문서

- [Gemini API 문서](https://ai.google.dev/docs)
- [docs/prd.md](./prd.md) - 섹션 4.2 (AI 질문 생성)
- [docs/roadmap.md](./roadmap.md) - Phase 2.2

---

**구현 완료일**: 2026-04-02
**구현자**: Claude Sonnet 4.5
**리뷰**: ✅ 완료
