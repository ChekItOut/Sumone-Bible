import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 목회자 검토 서비스
///
/// 책임:
/// - 베타 테스트용 질문 검토 시스템
/// - 생성된 질문을 목회자가 검토하고 승인
/// - 승인된 질문만 사용자에게 표시
///
/// NOTE: Phase 2.2 베타 테스트용, 추후 자동화 고려
class PastorReviewService {
  final SupabaseClient _supabase;
  final Logger _logger = Logger();

  PastorReviewService(this._supabase);

  /// 검토 대기 질문 제출
  ///
  /// [verseId]: 성경 구절 ID
  /// [question]: 생성된 질문
  /// [generationMethod]: 생성 방법 ('gemini_full', 'gemini_key', 'template')
  /// [metadata]: 추가 메타데이터
  ///
  /// Returns: 제출된 질문 ID
  Future<String> submitForReview({
    required String verseId,
    required String question,
    required String generationMethod,
    Map<String, dynamic>? metadata,
  }) async {
    _logger.i('📝 목회자 검토 제출: $question');

    try {
      final response = await _supabase
          .from('question_reviews')
          .insert({
            'verse_id': verseId,
            'question': question,
            'generation_method': generationMethod,
            'status': 'pending', // 검토 대기
            'metadata': metadata ?? {},
            'submitted_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final questionId = response['id'] as String;
      _logger.i('✅ 검토 제출 완료: $questionId');

      return questionId;
    } catch (e) {
      _logger.e('❌ 검토 제출 실패', error: e);
      throw PastorReviewException('검토 제출 실패: $e');
    }
  }

  /// 질문 검토 (목회자용)
  ///
  /// [questionId]: 질문 ID
  /// [approved]: 승인 여부
  /// [feedback]: 피드백 (선택)
  /// [pastorId]: 목회자 ID
  ///
  /// Returns: 검토 완료 여부
  Future<bool> reviewQuestion({
    required String questionId,
    required bool approved,
    String? feedback,
    required String pastorId,
  }) async {
    _logger.i('✅ 질문 검토: $questionId, 승인=$approved');

    try {
      await _supabase
          .from('question_reviews')
          .update({
            'status': approved ? 'approved' : 'rejected',
            'reviewer_id': pastorId,
            'feedback': feedback,
            'reviewed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', questionId);

      _logger.i('✅ 검토 완료');
      return true;
    } catch (e) {
      _logger.e('❌ 검토 실패', error: e);
      throw PastorReviewException('검토 실패: $e');
    }
  }

  /// 승인된 질문 가져오기
  ///
  /// [verseId]: 성경 구절 ID
  ///
  /// Returns: 승인된 질문 또는 null
  Future<String?> getApprovedQuestion(String verseId) async {
    _logger.i('🔍 승인된 질문 조회: $verseId');

    try {
      final response = await _supabase
          .from('question_reviews')
          .select('question')
          .eq('verse_id', verseId)
          .eq('status', 'approved')
          .order('reviewed_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        _logger.w('⚠️  승인된 질문 없음');
        return null;
      }

      final question = response['question'] as String;
      _logger.i('✅ 승인된 질문 발견: $question');

      return question;
    } catch (e) {
      _logger.e('❌ 질문 조회 실패', error: e);
      return null;
    }
  }

  /// 검토 대기 중인 질문 목록 (목회자용)
  ///
  /// [limit]: 최대 개수 (기본 50)
  ///
  /// Returns: 검토 대기 질문 목록
  Future<List<Map<String, dynamic>>> getPendingQuestions({
    int limit = 50,
  }) async {
    _logger.i('📋 검토 대기 질문 조회: 최대 $limit개');

    try {
      final response = await _supabase
          .from('question_reviews')
          .select()
          .eq('status', 'pending')
          .order('submitted_at', ascending: false)
          .limit(limit);

      _logger.i('✅ 검토 대기 질문 ${response.length}개 조회');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _logger.e('❌ 질문 목록 조회 실패', error: e);
      throw PastorReviewException('질문 목록 조회 실패: $e');
    }
  }

  /// 검토 통계
  ///
  /// Returns: 검토 통계 정보
  Future<ReviewStats> getReviewStats() async {
    _logger.i('📊 검토 통계 조회');

    try {
      // Supabase v2.x: .count() 메서드 사용
      final pendingResponse = await _supabase
          .from('question_reviews')
          .select('id')
          .eq('status', 'pending')
          .count();

      final approvedResponse = await _supabase
          .from('question_reviews')
          .select('id')
          .eq('status', 'approved')
          .count();

      final rejectedResponse = await _supabase
          .from('question_reviews')
          .select('id')
          .eq('status', 'rejected')
          .count();

      // PostgrestResponse.count 필드 사용 (non-nullable int)
      final stats = ReviewStats(
        pending: pendingResponse.count,
        approved: approvedResponse.count,
        rejected: rejectedResponse.count,
      );

      _logger.i('✅ 통계 조회 완료: $stats');

      return stats;
    } catch (e) {
      _logger.e('❌ 통계 조회 실패', error: e);
      throw PastorReviewException('통계 조회 실패: $e');
    }
  }
}

/// 검토 통계
class ReviewStats {
  final int pending;
  final int approved;
  final int rejected;

  ReviewStats({
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  int get total => pending + approved + rejected;

  double get approvalRate =>
      total > 0 ? (approved / total * 100).roundToDouble() : 0.0;

  @override
  String toString() {
    return 'ReviewStats(pending: $pending, approved: $approved, rejected: $rejected, total: $total, approvalRate: ${approvalRate.toStringAsFixed(1)}%)';
  }
}

/// 목회자 검토 예외
class PastorReviewException implements Exception {
  final String message;

  PastorReviewException(this.message);

  @override
  String toString() => 'PastorReviewException: $message';
}
