/// 성경 구절 Entity
///
/// 순수 비즈니스 로직을 위한 도메인 모델
/// 외부 라이브러리 의존성 없음
class BibleVerse {
  final String book; // 책 코드 (예: "JHN", "PSA")
  final int chapter; // 장
  final int verse; // 절
  final String text; // 구절 텍스트
  final String reference; // 참조 (예: "John 3:16")

  BibleVerse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.reference,
  });

  /// 비어있는 구절인지 확인
  bool get isEmpty => text.trim().isEmpty;

  /// 구절 ID 생성 (API.Bible 형식)
  /// 예: "JHN.3.16"
  String get verseId => '$book.$chapter.$verse';

  @override
  String toString() {
    return 'BibleVerse(reference: $reference, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BibleVerse &&
        other.book == book &&
        other.chapter == chapter &&
        other.verse == verse &&
        other.text == text &&
        other.reference == reference;
  }

  @override
  int get hashCode {
    return book.hashCode ^
        chapter.hashCode ^
        verse.hashCode ^
        text.hashCode ^
        reference.hashCode;
  }
}
