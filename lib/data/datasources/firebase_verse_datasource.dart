import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/error/exceptions.dart';
import '../models/daily_verse_model.dart';
import '../models/response_model.dart';

/// Firebase Firestore 말씀 데이터소스 (Data Layer)
///
/// Firestore dailyVerses, responses 컬렉션과 직접 통신
/// 일일 말씀 조회 및 답변 관리
class FirebaseVerseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      // dailyVerses 컬렉션에서 date 필드로 조회
      final snapshot = await _firestore
          .collection('dailyVerses')
          .where('date', isEqualTo: today)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw const VerseNotFoundException(message: '오늘의 말씀을 찾을 수 없습니다');
      }

      final doc = snapshot.docs.first;
      return DailyVerseModel.fromFirestore(doc.data(), doc.id);
    } on VerseNotFoundException {
      rethrow;
    } on FirebaseException catch (e) {
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
      // dailyVerses 컬렉션에서 최근 날짜 순으로 조회
      final snapshot = await _firestore
          .collection('dailyVerses')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => DailyVerseModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
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
      final existingSnapshot = await _firestore
          .collection('responses')
          .where('verseId', isEqualTo: verseId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      final now = Timestamp.now();

      if (existingSnapshot.docs.isEmpty) {
        // 2-a. 새 답변 생성
        await _firestore.collection('responses').add({
          'verseId': verseId,
          'userId': userId,
          'coupleId': coupleId,
          'content': content,
          'isSubmitted': true,
          'createdAt': now,
          'updatedAt': now,
        });
      } else {
        // 2-b. 기존 답변 업데이트
        final doc = existingSnapshot.docs.first;
        await doc.reference.update({
          'content': content,
          'isSubmitted': true,
          'updatedAt': now,
        });
      }
    } on FirebaseException catch (e) {
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
  Stream<List<ResponseModel>> watchResponses(String verseId, String coupleId) {
    try {
      return _firestore
          .collection('responses')
          .where('verseId', isEqualTo: verseId)
          .where('coupleId', isEqualTo: coupleId)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ResponseModel.fromFirestore(doc.data(), doc.id))
                .toList();
          });
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
      final snapshot = await _firestore
          .collection('responses')
          .where('verseId', isEqualTo: verseId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      return ResponseModel.fromFirestore(doc.data(), doc.id);
    } on FirebaseException catch (e) {
      throw DatabaseException('내 답변 조회 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '내 답변 조회 중 네트워크 오류', originalError: e);
    }
  }
}
