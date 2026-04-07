class DailyVerse {
  final String verseId;
  final DateTime date;
  final String bibleBook;
  final int chapter;
  final int verseStart;
  final int? verseEnd;
  final String textKorean;
  final String? textEnglish;
  final String questionKorean;
  final String? questionEnglish;
  final String? topic;
  final DateTime createdAt;

  const DailyVerse({
    required this.verseId,
    required this.date,
    required this.bibleBook,
    required this.chapter,
    required this.verseStart,
    this.verseEnd,
    required this.textKorean,
    this.textEnglish,
    required this.questionKorean,
    this.questionEnglish,
    this.topic,
    required this.createdAt,
  });

  String get reference {
    final end = verseEnd != null && verseEnd != verseStart ? '-$verseEnd' : '';
    return '$bibleBook $chapter:$verseStart$end';
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  DailyVerse copyWith({
    String? verseId,
    DateTime? date,
    String? bibleBook,
    int? chapter,
    int? verseStart,
    int? verseEnd,
    String? textKorean,
    String? textEnglish,
    String? questionKorean,
    String? questionEnglish,
    String? topic,
    DateTime? createdAt,
  }) {
    return DailyVerse(
      verseId: verseId ?? this.verseId,
      date: date ?? this.date,
      bibleBook: bibleBook ?? this.bibleBook,
      chapter: chapter ?? this.chapter,
      verseStart: verseStart ?? this.verseStart,
      verseEnd: verseEnd ?? this.verseEnd,
      textKorean: textKorean ?? this.textKorean,
      textEnglish: textEnglish ?? this.textEnglish,
      questionKorean: questionKorean ?? this.questionKorean,
      questionEnglish: questionEnglish ?? this.questionEnglish,
      topic: topic ?? this.topic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DailyVerse &&
        other.verseId == verseId &&
        other.date == date &&
        other.bibleBook == bibleBook &&
        other.chapter == chapter &&
        other.verseStart == verseStart &&
        other.verseEnd == verseEnd &&
        other.textKorean == textKorean &&
        other.textEnglish == textEnglish &&
        other.questionKorean == questionKorean &&
        other.questionEnglish == questionEnglish &&
        other.topic == topic &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return verseId.hashCode ^
        date.hashCode ^
        bibleBook.hashCode ^
        chapter.hashCode ^
        verseStart.hashCode ^
        verseEnd.hashCode ^
        textKorean.hashCode ^
        textEnglish.hashCode ^
        questionKorean.hashCode ^
        questionEnglish.hashCode ^
        topic.hashCode ^
        createdAt.hashCode;
  }
}
