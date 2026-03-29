/// 초대 링크 엔티티 (Domain Layer)
///
/// 파트너 초대를 위한 링크 정보
/// 순수한 비즈니스 로직을 위한 모델 (외부 라이브러리 의존 없음)
class InviteLink {
  /// 초대 링크 고유 ID
  final String inviteId;

  /// 초대를 생성한 사용자 ID
  final String inviterId;

  /// 초대 토큰 (URL에 사용)
  final String token;

  /// 링크 사용 여부
  final bool isUsed;

  /// 링크 생성일
  final DateTime createdAt;

  /// 링크 만료일
  final DateTime expiresAt;

  const InviteLink({
    required this.inviteId,
    required this.inviterId,
    required this.token,
    required this.isUsed,
    required this.createdAt,
    required this.expiresAt,
  });

  /// 링크가 만료되었는지 확인
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// 링크가 유효한지 확인 (사용되지 않았고, 만료되지 않음)
  bool get isValid => !isUsed && !isExpired;

  /// 초대 링크 URL 생성
  ///
  /// [baseUrl] 앱의 기본 URL (예: "https://bible-sumone.com")
  /// Returns: 전체 초대 링크 URL
  String getFullUrl(String baseUrl) {
    return '$baseUrl/invite/$token';
  }

  /// 만료까지 남은 시간 (일 단위)
  int get daysUntilExpiry {
    final now = DateTime.now();
    if (isExpired) return 0;

    final difference = expiresAt.difference(now);
    return difference.inDays;
  }

  /// 불변 객체를 위한 copyWith 메서드
  InviteLink copyWith({
    String? inviteId,
    String? inviterId,
    String? token,
    bool? isUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return InviteLink(
      inviteId: inviteId ?? this.inviteId,
      inviterId: inviterId ?? this.inviterId,
      token: token ?? this.token,
      isUsed: isUsed ?? this.isUsed,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InviteLink &&
        other.inviteId == inviteId &&
        other.inviterId == inviterId &&
        other.token == token &&
        other.isUsed == isUsed &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode {
    return inviteId.hashCode ^
        inviterId.hashCode ^
        token.hashCode ^
        isUsed.hashCode ^
        createdAt.hashCode ^
        expiresAt.hashCode;
  }

  @override
  String toString() {
    return 'InviteLink(inviteId: $inviteId, token: $token, isValid: $isValid, daysUntilExpiry: $daysUntilExpiry)';
  }
}
