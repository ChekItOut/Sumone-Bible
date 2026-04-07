import '../../domain/entities/couple.dart';
import '../../domain/entities/daily_verse_plan.dart';
import 'daily_verse_plan_model.dart';

/// 커플 데이터 모델 (Data Layer)
///
/// JSON ↔ Dart 변환 및 Supabase couples 테이블과 Domain Entity 간 변환
class CoupleModel extends Couple {
  const CoupleModel({
    required super.coupleId,
    required super.user1Id,
    required super.user2Id,
    super.relationshipStage,
    super.dailyVersePlan,
    required super.createdAt,
  });

  /// JSON으로부터 CoupleModel 생성
  ///
  /// Supabase couples 테이블 row 데이터 파싱
  factory CoupleModel.fromJson(Map<String, dynamic> json) {
    // daily_verse_plan JSONB 필드 파싱 (nullable)
    DailyVersePlanModel? plan;
    if (json['daily_verse_plan'] != null) {
      plan = DailyVersePlanModel.fromJson(
        json['daily_verse_plan'] as Map<String, dynamic>,
      );
    }

    return CoupleModel(
      coupleId: json['couple_id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      relationshipStage: json['relationship_stage'] as String?,
      dailyVersePlan: plan,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// CoupleModel을 JSON으로 변환
  ///
  /// Supabase couples 테이블에 저장하기 위한 형식
  Map<String, dynamic> toJson() {
    return {
      'couple_id': coupleId,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'relationship_stage': relationshipStage,
      'daily_verse_plan': dailyVersePlan != null
          ? DailyVersePlanModel.fromEntity(dailyVersePlan!).toJson()
          : null,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Domain Entity (Couple)로 변환
  ///
  /// Data Layer → Domain Layer 변환
  Couple toEntity() {
    return Couple(
      coupleId: coupleId,
      user1Id: user1Id,
      user2Id: user2Id,
      relationshipStage: relationshipStage,
      dailyVersePlan: dailyVersePlan,
      createdAt: createdAt,
    );
  }

  /// Domain Entity로부터 CoupleModel 생성
  factory CoupleModel.fromEntity(Couple couple) {
    return CoupleModel(
      coupleId: couple.coupleId,
      user1Id: couple.user1Id,
      user2Id: couple.user2Id,
      relationshipStage: couple.relationshipStage,
      dailyVersePlan: couple.dailyVersePlan,
      createdAt: couple.createdAt,
    );
  }

  /// Firestore 문서로부터 CoupleModel 생성
  ///
  /// Firestore couples 컬렉션 문서 데이터 파싱 (camelCase)
  factory CoupleModel.fromFirestore(Map<String, dynamic> data, String docId) {
    // dailyVersePlan 필드 파싱 (nullable)
    DailyVersePlanModel? plan;
    if (data['dailyVersePlan'] != null) {
      plan = DailyVersePlanModel.fromFirestore(
        data['dailyVersePlan'] as Map<String, dynamic>,
      );
    }

    return CoupleModel(
      coupleId: docId,
      user1Id: data['user1Id'] as String,
      user2Id: data['user2Id'] as String,
      relationshipStage: data['relationshipStage'] as String?,
      dailyVersePlan: plan,
      createdAt: (data['createdAt'] as dynamic).toDate(),
    );
  }

  /// CoupleModel을 Firestore 문서 형식으로 변환
  ///
  /// Firestore couples 컬렉션에 저장하기 위한 형식 (camelCase)
  Map<String, dynamic> toFirestore() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'relationshipStage': relationshipStage,
      'dailyVersePlan': dailyVersePlan != null
          ? DailyVersePlanModel.fromEntity(dailyVersePlan!).toFirestore()
          : null,
      'createdAt': createdAt,
    };
  }

  @override
  CoupleModel copyWith({
    String? coupleId,
    String? user1Id,
    String? user2Id,
    String? relationshipStage,
    DailyVersePlan? dailyVersePlan,
    DateTime? createdAt,
  }) {
    return CoupleModel(
      coupleId: coupleId ?? this.coupleId,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      relationshipStage: relationshipStage ?? this.relationshipStage,
      dailyVersePlan: dailyVersePlan ?? this.dailyVersePlan,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
