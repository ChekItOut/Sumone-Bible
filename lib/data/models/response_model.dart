import '../../domain/entities/response.dart';

/// 답변 데이터 모델 (Data Layer)
///
/// JSON ↔ Dart 변환 및 Supabase/Firestore와 Domain Entity 간 변환
class ResponseModel extends Response {
  const ResponseModel({
    required super.responseId,
    required super.verseId,
    required super.userId,
    required super.coupleId,
    required super.content,
    required super.isSubmitted,
    required super.createdAt,
    required super.updatedAt,
  });

  /// JSON으로부터 ResponseModel 생성 (Supabase)
  ///
  /// Supabase responses 테이블 row 데이터 파싱
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      responseId: json['response_id'] as String,
      verseId: json['verse_id'] as String,
      userId: json['user_id'] as String,
      coupleId: json['couple_id'] as String,
      content: json['content'] as String,
      isSubmitted: json['is_submitted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// ResponseModel을 JSON으로 변환 (Supabase)
  ///
  /// Supabase responses 테이블에 저장하기 위한 형식
  Map<String, dynamic> toJson() {
    return {
      'response_id': responseId,
      'verse_id': verseId,
      'user_id': userId,
      'couple_id': coupleId,
      'content': content,
      'is_submitted': isSubmitted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Firestore 문서로부터 ResponseModel 생성
  ///
  /// Firestore responses 컬렉션 문서 데이터 파싱 (camelCase)
  factory ResponseModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ResponseModel(
      responseId: docId,
      verseId: data['verseId'] as String,
      userId: data['userId'] as String,
      coupleId: data['coupleId'] as String,
      content: data['content'] as String,
      isSubmitted: data['isSubmitted'] as bool,
      createdAt: (data['createdAt'] as dynamic).toDate(),
      updatedAt: (data['updatedAt'] as dynamic).toDate(),
    );
  }

  /// ResponseModel을 Firestore 문서 형식으로 변환
  ///
  /// Firestore responses 컬렉션에 저장하기 위한 형식 (camelCase)
  Map<String, dynamic> toFirestore() {
    return {
      'verseId': verseId,
      'userId': userId,
      'coupleId': coupleId,
      'content': content,
      'isSubmitted': isSubmitted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Domain Entity (Response)로 변환
  ///
  /// Data Layer → Domain Layer 변환
  Response toEntity() {
    return Response(
      responseId: responseId,
      verseId: verseId,
      userId: userId,
      coupleId: coupleId,
      content: content,
      isSubmitted: isSubmitted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Domain Entity로부터 ResponseModel 생성
  factory ResponseModel.fromEntity(Response response) {
    return ResponseModel(
      responseId: response.responseId,
      verseId: response.verseId,
      userId: response.userId,
      coupleId: response.coupleId,
      content: response.content,
      isSubmitted: response.isSubmitted,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  @override
  ResponseModel copyWith({
    String? responseId,
    String? verseId,
    String? userId,
    String? coupleId,
    String? content,
    bool? isSubmitted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResponseModel(
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
}
