import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_client.dart';
import '../../core/error/exceptions.dart';
import '../models/daily_verse_model.dart';
import '../models/response_model.dart';

/// Supabase 말씀 데이터소스 (Data Layer)
///
/// Supabase daily_verses, responses 테이블과 직접 통신
/// 일일 말씀 조회 및 답변 관리
class SupabaseVerseDataSource {
  // ============================================================
  // 1. 오늘의 말씀 조회
  // ============================================================

  /// 오늘의 말씀 조회
  ///
  /// Returns: 오늘 날짜의 DailyVerseModel
  /// Throws: VerseNotFoundException, DatabaseException
  Future<DailyVerseModel> getTodayVerse() async {
    try {
      final today = _formatDate(DateTime.now());

      // daily_verses 테이블에서 date 필드로 조회
      final response = await supabase
          .from('daily_verses')
          .select()
          .eq('date', today)
          .maybeSingle();

      if (response == null) {
        throw const VerseNotFoundException(message: '오늘의 말씀을 찾을 수 없습니다');
      }

      return DailyVerseModel.fromJson(response);
    } on VerseNotFoundException {
      rethrow;
    } on PostgrestException catch (e) {
      throw DatabaseException('오늘의 말씀 조회 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '오늘의 말씀 조회 중 네트워크 오류', originalError: e);
    }
  }

  /// 날짜를 YYYY-MM-DD 형식으로 변환
  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // ============================================================
  // 2. 말씀 히스토리 조회
  // ============================================================

  /// 말씀 히스토리 조회
  ///
  /// [coupleId] 커플 ID (현재는 미사용, 향후 커플별 말씀 지원 시 사용)
  /// [limit] 조회할 개수
  /// Returns: 최근 말씀 리스트 (날짜 내림차순)
  /// Throws: DatabaseException
  Future<List<DailyVerseModel>> getVerseHistory(
    String coupleId,
    int limit,
  ) async {
    try {
      final today = DateTime.now();
      final startDate = today.subtract(Duration(days: limit - 1));

      // daily_verses 테이블에서 최근 날짜 범위 조회
      final response = await supabase
          .from('daily_verses')
          .select()
          .gte('date', _formatDate(startDate))
          .lte('date', _formatDate(today))
          .order('date', ascending: false)
          .limit(limit);

      return response
          .map<DailyVerseModel>((row) => DailyVerseModel.fromJson(row))
          .toList();
    } on PostgrestException catch (e) {
      throw DatabaseException('말씀 히스토리 조회 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '말씀 히스토리 조회 중 네트워크 오류', originalError: e);
    }
  }

  // ============================================================
  // 3. 답변 제출
  // ============================================================

  /// 답변 제출 (생성 또는 업데이트)
  ///
  /// [verseId] 말씀 ID
  /// [userId] 사용자 ID
  /// [coupleId] 커플 ID
  /// [content] 답변 내용
  /// Returns: void
  /// Throws: DatabaseException
  Future<void> submitResponse({
    required String verseId,
    required String userId,
    required String coupleId,
    required String content,
  }) async {
    try {
      // 1. 기존 답변 조회
      final existingResponse = await supabase
          .from('responses')
          .select()
          .eq('verse_id', verseId)
          .eq('user_id', userId)
          .maybeSingle();

      final now = DateTime.now().toIso8601String();

      if (existingResponse == null) {
        // 2-a. 새 답변 생성
        await supabase.from('responses').insert({
          'verse_id': verseId,
          'user_id': userId,
          'couple_id': coupleId,
          'content': content,
          'is_submitted': true,
          'created_at': now,
          'updated_at': now,
        });
      } else {
        // 2-b. 기존 답변 업데이트
        await supabase
            .from('responses')
            .update({
              'content': content,
              'is_submitted': true,
              'updated_at': now,
            })
            .eq('verse_id', verseId)
            .eq('user_id', userId);
      }
    } on PostgrestException catch (e) {
      throw DatabaseException('답변 제출 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '답변 제출 중 네트워크 오류', originalError: e);
    }
  }

  // ============================================================
  // 4. 답변 실시간 감시 (Stream)
  // ============================================================

  /// 답변 실시간 감시 (커플의 답변 모두)
  ///
  /// [verseId] 말씀 ID
  /// [coupleId] 커플 ID
  /// Returns: ResponseModel 리스트 Stream
  ///
  /// NOTE: Supabase Realtime은 복잡한 필터를 지원하지 않으므로
  /// 클라이언트에서 필터링 수행
  Stream<List<ResponseModel>> watchResponses(String verseId, String coupleId) {
    try {
      return supabase.from('responses').stream(primaryKey: ['response_id']).map(
        (data) {
          // 클라이언트에서 필터링
          final filtered = data
              .where(
                (row) =>
                    row['verse_id'] == verseId && row['couple_id'] == coupleId,
              )
              .toList();

          return filtered
              .map<ResponseModel>((row) => ResponseModel.fromJson(row))
              .toList();
        },
      );
    } catch (e) {
      // Stream 생성 실패 시 에러 Stream 반환
      return Stream.error(
        NetworkException(message: '답변 실시간 감시 중 오류', originalError: e),
      );
    }
  }

  // ============================================================
  // 5. 내 답변 조회
  // ============================================================

  /// 특정 말씀에 대한 내 답변 조회
  ///
  /// [verseId] 말씀 ID
  /// [userId] 사용자 ID
  /// Returns: ResponseModel (없으면 null)
  /// Throws: DatabaseException
  Future<ResponseModel?> getMyResponse({
    required String verseId,
    required String userId,
  }) async {
    try {
      final response = await supabase
          .from('responses')
          .select()
          .eq('verse_id', verseId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ResponseModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DatabaseException('내 답변 조회 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '내 답변 조회 중 네트워크 오류', originalError: e);
    }
  }
}
