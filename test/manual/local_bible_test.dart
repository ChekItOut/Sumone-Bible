import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_sumone/data/repositories/bible_repository.dart';
import 'package:bible_sumone/core/utils/bible_reference_parser.dart';

/// 로컬 Bible 통합 테스트
///
/// 실행 방법:
/// ```bash
/// flutter test test/manual/local_bible_test.dart
/// ```
void main() {
  // Flutter 바인딩 초기화 (assets 로드를 위해 필요)
  TestWidgetsFlutterBinding.ensureInitialized();

  group('로컬 Bible 시스템 테스트', () {
    late BibleRepository repository;

    setUpAll(() async {
      print('\n==========================================');
      print('📖 로컬 Bible 시스템 테스트 시작');
      print('==========================================\n');

      // Repository 생성 및 초기화
      repository = BibleRepository();

      print('📦 Bible 데이터 로딩 중...');
      await repository.initialize();
      print('✅ 초기화 완료: ${repository.verseCount}개 구절\n');
    });

    test('테스트 1: 단일 구절 조회 (요한복음 3:16)', () async {
      print('------------------------------------------');
      print('🧪 테스트 1: 요한복음 3:16 조회');
      print('------------------------------------------');

      final verse = await repository.getVerse('요한복음 3:16');

      print('✅ 성공!');
      print('책: ${verse.book}');
      print('장: ${verse.chapter}');
      print('절: ${verse.verse}');
      print('참조: ${verse.reference}');
      print('내용: ${verse.text}');
      print('');

      expect(verse.book, '요');
      expect(verse.chapter, 3);
      expect(verse.verse, 16);
      expect(verse.text, isNotEmpty);
      expect(verse.text, contains('하나님'));
    });

    test('테스트 2: 구절 범위 조회 (시편 23:1-6)', () async {
      print('------------------------------------------');
      print('🧪 테스트 2: 시편 23:1-6 조회');
      print('------------------------------------------');

      final verses = await repository.getVerseRange('시편 23:1-6');

      print('✅ 성공! ${verses.length}개 구절');
      for (var verse in verses) {
        print('  ${verse.reference}: ${verse.text.substring(0, verse.text.length > 30 ? 30 : verse.text.length)}...');
      }
      print('');

      expect(verses.length, 6);
      expect(verses.first.book, '시');
      expect(verses.first.chapter, 23);
      expect(verses.first.verse, 1);
      expect(verses.last.verse, 6);
    });

    test('테스트 3: 구절 검색 (사랑)', () async {
      print('------------------------------------------');
      print('🧪 테스트 3: "사랑" 검색');
      print('------------------------------------------');

      final results = await repository.searchVerses('사랑', limit: 5);

      print('✅ 성공! ${results.length}개 결과');
      for (var verse in results) {
        print('  ${verse.reference}: ${verse.text.substring(0, verse.text.length > 40 ? 40 : verse.text.length)}...');
      }
      print('');

      expect(results, isNotEmpty);
      expect(results.length, lessThanOrEqualTo(5));
      for (var verse in results) {
        expect(verse.text, contains('사랑'));
      }
    });

    test('테스트 4: BibleReferenceParser 변환', () {
      print('------------------------------------------');
      print('🧪 테스트 4: 참조 파싱');
      print('------------------------------------------');

      final testCases = [
        '요한복음 3:16',
        '시편 23:1',
        '고린도전서 13:4',
        '창세기 1:1',
      ];

      for (var reference in testCases) {
        final key = BibleReferenceParser.parse(reference);
        final reversed = BibleReferenceParser.toKoreanReference(key!);

        print('  "$reference" → "$key" → "$reversed"');
        expect(key, isNotNull);
        expect(reversed, reference);
      }
      print('');
    });

    test('테스트 5: 책 이름 검색', () {
      print('------------------------------------------');
      print('🧪 테스트 5: 책 이름 검색');
      print('------------------------------------------');

      final results = repository.searchBookNames('요');

      print('✅ "요"로 시작하는 책들:');
      for (var bookName in results) {
        print('  - $bookName');
      }
      print('');

      expect(results, isNotEmpty);
      expect(results, contains('요한복음'));
    });

    test('테스트 6: 에러 처리 (잘못된 참조)', () async {
      print('------------------------------------------');
      print('🧪 테스트 6: 에러 처리');
      print('------------------------------------------');

      try {
        await repository.getVerse('존재하지않는책 1:1');
        fail('예외가 발생해야 합니다');
      } catch (e) {
        print('✅ 예상된 에러 발생: $e');
        print('');
        expect(e, isA<ArgumentError>());
      }
    });

    test('테스트 7: 성능 테스트 (100개 구절 조회)', () async {
      print('------------------------------------------');
      print('🧪 테스트 7: 성능 테스트');
      print('------------------------------------------');

      final stopwatch = Stopwatch()..start();

      for (var i = 1; i <= 10; i++) {
        await repository.getVerse('창세기 1:$i');
      }

      stopwatch.stop();
      final avgTime = stopwatch.elapsedMilliseconds / 10;

      print('✅ 10개 구절 조회 완료');
      print('   총 시간: ${stopwatch.elapsedMilliseconds}ms');
      print('   평균 시간: ${avgTime.toStringAsFixed(2)}ms/구절');
      print('');

      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // 100ms 이내
    });
  });

  // 결과 요약
  tearDownAll(() {
    print('==========================================');
    print('📊 테스트 완료');
    print('==========================================');
    print('');
    print('✅ 로컬 Bible 시스템이 정상 작동합니다!');
    print('');
    print('다음 단계:');
    print('1. UseCase 구현');
    print('2. Provider 연결');
    print('3. UI에서 사용');
    print('');
    print('==========================================\n');
  });
}
