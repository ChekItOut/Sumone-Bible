import '../../domain/entities/daily_verse.dart';

class DailyVerseModel extends DailyVerse {
  const DailyVerseModel({
    required super.verseId,
    required super.date,
    required super.bibleBook,
    required super.chapter,
    required super.verseStart,
    super.verseEnd,
    required super.textKorean,
    super.textEnglish,
    required super.questionKorean,
    super.questionEnglish,
    super.topic,
    required super.createdAt,
  });

  factory DailyVerseModel.fromJson(Map<String, dynamic> json) {
    return DailyVerseModel(
      verseId: json['verse_id'] as String,
      date: DateTime.parse(json['date'] as String),
      bibleBook: json['bible_book'] as String,
      chapter: json['chapter'] as int,
      verseStart: json['verse_start'] as int,
      verseEnd: json['verse_end'] as int?,
      textKorean: json['text_korean'] as String,
      textEnglish: json['text_english'] as String?,
      questionKorean: json['question_korean'] as String,
      questionEnglish: json['question_english'] as String?,
      topic: json['topic'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verse_id': verseId,
      'date': _formatDate(date),
      'bible_book': bibleBook,
      'chapter': chapter,
      'verse_start': verseStart,
      'verse_end': verseEnd,
      'text_korean': textKorean,
      'text_english': textEnglish,
      'question_korean': questionKorean,
      'question_english': questionEnglish,
      'topic': topic,
      'created_at': createdAt.toIso8601String(),
    };
  }

  DailyVerse toEntity() {
    return DailyVerse(
      verseId: verseId,
      date: date,
      bibleBook: bibleBook,
      chapter: chapter,
      verseStart: verseStart,
      verseEnd: verseEnd,
      textKorean: textKorean,
      textEnglish: textEnglish,
      questionKorean: questionKorean,
      questionEnglish: questionEnglish,
      topic: topic,
      createdAt: createdAt,
    );
  }

  factory DailyVerseModel.fromEntity(DailyVerse verse) {
    return DailyVerseModel(
      verseId: verse.verseId,
      date: verse.date,
      bibleBook: verse.bibleBook,
      chapter: verse.chapter,
      verseStart: verse.verseStart,
      verseEnd: verse.verseEnd,
      textKorean: verse.textKorean,
      textEnglish: verse.textEnglish,
      questionKorean: verse.questionKorean,
      questionEnglish: verse.questionEnglish,
      topic: verse.topic,
      createdAt: verse.createdAt,
    );
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
