import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_client.dart';
import '../../core/error/exceptions.dart';
import '../models/couple_model.dart';
import '../models/daily_verse_plan_model.dart';
import '../models/invite_link_model.dart';

/// Supabase 커플 데이터소스 (Data Layer)
///
/// Supabase couples, invite_links, users 테이블과 직접 통신
/// CRUD 작업 및 비즈니스 로직 처리
class SupabaseCoupleDataSource {
  final SupabaseClient _supabase = supabase;

  // ============================================================
  // 1. 초대 링크 생성
  // ============================================================

  /// 초대 링크 생성
  ///
  /// [userId] 초대를 생성하는 사용자 ID
  /// Returns: 생성된 InviteLinkModel
  /// Throws: DatabaseException, NetworkException
  Future<InviteLinkModel> createInviteLink(String userId) async {
    try {
      // 1. 랜덤 토큰 생성 (32자)
      final token = _generateToken();

      // 2. invite_links 테이블 INSERT
      final response = await _supabase
          .from('invite_links')
          .insert({
            'inviter_id': userId,
            'token': token,
            'is_used': false,
            // created_at, expires_at은 DB에서 자동 설정 (DEFAULT NOW(), DEFAULT NOW() + INTERVAL '7 days')
          })
          .select()
          .single();

      return InviteLinkModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DatabaseException(
        '초대 링크 생성 실패',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw NetworkException(
        message: '초대 링크 생성 중 네트워크 오류',
        originalError: e,
      );
    }
  }

  /// 랜덤 토큰 생성 (32자)
  String _generateToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(32, (_) => chars[random.nextInt(chars.length)]).join();
  }

  // ============================================================
  // 2. 초대 수락 (커플 연결)
  // ============================================================

