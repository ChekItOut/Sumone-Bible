/// 답변 엔티티 (Domain Layer)
///
/// 사용자가 일일 말씀에 대해 작성한 답변
class Response {
  final String responseId;
  final String verseId;
  final String userId;
  final String coupleId;
  final String content;
  final bool isSubmitted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Response({
    required this.responseId,
    required this.verseId,
    required this.userId,
    required this.coupleId,
    required this.content,
    required this.isSubmitted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Response 복사본 생성 (불변성 유지)
  Response copyWith({
    String? responseId,
    String? verseId,
    String? userId,
    String? coupleId,
    String? content,
    bool? isSubmitted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Response(
      responseId: responseId ?? this.responseId,
      verseId: verseId ?? this.verseId,
      userId: userId ?? this.userId,
      coupleId: coupleId ?? this.coupleId,
      content: content ?? this.content,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Response &&
        other.responseId == responseId &&
        other.verseId == verseId &&
        other.userId == userId &&
        other.coupleId == coupleId &&
        other.content == content &&
        other.isSubmitted == isSubmitted &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return responseId.hashCode ^
        verseId.hashCode ^
        userId.hashCode ^
        coupleId.hashCode ^
        content.hashCode ^
        isSubmitted.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Response(responseId: $responseId, verseId: $verseId, userId: $userId, coupleId: $coupleId, content: $content, isSubmitted: $isSubmitted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
