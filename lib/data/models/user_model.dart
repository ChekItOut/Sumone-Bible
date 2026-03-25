import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/user.dart';

/// 사용자 데이터 모델 (Data Layer)
///
/// JSON ↔ Dart 변환 및 Supabase Auth User → Domain Entity 변환
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.relationshipStage,
    super.coupleId,
    required super.createdAt,
    super.lastSignInAt,
    super.emailVerified,
  });

  /// Supabase Auth User로부터 UserModel 생성
  ///
  /// Supabase Auth의 User 객체를 앱 내부의 User Entity로 변환
  factory UserModel.fromSupabaseUser(supabase.User supabaseUser) {
    return UserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      name: supabaseUser.userMetadata?['name'] as String?,
      photoUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
      relationshipStage:
          supabaseUser.userMetadata?['relationship_stage'] as String?,
      coupleId: supabaseUser.userMetadata?['couple_id'] as String?,
      createdAt: DateTime.parse(supabaseUser.createdAt),
      lastSignInAt: supabaseUser.lastSignInAt != null
          ? DateTime.parse(supabaseUser.lastSignInAt!)
          : null,
      emailVerified: supabaseUser.emailConfirmedAt != null,
    );
  }

  /// JSON으로부터 UserModel 생성
  ///
  /// Supabase Database의 users 테이블 데이터를 파싱
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      photoUrl: json['photo_url'] as String?,
      relationshipStage: json['relationship_stage'] as String?,
      coupleId: json['couple_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      emailVerified: json['email_verified'] as bool? ?? false,
    );
  }

  /// UserModel을 JSON으로 변환
  ///
  /// Supabase Database에 저장하기 위한 형식
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'relationship_stage': relationshipStage,
      'couple_id': coupleId,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'email_verified': emailVerified,
    };
  }

  /// Domain Entity (User)로 변환
  ///
  /// Data Layer → Domain Layer 변환
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      relationshipStage: relationshipStage,
      coupleId: coupleId,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
      emailVerified: emailVerified,
    );
  }

  /// Domain Entity로부터 UserModel 생성
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
      relationshipStage: user.relationshipStage,
      coupleId: user.coupleId,
      createdAt: user.createdAt,
      lastSignInAt: user.lastSignInAt,
      emailVerified: user.emailVerified,
    );
  }

  @override
  UserModel copyWith({
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
    return UserModel(
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
}