  /// 초대 수락 및 커플 연결
  ///
  /// [token] 초대 링크 토큰
  /// [accepterId] 초대를 수락하는 사용자 ID
  /// Returns: 생성된 CoupleModel
  /// Throws: ExpiredInviteLinkException, InvalidInviteLinkException, AlreadyConnectedException, DatabaseException
  Future<CoupleModel> acceptInvite({
    required String token,
    required String accepterId,
  }) async {
    try {
      // 1. invite_links 조회 (token, is_used=false)
      final inviteResponse = await _supabase
          .from('invite_links')
          .select()
          .eq('token', token)
          .eq('is_used', false)
          .maybeSingle();

      if (inviteResponse == null) {
        throw const InvalidInviteLinkException(
          message: '유효하지 않은 초대 링크입니다',
        );
      }

      final inviteLink = InviteLinkModel.fromJson(inviteResponse);

      // 2. 만료 확인
      if (inviteLink.isExpired) {
        throw const ExpiredInviteLinkException(
          message: '초대 링크가 만료되었습니다',
        );
      }

      final inviterId = inviteLink.inviterId;

      // 3. 이미 연결된 사용자인지 확인 (accepter)
      final accepterUser = await _supabase
          .from('users')
          .select('couple_id')
          .eq('user_id', accepterId)
          .single();

      if (accepterUser['couple_id'] != null) {
        throw const AlreadyConnectedException(
          message: '이미 다른 파트너와 연결되어 있습니다',
        );
      }

      // 4. 이미 연결된 사용자인지 확인 (inviter)
      final inviterUser = await _supabase
          .from('users')
          .select('couple_id')
          .eq('user_id', inviterId)
          .single();

      if (inviterUser['couple_id'] != null) {
        throw const AlreadyConnectedException(
          message: '초대한 사용자가 이미 다른 파트너와 연결되어 있습니다',
        );
      }

      // 5. couples 테이블 INSERT
      final coupleResponse = await _supabase
          .from('couples')
          .insert({
            'user1_id': inviterId,
            'user2_id': accepterId,
            // relationship_stage, daily_verse_plan은 NULL (나중에 설정)
          })
          .select()
          .single();

      final couple = CoupleModel.fromJson(coupleResponse);

      // 6. users 테이블 UPDATE (두 사용자의 couple_id)
      await _supabase
          .from('users')
          .update({'couple_id': couple.coupleId})
          .inFilter('user_id', [inviterId, accepterId]);

      // 7. invite_links UPDATE (is_used=true)
      await _supabase
          .from('invite_links')
          .update({'is_used': true})
          .eq('invite_id', inviteLink.inviteId);

      return couple;
    } on ExpiredInviteLinkException {
      rethrow;
    } on InvalidInviteLinkException {
      rethrow;
    } on AlreadyConnectedException {
      rethrow;
    } on PostgrestException catch (e) {
      throw DatabaseException(
        '초대 수락 실패',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw NetworkException(
        message: '초대 수락 중 네트워크 오류',
        originalError: e,
      );
    }
  }

  // ============================================================
  // 3. 커플 정보 조회
  // ============================================================

  /// 커플 정보 조회
  ///
  /// [userId] 조회할 사용자 ID
  /// Returns: 사용자가 속한 CoupleModel
  /// Throws: NoCoupleException, DatabaseException
  Future<CoupleModel> getCouple(String userId) async {
    try {
      // 1. users 테이블에서 couple_id 조회
      final userResponse = await _supabase
          .from('users')
          .select('couple_id')
          .eq('user_id', userId)
          .single();

      final coupleId = userResponse['couple_id'] as String?;

      if (coupleId == null) {
        throw const NoCoupleException(
          message: '커플 정보를 찾을 수 없습니다',
        );
      }

      // 2. couples 테이블에서 커플 정보 조회
      final coupleResponse = await _supabase
          .from('couples')
          .select()
          .eq('couple_id', coupleId)
          .single();

      return CoupleModel.fromJson(coupleResponse);
    } on NoCoupleException {
      rethrow;
    } on PostgrestException catch (e) {
      // couple_id는 있는데 couples 테이블에 데이터가 없는 경우 (데이터 불일치)
      if (e.code == 'PGRST116') {
        throw const NoCoupleException(
          message: '커플 정보를 찾을 수 없습니다',
        );
      }
      throw DatabaseException(
        '커플 정보 조회 실패',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw NetworkException(
        message: '커플 정보 조회 중 네트워크 오류',
        originalError: e,
      );
    }
  }

  // ============================================================
  // 4. 커플 연결 해제
  // ============================================================

  /// 커플 연결 해제
  ///
  /// [coupleId] 해제할 커플 ID
  /// [userId] 해제를 요청하는 사용자 ID (권한 확인용)
  /// Returns: void
  /// Throws: UnauthorizedException, DatabaseException
  Future<void> disconnectCouple({
    required String coupleId,
    required String userId,
  }) async {
    try {
      // 1. 권한 확인: 커플 정보 조회하여 user1_id 또는 user2_id인지 확인
      final coupleResponse = await _supabase
          .from('couples')
          .select('user1_id, user2_id')
          .eq('couple_id', coupleId)
          .single();

      final user1Id = coupleResponse['user1_id'] as String;
      final user2Id = coupleResponse['user2_id'] as String;

      if (userId != user1Id && userId != user2Id) {
        throw const UnauthorizedException(
          message: '커플 연결을 해제할 권한이 없습니다',
        );
      }

      // 2. users 테이블 UPDATE (두 사용자의 couple_id = null)
      await _supabase
          .from('users')
          .update({'couple_id': null})
          .inFilter('user_id', [user1Id, user2Id]);

      // 3. couples 테이블 DELETE (CASCADE로 관련 데이터도 삭제)
      await _supabase
          .from('couples')
          .delete()
          .eq('couple_id', coupleId);
    } on UnauthorizedException {
      rethrow;
    } on PostgrestException catch (e) {
      throw DatabaseException(
        '커플 연결 해제 실패',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw NetworkException(
        message: '커플 연결 해제 중 네트워크 오류',
        originalError: e,
      );
    }
  }

  // ============================================================
  // 5. 일일 말씀 플랜 업데이트
  // ============================================================

  /// 일일 말씀 플랜 업데이트
  ///
  /// [coupleId] 플랜을 업데이트할 커플 ID
  /// [plan] 새로운 플랜 정보
  /// Returns: 업데이트된 CoupleModel
  /// Throws: DatabaseException
  Future<CoupleModel> updateDailyVersePlan({
    required String coupleId,
    required DailyVersePlanModel plan,
  }) async {
    try {
      // couples 테이블 UPDATE (daily_verse_plan JSONB 필드)
      final response = await _supabase
          .from('couples')
          .update({
            'daily_verse_plan': plan.toJson(),
          })
          .eq('couple_id', coupleId)
          .select()
          .single();

      return CoupleModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DatabaseException(
        '플랜 업데이트 실패',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw NetworkException(
        message: '플랜 업데이트 중 네트워크 오류',
        originalError: e,
      );
    }
  }
}
