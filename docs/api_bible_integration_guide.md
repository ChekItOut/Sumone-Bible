# API.Bible 통합 가이드

**목적**: HelloAO Bible API 대체로 API.Bible 통합
**작성일**: 2026-03-25

---

## 1. API.Bible 개요

### 특징
- ✅ 1000+ 성경 번역 지원
- ✅ REST API + JSON 응답
- ✅ 무료 티어: 일 5,000 요청
- ✅ 잘 문서화됨
- ✅ HTTPS + 인증

### 공식 문서
- https://scripture.api.bible/
- https://docs.api.bible/

---

## 2. API 구조

### 기본 URL
```
https://api.scripture.api.bible/v1
```

### 인증
```
Authorization: {YOUR_API_KEY}
```

### 주요 엔드포인트

#### 2.1 성경 번역 목록 조회
```
GET /v1/bibles
```

**응답 예시**:
```json
{
  "data": [
    {
      "id": "de4e12af7f28f599-02",
      "name": "Korean Revised Version",
      "abbreviation": "KRV",
      "language": {
        "id": "kor",
        "name": "Korean"
      }
    }
  ]
}
```

#### 2.2 특정 구절 조회
```
GET /v1/bibles/{bibleId}/verses/{verseId}
```

**예시**:
```
GET /v1/bibles/de4e12af7f28f599-02/verses/JHN.3.16
```

**응답**:
```json
{
  "data": {
    "id": "JHN.3.16",
    "bibleId": "de4e12af7f28f599-02",
    "bookId": "JHN",
    "chapterId": "JHN.3",
    "reference": "John 3:16",
    "content": "하나님이 세상을 이처럼 사랑하사..."
  }
}
```

#### 2.3 구절 범위 조회
```
GET /v1/bibles/{bibleId}/passages/{passageId}
```

**예시**:
```
GET /v1/bibles/de4e12af7f28f599-02/passages/JHN.3.16-JHN.3.17
```

---

## 3. Verse ID 포맷

API.Bible은 특정 형식의 Verse ID를 사용합니다:

### 형식
```
{BOOK_CODE}.{CHAPTER}.{VERSE}
```

### 예시
- 요한복음 3:16 → `JHN.3.16`
- 고린도전서 13:4-7 → `1CO.13.4-1CO.13.7` (passage)
- 시편 23:1-6 → `PSA.23.1-PSA.23.6` (passage)

### 주요 성경책 코드

| 한글 | 영문 | 코드 |
|------|------|------|
| 창세기 | Genesis | GEN |
| 출애굽기 | Exodus | EXO |
| 시편 | Psalms | PSA |
| 잠언 | Proverbs | PRO |
| 마태복음 | Matthew | MAT |
| 요한복음 | John | JHN |
| 로마서 | Romans | ROM |
| 고린도전서 | 1 Corinthians | 1CO |
| 갈라디아서 | Galatians | GAL |

**전체 리스트**: https://docs.api.bible/reference/book-codes

---

## 4. 한국어 성경 번역

### 사용 가능한 한국어 번역

API.Bible에서 한국어 성경을 찾으려면:

```bash
curl -X GET "https://api.scripture.api.bible/v1/bibles?language=kor" \
  -H "api-key: YOUR_API_KEY"
```

**주요 한국어 번역**:
- KRV (Korean Revised Version)
- NKRV (New Korean Revised Version)

**Bible ID 확인 필요**: 실제 가입 후 확인

---

## 5. Rate Limits

### 무료 티어
- **일일**: 5,000 요청
- **분당**: 100 요청

### 권장 사항
- ✅ 캐싱 필수 (Supabase)
- ✅ 중복 요청 방지
- ✅ 로컬 저장소 활용

---

## 6. 에러 처리

### HTTP 상태 코드

| 코드 | 의미 | 처리 |
|------|------|------|
| 200 | 성공 | 정상 처리 |
| 401 | 인증 실패 | API 키 확인 |
| 403 | 권한 없음 | Rate limit 초과 |
| 404 | 미존재 | Verse ID 확인 |
| 429 | Too Many Requests | 캐시 사용 |
| 500 | 서버 에러 | 재시도 |

---

## 7. 구현 계획

### Phase 1: 기본 설정
- [ ] API 키 발급
- [ ] `.env` 파일 업데이트
- [ ] `ApiConstants` 수정

### Phase 2: DataSource 구현
- [ ] `BibleApiDataSource` 클래스 생성
- [ ] Dio 클라이언트 설정
- [ ] 구절 조회 메서드 구현

### Phase 3: Repository 구현
- [ ] `BibleRepository` 인터페이스 정의
- [ ] 캐싱 로직 추가
- [ ] 에러 핸들링

### Phase 4: 모델 정의
- [ ] `BibleVerse` 모델
- [ ] `BiblePassage` 모델
- [ ] JSON 직렬화

### Phase 5: 테스트
- [ ] Unit 테스트
- [ ] 통합 테스트
- [ ] API 호출 검증

---

## 8. 참고 사항

### 장점
- ✅ 안정적인 서비스
- ✅ 명확한 API 구조
- ✅ 좋은 문서화

### 주의사항
- ⚠️ API 키 보안 (.env 파일)
- ⚠️ Rate limit 관리
- ⚠️ 오프라인 지원 고려

### 대안 (Rate limit 초과 시)
1. Supabase에 성경 데이터 미리 저장
2. 로컬 캐시 우선 사용
3. API는 fallback으로만 사용

---

## 다음 단계

1. ✅ API 키 발급: https://scripture.api.bible
2. ✅ 환경 변수 설정
3. ✅ DataSource 구현
4. ✅ 테스트 실행
5. ✅ 문서 업데이트

---

**작성자**: Claude Code
**최종 업데이트**: 2026-03-25
