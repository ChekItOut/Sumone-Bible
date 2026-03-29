import 'daily_verse_plan.dart';

/// 커플 엔티티 (Domain Layer)
///
/// 두 사용자가 연결된 커플 정보
/// 순수한 비즈니스 로직을 위한 모델 (외부 라이브러리 의존 없음)
class Couple {
  /// 커플 고유 ID
  final String coupleId;

  /// 첫 번째 사용자 ID
  final String user1Id;

  /// 두 번째 사용자 ID
  final String user2Id;

  /// 관계 단계 ("dating" | "engaged" | "married")
  final String? relationshipStage;

  /// 함께 읽을 일일 말씀 플랜 (nullable)
  final DailyVersePlan? dailyVersePlan;

  /// 커플 생성일 (연결된 날짜)
  final DateTime createdAt;

  const Couple({
    required this.coupleId,
    required this.user1Id,
    required this.user2Id,
    this.relationshipStage,
    this.dailyVersePlan,
    required this.createdAt,
  });

  /// 플랜이 설정되었는지 확인
  bool get hasPlan => dailyVersePlan != null;

  /// 관계 단계 한글 텍스트
  String get relationshipStageText {
    switch (relationshipStage) {
      case 'dating':
        return '연애중';
      case 'engaged':
        return '약혼';
      case 'married':
        return '신혼';
      default:
        return '커플';
    }
  }

  /// 특정 사용자가 이 커플에 속하는지 확인
  ///
  /// [userId] 확인할 사용자 ID
  /// Returns: true if 사용자가 user1 또는 user2인 경우
  bool isUserInCouple(String userId) {
    return user1Id == userId || user2Id == userId;
  }

  /// 파트너의 ID 반환
  ///
  /// [myUserId] 본인의 사용자 ID
  /// Returns: 파트너의 사용자 ID
  /// Throws: [ArgumentError] if myUserId가 커플에 속하지 않음
  String getPartnerId(String myUserId) {
    if (user1Id == myUserId) {
      return user2Id;
    } else if (user2Id == myUserId) {
      return user1Id;
    } else {
      throw ArgumentError('User $myUserId is not in this couple');
    }
  }

  /// 불변 객체를 위한 copyWith 메서드
  Couple copyWith({
    String? coupleId,
    String? user1Id,
    String? user2Id,
    String? relationshipStage,
    DailyVersePlan? dailyVersePlan,
    DateTime? createdAt,
  }) {
    return Couple(
      coupleId: coupleId ?? this.coupleId,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      relationshipStage: relationshipStage ?? this.relationshipStage,
      dailyVersePlan: dailyVersePlan ?? this.dailyVersePlan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Couple &&
        other.coupleId == coupleId &&
        other.user1Id == user1Id &&
        other.user2Id == user2Id &&
        other.relationshipStage == relationshipStage &&
        other.dailyVersePlan == dailyVersePlan &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return coupleId.hashCode ^
        user1Id.hashCode ^
        user2Id.hashCode ^
        relationshipStage.hashCode ^
        dailyVersePlan.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'Couple(coupleId: $coupleId, relationshipStage: $relationshipStageText, hasPlan: $hasPlan)';
  }
}
