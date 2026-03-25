# Bible 아키텍처 설계 (로컬 JSON 기반)

**작성일**: 2026-03-25
**결정**: 로컬 JSON 파일 사용 (Supabase/API 대신)

---

## 1. 변경 사유

### 기존 계획 (API.Bible)
- ❌ 주로 영어 성경
- ❌ 한국어 지원 미흡
- ❌ 네트워크 의존
- ❌ Rate limit 존재
- ❌ API 키 필요

### 새로운 계획 (로컬 JSON)
- ✅ 한글 성경 (개역개정) 완비
- ✅ 오프라인 지원
- ✅ Rate limit 없음
- ✅ 비용 0원
- ✅ 즉시 로딩

---

## 2. 파일 정보

**위치**: `docs/bible/bible.json`
**크기**: 4.9MB
**줄 수**: 31,090줄

**구조**:
```json
{
  "창1:1": " 태초에 하나님이 천지를 창조하시니라",
  "창1:2": "땅이 혼돈하고 공허하며...",
  "요3:16": "하나님이 세상을 이처럼 사랑하사...",
  ...
}
```

**Key 형식**:
- 구약: `창1:1`, `출20:3`, `시23:1`
- 신약: `마5:3`, `요3:16`, `롬8:28`

---

## 3. 아키텍처

### 3.1 레이어 구조

```
┌─────────────────────────────────────┐
│     Presentation Layer              │
│  (UI, Providers, Screens)           │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│     Domain Layer                    │
│  (Entities, Use Cases)              │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│     Data Layer                      │
│  (Repository, DataSource, Models)   │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│     Local Storage                   │
│  (assets/data/bible.json)           │
└─────────────────────────────────────┘
```

### 3.2 클래스 다이어그램

```
BibleVerse (Entity)
    ↑
    │ (toEntity)
    │
BibleVerseModel (Model)
    ↑
    │ (fromJson)
    │
BibleRepository (Interface)
    ↑
    │ (implements)
    │
BibleRepositoryImpl
    ↓ (uses)
LocalBibleDataSource
    ↓ (reads)
bible.json
```

---

## 4. 구현 계획

### Phase 1: 파일 이동 및 설정
- [ ] `docs/bible/bible.json` → `assets/data/bible.json`
- [ ] `pubspec.yaml`에 assets 등록
- [ ] 파일 로드 테스트

### Phase 2: DataSource 구현
- [ ] `LocalBibleDataSource` 클래스 생성
- [ ] JSON 파일 읽기 메서드
- [ ] 메모리 캐싱 (Map<String, String>)
- [ ] 구절 조회 메서드

### Phase 3: Repository 구현
- [ ] `BibleRepository` 인터페이스
- [ ] `BibleRepositoryImpl` 구현
- [ ] 참조 파싱 ("요한복음 3:16" → "요3:16")
- [ ] 구절 범위 조회 ("시23:1-6")

### Phase 4: Utility 구현
- [ ] `BibleReferenceParser` (한글 → Key 변환)
- [ ] 책 이름 매핑 (요한복음 → 요, 고린도전서 → 고전)

### Phase 5: 테스트
- [ ] Unit 테스트 (DataSource)
- [ ] Integration 테스트 (Repository)
- [ ] 성능 테스트 (로딩 시간)

---

## 5. 상세 설계

### 5.1 LocalBibleDataSource

**책임**:
- JSON 파일 읽기
- 메모리 캐싱
- 구절 조회

**메서드**:
```dart
class LocalBibleDataSource {
  Map<String, String>? _bibleData;

  // JSON 파일 로드 (앱 시작 시 1회)
  Future<void> initialize();

  // 특정 구절 조회
  String? getVerse(String reference);

  // 구절 범위 조회
  List<String> getVerseRange(String startRef, String endRef);

  // 검색 (선택)
  List<String> searchVerses(String query);
}
```

### 5.2 BibleRepository

