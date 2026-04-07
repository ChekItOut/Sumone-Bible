import '../../domain/entities/daily_verse_plan.dart';

/// 일일 말씀 플랜 데이터 모델 (Data Layer)
///
/// JSON ↔ Dart 변환 및 Supabase JSONB 필드와 Domain Entity 간 변환
class DailyVersePlanModel extends DailyVersePlan {
  const DailyVersePlanModel({
    required super.startBook,
    required super.dailyAmount,
    required super.dailyAmountType,
    required super.currentBook,
    required super.currentChapter,
    required super.currentVerse,
    required super.startedAt,
  });

  /// JSON으로부터 DailyVersePlanModel 생성
  ///
  /// Supabase couples.daily_verse_plan JSONB 필드 데이터 파싱
  factory DailyVersePlanModel.fromJson(Map<String, dynamic> json) {
    return DailyVersePlanModel(
      startBook: json['start_book'] as String,
      dailyAmount: json['daily_amount'] as int,
      dailyAmountType: json['daily_amount_type'] as String,
      currentBook: json['current_book'] as String,
      currentChapter: json['current_chapter'] as int,
      currentVerse: json['current_verse'] as int,
      startedAt: DateTime.parse(json['started_at'] as String),
    );
  }

  /// DailyVersePlanModel을 JSON으로 변환
  ///
  /// Supabase couples.daily_verse_plan JSONB 필드에 저장하기 위한 형식
  Map<String, dynamic> toJson() {
    return {
      'start_book': startBook,
      'daily_amount': dailyAmount,
      'daily_amount_type': dailyAmountType,
      'current_book': currentBook,
      'current_chapter': currentChapter,
      'current_verse': currentVerse,
      'started_at': startedAt.toIso8601String(),
    };
  }

  /// Domain Entity (DailyVersePlan)로 변환
  ///
  /// Data Layer → Domain Layer 변환
  DailyVersePlan toEntity() {
    return DailyVersePlan(
      startBook: startBook,
      dailyAmount: dailyAmount,
      dailyAmountType: dailyAmountType,
      currentBook: currentBook,
      currentChapter: currentChapter,
      currentVerse: currentVerse,
      startedAt: startedAt,
    );
  }

  /// Domain Entity로부터 DailyVersePlanModel 생성
  factory DailyVersePlanModel.fromEntity(DailyVersePlan plan) {
    return DailyVersePlanModel(
      startBook: plan.startBook,
      dailyAmount: plan.dailyAmount,
      dailyAmountType: plan.dailyAmountType,
      currentBook: plan.currentBook,
      currentChapter: plan.currentChapter,
      currentVerse: plan.currentVerse,
      startedAt: plan.startedAt,
    );
  }

  /// Firestore 맵으로부터 DailyVersePlanModel 생성
  ///
  /// Firestore couples.dailyVersePlan 필드 데이터 파싱 (camelCase)
  factory DailyVersePlanModel.fromFirestore(Map<String, dynamic> data) {
    return DailyVersePlanModel(
      startBook: data['startBook'] as String,
      dailyAmount: data['dailyAmount'] as int,
      dailyAmountType: data['dailyAmountType'] as String,
      currentBook: data['currentBook'] as String,
      currentChapter: data['currentChapter'] as int,
      currentVerse: data['currentVerse'] as int,
      startedAt: (data['startedAt'] as dynamic).toDate(),
    );
  }

  /// DailyVersePlanModel을 Firestore 맵 형식으로 변환
  ///
  /// Firestore couples.dailyVersePlan 필드에 저장하기 위한 형식 (camelCase)
  Map<String, dynamic> toFirestore() {
    return {
      'startBook': startBook,
      'dailyAmount': dailyAmount,
      'dailyAmountType': dailyAmountType,
      'currentBook': currentBook,
      'currentChapter': currentChapter,
      'currentVerse': currentVerse,
      'startedAt': startedAt,
    };
  }

  @override
  DailyVersePlanModel copyWith({
    String? startBook,
    int? dailyAmount,
    String? dailyAmountType,
    String? currentBook,
    int? currentChapter,
    int? currentVerse,
    DateTime? startedAt,
  }) {
    return DailyVersePlanModel(
      startBook: startBook ?? this.startBook,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      dailyAmountType: dailyAmountType ?? this.dailyAmountType,
      currentBook: currentBook ?? this.currentBook,
      currentChapter: currentChapter ?? this.currentChapter,
      currentVerse: currentVerse ?? this.currentVerse,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}
