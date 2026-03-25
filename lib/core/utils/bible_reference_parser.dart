/// 성경 참조 파서
///
/// 한글 참조를 JSON 키로 변환
/// 예: "요한복음 3:16" → "요3:16"
class BibleReferenceParser {
  /// 한글 책 이름 → JSON 키 접두사 매핑
  ///
  /// bible.json의 실제 키 형식에 맞춤
  static const Map<String, String> bookNameMap = {
    // 구약 - 모세오경
    '창세기': '창',
    '출애굽기': '출',
    '레위기': '레',
    '민수기': '민',
    '신명기': '신',

    // 구약 - 역사서
    '여호수아': '수',
    '사사기': '삿',
    '룻기': '룻',
    '사무엘상': '삼상',
    '사무엘하': '삼하',
    '열왕기상': '왕상',
    '열왕기하': '왕하',
    '역대상': '대상',
    '역대하': '대하',
    '에스라': '스',
    '느헤미야': '느',
    '에스더': '에',

    // 구약 - 시가서
    '욥기': '욥',
    '시편': '시',
    '잠언': '잠',
    '전도서': '전',
    '아가': '아',

    // 구약 - 예언서 (대선지서)
    '이사야': '사',
    '예레미야': '렘',
    '예레미야애가': '애',
    '에스겔': '겔',
    '다니엘': '단',

    // 구약 - 예언서 (소선지서)
    '호세아': '호',
    '요엘': '욜',
    '아모스': '암',
    '오바댜': '옵',
    '요나': '욘',
    '미가': '미',
    '나훔': '나',
    '하박국': '합',
    '스바냐': '습',
    '학개': '학',
    '스가랴': '슥',
    '말라기': '말',

    // 신약 - 복음서
    '마태복음': '마',
    '마가복음': '막',
    '누가복음': '눅',
    '요한복음': '요',

    // 신약 - 역사서
    '사도행전': '행',

    // 신약 - 바울서신
    '로마서': '롬',
    '고린도전서': '고전',
    '고린도후서': '고후',
    '갈라디아서': '갈',
    '에베소서': '엡',
    '빌립보서': '빌',
    '골로새서': '골',
    '데살로니가전서': '살전',
    '데살로니가후서': '살후',
    '디모데전서': '딤전',
    '디모데후서': '딤후',
    '디도서': '딛',
    '빌레몬서': '몬',

    // 신약 - 일반서신
    '히브리서': '히',
    '야고보서': '약',
    '베드로전서': '벧전',
    '베드로후서': '벧후',
    '요한일서': '요일',
    '요한이서': '요이',
    '요한삼서': '요삼',
    '유다서': '유',

    // 신약 - 예언서
    '요한계시록': '계',
  };

  /// 역 매핑 (JSON 키 → 한글 이름)
  static final Map<String, String> keyToBookName = {
    for (var entry in bookNameMap.entries) entry.value: entry.key,
  };

  /// 한글 참조 → JSON 키 변환
  ///
  /// 예:
  /// - "요한복음 3:16" → "요3:16"
  /// - "시편 23:1" → "시23:1"
  /// - "고린도전서 13:4" → "고전13:4"
  ///
  /// Returns: JSON 키 또는 null (변환 실패 시)
  static String? parse(String reference) {
    try {
      // "요한복음 3:16" 형식 파싱
      final regex = RegExp(r'^(.+?)\s+(\d+):(\d+)$');
      final match = regex.firstMatch(reference.trim());

      if (match == null) return null;

      final bookName = match.group(1)!;
      final chapter = match.group(2)!;
      final verse = match.group(3)!;

      final bookKey = bookNameMap[bookName];
      if (bookKey == null) return null;

      return '$bookKey$chapter:$verse';
    } catch (e) {
      return null;
    }
  }

  /// 구절 범위 파싱
  ///
  /// 예:
  /// - "요한복음 3:16-17" → ["요3:16", "요3:17"]
  /// - "시편 23:1-6" → ["시23:1", "시23:2", ..., "시23:6"]
  ///
  /// Returns: JSON 키 리스트 또는 null (변환 실패 시)
  static List<String>? parseRange(String reference) {
    try {
      // "요한복음 3:16-17" 형식 파싱
      final regex = RegExp(r'^(.+?)\s+(\d+):(\d+)-(\d+)$');
      final match = regex.firstMatch(reference.trim());

      if (match == null) return null;

      final bookName = match.group(1)!;
      final chapter = match.group(2)!;
      final startVerse = int.parse(match.group(3)!);
      final endVerse = int.parse(match.group(4)!);

      final bookKey = bookNameMap[bookName];
      if (bookKey == null) return null;

      if (startVerse > endVerse) return null;

      final keys = <String>[];
      for (var verse = startVerse; verse <= endVerse; verse++) {
        keys.add('$bookKey$chapter:$verse');
      }

      return keys;
    } catch (e) {
      return null;
    }
  }

  /// JSON 키 → 한글 참조 변환
  ///
  /// 예: "요3:16" → "요한복음 3:16"
  ///
  /// Returns: 한글 참조 또는 null (변환 실패 시)
  static String? toKoreanReference(String key) {
    try {
      // "요3:16" 형식 파싱
      final regex = RegExp(r'^([가-힣]+)(\d+):(\d+)$');
      final match = regex.firstMatch(key.trim());

      if (match == null) return null;

      final bookKey = match.group(1)!;
      final chapter = match.group(2)!;
      final verse = match.group(3)!;

      final bookName = keyToBookName[bookKey];
      if (bookName == null) return null;

      return '$bookName $chapter:$verse';
    } catch (e) {
      return null;
    }
  }

  /// 책 이름 검색
  ///
  /// 예: "요" → ["요한복음", "요엘", "요나", "요한일서", "요한이서", "요한삼서", "요한계시록"]
  ///
  /// Returns: 매칭되는 책 이름 리스트
  static List<String> searchBookNames(String query) {
    if (query.isEmpty) return [];

    return bookNameMap.keys.where((name) => name.contains(query)).toList()
      ..sort();
  }

  /// 모든 책 이름 목록
  static List<String> getAllBookNames() {
    return bookNameMap.keys.toList()..sort();
  }

  /// 책 이름이 유효한지 확인
  static bool isValidBookName(String bookName) {
    return bookNameMap.containsKey(bookName);
  }

  /// JSON 키가 유효한지 확인
  static bool isValidKey(String key) {
    final regex = RegExp(r'^[가-힣]+\d+:\d+$');
    return regex.hasMatch(key);
  }
}
