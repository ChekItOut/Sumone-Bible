import '../../domain/entities/invite_link.dart';

/// 초대 링크 데이터 모델 (Data Layer)
///
/// JSON ↔ Dart 변환 및 Supabase invite_links 테이블과 Domain Entity 간 변환
class InviteLinkModel extends InviteLink {
  const InviteLinkModel({
    required super.inviteId,
    required super.inviterId,
    required super.token,
    required super.isUsed,
    required super.createdAt,
    required super.expiresAt,
  });

  /// JSON으로부터 InviteLinkModel 생성
  ///
  /// Supabase invite_links 테이블 row 데이터 파싱
  factory InviteLinkModel.fromJson(Map<String, dynamic> json) {
    return InviteLinkModel(
      inviteId: json['invite_id'] as String,
      inviterId: json['inviter_id'] as String,
      token: json['token'] as String,
      isUsed: json['is_used'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  /// InviteLinkModel을 JSON으로 변환
  ///
  /// Supabase invite_links 테이블에 저장하기 위한 형식
  Map<String, dynamic> toJson() {
    return {
      'invite_id': inviteId,
      'inviter_id': inviterId,
      'token': token,
      'is_used': isUsed,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  /// Domain Entity (InviteLink)로 변환
  ///
  /// Data Layer → Domain Layer 변환
  InviteLink toEntity() {
    return InviteLink(
      inviteId: inviteId,
      inviterId: inviterId,
      token: token,
      isUsed: isUsed,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  /// Domain Entity로부터 InviteLinkModel 생성
  factory InviteLinkModel.fromEntity(InviteLink link) {
    return InviteLinkModel(
      inviteId: link.inviteId,
      inviterId: link.inviterId,
      token: link.token,
      isUsed: link.isUsed,
      createdAt: link.createdAt,
      expiresAt: link.expiresAt,
    );
  }

  /// Firestore 문서로부터 InviteLinkModel 생성
  ///
  /// Firestore inviteLinks 컬렉션 문서 데이터 파싱 (camelCase)
  factory InviteLinkModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return InviteLinkModel(
      inviteId: docId,
      inviterId: data['inviterId'] as String,
      token: data['token'] as String,
      isUsed: data['isUsed'] as bool,
      createdAt: (data['createdAt'] as dynamic).toDate(),
      expiresAt: (data['expiresAt'] as dynamic).toDate(),
    );
  }

  /// InviteLinkModel을 Firestore 문서 형식으로 변환
  ///
  /// Firestore inviteLinks 컬렉션에 저장하기 위한 형식 (camelCase)
  Map<String, dynamic> toFirestore() {
    return {
      'inviterId': inviterId,
      'token': token,
      'isUsed': isUsed,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }

  @override
  InviteLinkModel copyWith({
    String? inviteId,
    String? inviterId,
    String? token,
    bool? isUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return InviteLinkModel(
      inviteId: inviteId ?? this.inviteId,
      inviterId: inviterId ?? this.inviterId,
      token: token ?? this.token,
      isUsed: isUsed ?? this.isUsed,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
