import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

/// 로컬 Bible JSON DataSource
///
/// 책임:
/// - assets/data/bible.json 파일 로드
/// - 메모리 캐싱 (Map<String, String>)
/// - 구절 조회
class LocalBibleDataSource {
  static const String _assetPath = 'assets/data/bible.json';

  Map<String, String>? _bibleData;
  bool _isInitialized = false;
  final Logger _logger = Logger();

  /// 초기화 여부
  bool get isInitialized => _isInitialized;

  /// 전체 구절 수
  int get verseCount => _bibleData?.length ?? 0;

  /// JSON 파일 로드 및 초기화
  ///
  /// 앱 시작 시 한 번만 호출
  /// 백그라운드에서 실행 권장
  ///
  /// Throws: [Exception] 파일 로드 실패 시
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.i('📖 Bible 데이터 이미 로드됨');
      return;
    }

    try {
      _logger.i('📖 Bible 데이터 로딩 시작...');
      final stopwatch = Stopwatch()..start();

      // JSON 파일 읽기
      final jsonString = await rootBundle.loadString(_assetPath);

      // JSON 파싱
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Map<String, String>으로 변환
      _bibleData = jsonData.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      stopwatch.stop();
      _isInitialized = true;

      _logger.i(
        '✅ Bible 데이터 로드 완료: ${_bibleData!.length}개 구절, '
        '소요 시간: ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e, stackTrace) {
      _logger.e('❌ Bible 데이터 로드 실패', error: e, stackTrace: stackTrace);
      throw Exception('성경 데이터를 로드할 수 없습니다: $e');
    }
  }

  /// 특정 구절 조회
  ///
  /// [key]: JSON 키 (예: "요3:16", "시23:1")
  ///
  /// Returns: 구절 텍스트 또는 null (미존재 시)
  ///
  /// Throws: [StateError] 초기화되지 않은 경우
  String? getVerse(String key) {
    _ensureInitialized();

    final verse = _bibleData![key];
    if (verse == null) {
      _logger.w('⚠️  구절을 찾을 수 없음: $key');
    }

    return verse;
  }

  /// 구절 범위 조회
  ///
  /// [keys]: JSON 키 리스트
  ///
  /// Returns: 구절 텍스트 리스트 (존재하는 것만)
  ///
  /// Throws: [StateError] 초기화되지 않은 경우
  List<String> getVerseRange(List<String> keys) {
    _ensureInitialized();

    final verses = <String>[];
    for (final key in keys) {
      final verse = _bibleData![key];
      if (verse != null) {
        verses.add(verse);
      } else {
        _logger.w('⚠️  구절을 찾을 수 없음: $key (스킵)');
      }
    }

    return verses;
  }

  /// 구절 검색 (전체 텍스트 검색)
  ///
  /// [query]: 검색어
  /// [limit]: 최대 결과 수 (기본 100)
  ///
  /// Returns: (키, 텍스트) 쌍의 리스트
  ///
  /// Throws: [StateError] 초기화되지 않은 경우
  ///
  /// NOTE: 성능 이슈 가능 (31,000개 구절 검색)
  /// 필요 시 Isolate 사용 고려
  List<MapEntry<String, String>> searchVerses(
    String query, {
    int limit = 100,
  }) {
    _ensureInitialized();

    if (query.isEmpty) return [];

    _logger.i('🔍 성경 구절 검색: "$query"');

    final results = <MapEntry<String, String>>[];
    final lowerQuery = query.toLowerCase();

    for (final entry in _bibleData!.entries) {
      if (entry.value.toLowerCase().contains(lowerQuery)) {
        results.add(entry);

        if (results.length >= limit) break;
      }
    }

    _logger.i('✅ 검색 결과: ${results.length}개');
    return results;
  }

  /// 특정 책의 모든 구절 조회
  ///
  /// [bookKey]: 책 키 (예: "요", "시", "창")
  ///
  /// Returns: 해당 책의 모든 구절 키-텍스트 쌍
  ///
  /// Throws: [StateError] 초기화되지 않은 경우
  List<MapEntry<String, String>> getBook(String bookKey) {
    _ensureInitialized();

    return _bibleData!.entries
        .where((entry) => entry.key.startsWith(bookKey))
        .toList();
  }

  /// 특정 장의 모든 구절 조회
  ///
  /// [bookKey]: 책 키 (예: "요")
  /// [chapter]: 장 번호 (예: 3)
  ///
  /// Returns: 해당 장의 모든 구절 키-텍스트 쌍
  ///
  /// Throws: [StateError] 초기화되지 않은 경우
  List<MapEntry<String, String>> getChapter(String bookKey, int chapter) {
    _ensureInitialized();

    final prefix = '$bookKey$chapter:';
    return _bibleData!.entries
        .where((entry) => entry.key.startsWith(prefix))
        .toList();
  }

  /// 초기화 확인
  void _ensureInitialized() {
    if (!_isInitialized || _bibleData == null) {
      throw StateError(
        'LocalBibleDataSource가 초기화되지 않았습니다. '
        'initialize()를 먼저 호출하세요.',
      );
    }
  }

  /// 메모리 해제 (필요 시)
  void dispose() {
    _bibleData?.clear();
    _bibleData = null;
    _isInitialized = false;
    _logger.i('📖 Bible 데이터 메모리 해제');
  }
}
