# Bible API 검증 보고서

**일시**: 2026-03-25
**검증자**: Claude Code

---

## 요약

현재 설정된 Bible API (`https://bible.helloao.org/api`)는 **작동하지 않습니다**.

## 검증 과정

### 1. 설정 확인

✅ **`.env` 파일**:
```
BIBLE_API_URL=https://bible.helloao.org/api
```

✅ **`ApiConstants` 클래스**:
```dart
static String bibleVerse({
  required String translation,
  required String book,
  required String reference,
}) {
  return '$bibleApiUrl/$translation/$book/$reference';
}
```

✅ **PRD 문서** (docs/prd.md):
```
GET https://bible.helloao.org/api/KRV/고린도전서/13:4-7
```

### 2. 실제 API 테스트

❌ **결과**: 모든 테스트 실패

**테스트 케이스 1**: `https://bible.helloao.org/api/KRV/고린도전서/13:4-7`
- 상태 코드: 200
- 응답 타입: HTML (문서 페이지)
- 에러: JSON 파싱 실패

**테스트 케이스 2**: `https://bible.helloao.org/api/KRV/요한복음/3:16`
- 상태 코드: 200
- 응답 타입: HTML (문서 페이지)
- 에러: JSON 파싱 실패

**테스트 케이스 3**: `https://bible.helloao.org/api/KRV/시편/23:1-6`
- 상태 코드: 200
- 응답 타입: HTML (문서 페이지)
- 에러: JSON 파싱 실패

### 3. 원인 분석

`https://bible.helloao.org/`는 **VuePress 문서 사이트**입니다.
- 실제 API 엔드포인트가 아님
- `/api/` 경로가 문서 페이지를 반환
- JSON 응답이 아닌 HTML 페이지 반환

## 문제

1. **API 엔드포인트 불명확**:
   - PRD에 명시된 엔드포인트가 작동하지 않음
   - 실제 API URL을 찾을 수 없음

2. **API 변경 가능성**:
   - API 구조가 변경되었을 수 있음
   - 문서화가 불완전할 수 있음

3. **대체 API 필요**:
   - 다른 Bible API 고려 필요
   - 안정적인 API 선택 필요

## 권장 사항

### 옵션 1: API.Bible 사용 (추천)

**장점**:
- ✅ 공식 Bible API 서비스
- ✅ 1000+ 성경 번역 지원
- ✅ 잘 문서화됨
- ✅ 무료 티어 제공 (일 5,000 요청)
- ✅ REST API + JSON 응답

**API 엔드포인트**:
```
https://api.scripture.api.bible/v1/bibles/{bibleId}/verses/{verseId}
```

**예시**:
```bash
curl -X GET \
  'https://api.scripture.api.bible/v1/bibles/de4e12af7f28f599-02/verses/JHN.3.16' \
  -H 'api-key: YOUR_API_KEY'
```

**한국어 성경**:
- KRV (Korean Revised Version): bibleId 필요

**단점**:
- ⚠️ API 키 필요 (무료지만 가입 필요)
- ⚠️ Rate limit 존재 (일 5,000 요청)

**참고**:
- https://scripture.api.bible/

---

### 옵션 2: BibleGateway API

**장점**:
- ✅ 다양한 번역 지원
- ✅ 한국어 포함

**단점**:
- ⚠️ 공식 API 없음 (스크래핑 필요)
- ⚠️ 안정성 낮음

---

### 옵션 3: 자체 Bible DB 구축

**장점**:
- ✅ 완전한 제어
- ✅ Rate limit 없음
- ✅ 오프라인 지원

**단점**:
- ⚠️ 초기 구축 비용 높음
- ⚠️ 저작권 확인 필요
- ⚠️ 유지보수 부담

**구현 방법**:
1. 오픈소스 성경 데이터 다운로드
   - Berean Bible (공개 도메인)
   - Korean Revised Version (저작권 확인)
2. Supabase 테이블에 저장
3. 로컬 조회

---

### 옵션 4: HelloAO Bible API 재확인

**할 일**:
1. HelloAO GitHub 레포 확인
   - https://github.com/HelloAOLab/bible-api
2. 실제 API 엔드포인트 확인
3. API 문서 읽기
4. 테스트

---

## 다음 단계

### 즉시 해야 할 일

1. **API 선택 결정**
   - 위 옵션 중 하나 선택
   - 우선순위: 안정성 > 비용 > 기능

2. **`.env` 파일 업데이트**
   - 선택한 API의 URL로 변경
   - API 키 추가 (필요 시)

3. **`ApiConstants` 수정**
   - 새로운 API 엔드포인트 형식에 맞게 수정

4. **테스트 재실행**
   - 실제 API 호출 검증
   - 응답 파싱 확인

5. **DataSource/Repository 구현**
   - `lib/data/datasources/bible_api_datasource.dart`
   - `lib/data/repositories/bible_repository.dart`
   - 캐싱 로직 추가

---

## 임시 해결책 (개발용)

개발 중에는 **하드코딩된 성경 구절**을 사용하여 다른 기능을 먼저 구현할 수 있습니다.

```dart
// lib/data/datasources/mock_bible_datasource.dart
class MockBibleDataSource {
  Future<BibleVerse> getVerse(String reference) async {
    // 하드코딩된 테스트 데이터
    return BibleVerse(
      book: '요한복음',
      chapter: 3,
      verse: 16,
      text: '하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니...',
    );
  }
}
```

---

## 결론

**현재 상태**: ❌ Bible API 작동하지 않음

**권장 조치**:
1. ✅ **즉시**: Mock 데이터로 개발 진행
2. ✅ **24시간 내**: API 옵션 결정 및 통합
3. ✅ **1주일 내**: 캐싱 및 오류 처리 구현

---

**문서 작성**: Claude Code
**최종 업데이트**: 2026-03-25
