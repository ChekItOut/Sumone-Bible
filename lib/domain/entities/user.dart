/// 사용자 엔티티 (Domain Layer)
///
/// 순수한 비즈니스 로직을 위한 사용자 모델
/// 외부 라이브러리(Supabase, Firebase 등)에 의존하지 않음
class User {
  /// 고유 식별자 (Supabase Auth User ID)
  final String id;

  /// 이메일 주소
  final String email;

  /// 사용자 이름 (닉네임)
  final String? name;

  /// 프로필 사진 URL
  final String? photoUrl;

  /// 관계 단계 (dating, engaged, married)
  final String? relationshipStage;

  /// 커플 ID (연결된 커플 정보)
  final String? coupleId;

  /// 계정 생성 일시
  final DateTime createdAt;

  /// 마지막 로그인 일시
  final DateTime? lastSignInAt;

  /// 이메일 인증 여부
  final bool emailVerified;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.relationshipStage,
    this.coupleId,
    required this.createdAt,
    this.lastSignInAt,
    this.emailVerified = false,
  });

  /// 프로필이 완성되었는지 확인
  ///
  /// 이름과 관계 단계가 모두 설정되어야 완성된 프로필
  bool get isProfileComplete => name != null && relationshipStage != null;

  /// 커플과 연결되었는지 확인
  bool get isConnected => coupleId != null;

  /// 불변 객체를 위한 copyWith 메서드
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? relationshipStage,
    String? coupleId,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    bool? emailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      relationshipStage: relationshipStage ?? this.relationshipStage,
      coupleId: coupleId ?? this.coupleId,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.photoUrl == photoUrl &&
        other.relationshipStage == relationshipStage &&
        other.coupleId == coupleId &&
        other.createdAt == createdAt &&
        other.lastSignInAt == lastSignInAt &&
        other.emailVerified == emailVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        photoUrl.hashCode ^
        relationshipStage.hashCode ^
        coupleId.hashCode ^
        createdAt.hashCode ^
        lastSignInAt.hashCode ^
        emailVerified.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, isProfileComplete: $isProfileComplete, isConnected: $isConnected)';
  }
}