**책임**:
- 참조 파싱
- Domain Entity 변환
- 에러 핸들링

**메서드**:
```dart
abstract class BibleRepository {
  // "요한복음 3:16" → BibleVerse
  Future<BibleVerse> getVerse(String reference);

  // "시편 23:1-6" → List<BibleVerse>
  Future<List<BibleVerse>> getVerseRange(String reference);

  // "요" → List<String> (책 이름 목록)
  List<String> searchBookNames(String query);
}
```

### 5.3 BibleReferenceParser

**책임**:
- 한글 참조 → Key 변환
- 책 이름 정규화

**매핑 테이블**:
```dart
const bookNameMap = {
  // 구약
  '창세기': '창',
  '출애굽기': '출',
  '시편': '시',

  // 신약
  '마태복음': '마',
  '요한복음': '요',
  '고린도전서': '고전',
  '고린도후서': '고후',
  ...
};
```

**변환 예시**:
```dart
"요한복음 3:16" → "요3:16"
"시편 23:1" → "시23:1"
"고린도전서 13:4-7" → ["고전13:4", "고전13:5", ...]
```

---

## 6. 성능 고려사항

### 6.1 메모리 사용

**JSON 파일**: 4.9MB
**파싱 후 Map**: ~10MB (예상)

**해결책**:
- 앱 시작 시 백그라운드에서 로드
- 로딩 스피너 표시
- 이후 메모리에 유지 (재로드 불필요)

### 6.2 로딩 시간

**예상 시간**:
- JSON 파일 읽기: ~100ms
- JSON 파싱: ~200ms
- **총 ~300ms** (충분히 빠름)

**최적화**:
- 필요 시 Isolate 사용 (백그라운드 스레드)
- 점진적 로딩 (필요한 책만 먼저 로드)

### 6.3 검색

**방법 1: 전체 검색 (단순)**
```dart
_bibleData.entries
  .where((entry) => entry.value.contains(query))
  .toList();
```

**방법 2: 인덱싱 (고급)**
- 앱 시작 시 역인덱스 생성
- 단어 → 구절 매핑
- 빠른 검색 (선택 사항)

---

## 7. 에러 핸들링

### 7.1 파일 없음
```dart
if (!await file.exists()) {
  throw BibleDataNotFoundException();
}
```

### 7.2 파싱 실패
```dart
try {
  final data = json.decode(content);
} catch (e) {
  throw BibleDataCorruptedException();
}
```

### 7.3 구절 없음
```dart
if (!_bibleData.containsKey(key)) {
  throw VerseNotFoundException(reference);
}
```

---

## 8. 향후 확장 (선택)

### 8.1 다른 번역 추가
- `bible_niv.json` (NIV)
- `bible_nkrv.json` (새번역)

### 8.2 북마크
- Supabase에 사용자별 북마크 저장

### 8.3 검색 기능
- 전문 검색 (Full-text search)
- 역인덱스 구축

### 8.4 오프라인 동기화
- Supabase에 사용자 데이터만 동기화
- 성경 텍스트는 로컬 유지

---

## 9. 장단점 요약

### 장점
- ✅ 오프라인 지원 100%
- ✅ 즉시 로딩 (API 대기 없음)
- ✅ 비용 0원
- ✅ Rate limit 없음
- ✅ 단순한 구현
- ✅ 한글 성경 완비

### 단점
- ⚠️ APK 크기 +4.9MB (허용 가능)
- ⚠️ 업데이트 시 앱 재배포 (하지만 거의 안 함)

---

## 10. 결론

**로컬 JSON 접근이 MVP에 최적**입니다.

**이유**:
1. 제품 특성 (오프라인 사용)
2. 단순성 (빠른 검증)
3. 성능 (즉시 로딩)
4. 비용 (무료)
5. 안정성 (외부 의존 없음)

---

**작성자**: Claude Code
**승인**: Product Team
**상태**: Approved ✅
