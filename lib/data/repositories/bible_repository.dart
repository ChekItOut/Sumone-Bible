import 'package:bible_sumone/core/utils/bible_reference_parser.dart';
import 'package:bible_sumone/data/datasources/local_bible_datasource.dart';
import 'package:bible_sumone/domain/entities/bible_verse.dart';
import 'package:logger/logger.dart';

/// Bible Repository
///
/// 책임:
/// - 한글 참조 파싱
/// - DataSource 호출
/// - Domain Entity 변환
/// - 에러 핸들링
class BibleRepository {
  final LocalBibleDataSource _dataSource;
  final Logger _logger = Logger();

  BibleRepository({LocalBibleDataSource? dataSource})
      : _dataSource = dataSource ?? LocalBibleDataSource();

  /// Repository 초기화
  ///
  /// 앱 시작 시 호출
  Future<void> initialize() async {
    await _dataSource.initialize();
  }

  /// 초기화 여부
  bool get isInitialized => _dataSource.isInitialized;

  /// 전체 구절 수
  int get verseCount => _dataSource.verseCount;

  /// 한글 참조로 구절 조회
  ///
  /// [reference]: 한글 참조 (예: "요한복음 3:16", "시편 23:1")
  ///
  /// Returns: [BibleVerse] 엔티티
  ///
  /// Throws:
  /// - [ArgumentError] 참조 형식이 잘못된 경우
  /// - [VerseNotFoundException] 구절을 찾을 수 없는 경우
  /// - [StateError] 초기화되지 않은 경우
  Future<BibleVerse> getVerse(String reference) async {
    try {
      _logger.i('📖 구절 조회: $reference');

      // 1. 한글 참조 파싱
      final key = BibleReferenceParser.parse(reference);
      if (key == null) {
        throw ArgumentError('잘못된 참조 형식입니다: $reference');
      }

      // 2. DataSource에서 조회
      final text = _dataSource.getVerse(key);
      if (text == null) {
        throw VerseNotFoundException(reference);
      }

      // 3. Entity 생성
      final verse = _parseKeyToVerse(key, text, reference);

      _logger.i('✅ 구절 조회 성공: $reference');
      return verse;
    } catch (e) {
      _logger.e('❌ 구절 조회 실패: $reference', error: e);
      rethrow;
    }
  }

  /// 구절 범위 조회
  ///
  /// [reference]: 한글 참조 범위 (예: "요한복음 3:16-17", "시편 23:1-6")
  ///
  /// Returns: [BibleVerse] 리스트
  ///
  /// Throws:
  /// - [ArgumentError] 참조 형식이 잘못된 경우
  /// - [StateError] 초기화되지 않은 경우
  Future<List<BibleVerse>> getVerseRange(String reference) async {
    try {
      _logger.i('📖 구절 범위 조회: $reference');

      // 1. 한글 참조 범위 파싱
      final keys = BibleReferenceParser.parseRange(reference);
      if (keys == null || keys.isEmpty) {
        throw ArgumentError('잘못된 참조 범위 형식입니다: $reference');
      }

      // 2. DataSource에서 조회
      final texts = _dataSource.getVerseRange(keys);

      // 3. Entity 리스트 생성
      final verses = <BibleVerse>[];
      for (var i = 0; i < keys.length && i < texts.length; i++) {
        final koreanRef = BibleReferenceParser.toKoreanReference(keys[i]);
        final verse = _parseKeyToVerse(
          keys[i],
          texts[i],
          koreanRef ?? keys[i],
        );
        verses.add(verse);
      }

      _logger.i('✅ 구절 범위 조회 성공: ${verses.length}개');
      return verses;
    } catch (e) {
      _logger.e('❌ 구절 범위 조회 실패: $reference', error: e);
      rethrow;
    }
  }

  /// 구절 검색
  ///
  /// [query]: 검색어
  /// [limit]: 최대 결과 수
  ///
  /// Returns: [BibleVerse] 리스트
  Future<List<BibleVerse>> searchVerses(
    String query, {
    int limit = 100,
  }) async {
    try {
      _logger.i('🔍 구절 검색: "$query"');

      final results = _dataSource.searchVerses(query, limit: limit);

      final verses = results.map((entry) {
        final koreanRef = BibleReferenceParser.toKoreanReference(entry.key);
        return _parseKeyToVerse(
          entry.key,
          entry.value,
          koreanRef ?? entry.key,
        );
      }).toList();

      _logger.i('✅ 검색 완료: ${verses.length}개 결과');
      return verses;
    } catch (e) {
      _logger.e('❌ 검색 실패', error: e);
      rethrow;
    }
  }

  /// 책 이름 검색
  ///
  /// [query]: 검색어 (예: "요", "고")
  ///
  /// Returns: 매칭되는 책 이름 리스트
  List<String> searchBookNames(String query) {
    return BibleReferenceParser.searchBookNames(query);
  }

  /// 모든 책 이름 목록
  List<String> getAllBookNames() {
    return BibleReferenceParser.getAllBookNames();
  }

  /// JSON 키 → BibleVerse Entity 변환
  BibleVerse _parseKeyToVerse(String key, String text, String reference) {
    // "요3:16" → book: "요", chapter: 3, verse: 16
    final regex = RegExp(r'^([가-힣]+)(\d+):(\d+)$');
    final match = regex.firstMatch(key);

    if (match == null) {
      throw FormatException('잘못된 키 형식: $key');
    }

    final book = match.group(1)!;
    final chapter = int.parse(match.group(2)!);
    final verse = int.parse(match.group(3)!);

    return BibleVerse(
      book: book,
      chapter: chapter,
      verse: verse,
      text: text.trim(),
      reference: reference,
    );
  }

  /// 메모리 해제
  void dispose() {
    _dataSource.dispose();
  }
}

/// 구절을 찾을 수 없음 예외
class VerseNotFoundException implements Exception {
  final String reference;

  VerseNotFoundException(this.reference);

  @override
  String toString() => '구절을 찾을 수 없습니다: $reference';
}
