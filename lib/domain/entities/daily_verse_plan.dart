/// 일일 말씀 플랜 엔티티 (Domain Layer)
///
/// 커플이 함께 읽을 성경 플랜 정보
/// 순수한 비즈니스 로직을 위한 모델 (외부 라이브러리 의존 없음)
class DailyVersePlan {
  /// 시작 성경 (예: "창세기", "요한복음")
  final String startBook;

  /// 하루 분량 (예: 3)
  final int dailyAmount;

  /// 하루 분량 타입 ("verse" | "chapter")
  /// - "verse": 절 단위 (예: 3절씩)
  /// - "chapter": 장 단위 (예: 1장씩)
  final String dailyAmountType;

  /// 현재 읽고 있는 성경
  final String currentBook;

  /// 현재 읽고 있는 장
  final int currentChapter;

  /// 현재 읽고 있는 절
  final int currentVerse;

  /// 플랜 시작일
  final DateTime startedAt;

  const DailyVersePlan({
    required this.startBook,
    required this.dailyAmount,
    required this.dailyAmountType,
    required this.currentBook,
    required this.currentChapter,
    required this.currentVerse,
    required this.startedAt,
  });

  /// 플랜이 절 단위인지 확인
  bool get isVerseMode => dailyAmountType == 'verse';

  /// 플랜이 장 단위인지 확인
  bool get isChapterMode => dailyAmountType == 'chapter';

  /// 플랜 설명 텍스트 생성
  ///
  /// 예: "창세기부터 3절씩 읽기"
  String get description {
    final amountText = isVerseMode ? '$dailyAmount절씩' : '$dailyAmount장씩';
    return '$startBook부터 $amountText 읽기';
  }

  /// 현재 진행 위치 텍스트
  ///
  /// 예: "창세기 1:1"
  String get currentPosition {
    return '$currentBook $currentChapter:$currentVerse';
  }

  /// 불변 객체를 위한 copyWith 메서드
  ///
  /// 진행 상황 업데이트 시 사용
  DailyVersePlan copyWith({
    String? startBook,
    int? dailyAmount,
    String? dailyAmountType,
    String? currentBook,
    int? currentChapter,
    int? currentVerse,
    DateTime? startedAt,
  }) {
    return DailyVersePlan(
      startBook: startBook ?? this.startBook,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      dailyAmountType: dailyAmountType ?? this.dailyAmountType,
      currentBook: currentBook ?? this.currentBook,
      currentChapter: currentChapter ?? this.currentChapter,
      currentVerse: currentVerse ?? this.currentVerse,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DailyVersePlan &&
        other.startBook == startBook &&
        other.dailyAmount == dailyAmount &&
        other.dailyAmountType == dailyAmountType &&
        other.currentBook == currentBook &&
        other.currentChapter == currentChapter &&
        other.currentVerse == currentVerse &&
        other.startedAt == startedAt;
  }

  @override
  int get hashCode {
    return startBook.hashCode ^
        dailyAmount.hashCode ^
        dailyAmountType.hashCode ^
        currentBook.hashCode ^
        currentChapter.hashCode ^
        currentVerse.hashCode ^
        startedAt.hashCode;
  }

  @override
  String toString() {
    return 'DailyVersePlan(description: $description, currentPosition: $currentPosition)';
  }
}
