import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/error/exceptions.dart';
import '../models/couple_model.dart';
import '../models/daily_verse_plan_model.dart';
import '../models/invite_link_model.dart';

/// Firebase Firestore 커플 데이터소스 (Data Layer)
///
/// Firestore couples, inviteLinks, users 컬렉션과 직접 통신
/// CRUD 작업 및 비즈니스 로직 처리
class FirebaseCoupleDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      // 2. inviteLinks 컬렉션 추가
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(days: 7));

      final docRef = await _firestore.collection('inviteLinks').add({
        'inviterId': userId,
        'token': token,
        'isUsed': false,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(expiresAt),
      });

      // 3. 생성된 문서 조회
      final snapshot = await docRef.get();
      final data = snapshot.data()!;

      return InviteLinkModel.fromFirestore(data, snapshot.id);
    } on FirebaseException catch (e) {
      throw DatabaseException('초대 링크 생성 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '초대 링크 생성 중 네트워크 오류', originalError: e);
    }
  }

  /// 랜덤 토큰 생성 (32자)
  String _generateToken() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
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
      // 1. inviteLinks 조회 (token, isUsed=false)
      final inviteLinkSnapshot = await _firestore
          .collection('inviteLinks')
          .where('token', isEqualTo: token)
          .where('isUsed', isEqualTo: false)
          .limit(1)
          .get();

      if (inviteLinkSnapshot.docs.isEmpty) {
        throw const InvalidInviteLinkException(message: '유효하지 않은 초대 링크입니다');
      }

      final inviteLinkDoc = inviteLinkSnapshot.docs.first;
      final inviteLink = InviteLinkModel.fromFirestore(
        inviteLinkDoc.data(),
        inviteLinkDoc.id,
      );

      // 2. 만료 확인
      if (inviteLink.isExpired) {
        throw const ExpiredInviteLinkException(message: '초대 링크가 만료되었습니다');
      }

      final inviterId = inviteLink.inviterId;

      // 3. 이미 연결된 사용자인지 확인 (accepter)
      final accepterUserDoc = await _firestore
          .collection('users')
          .doc(accepterId)
          .get();
      final accepterData = accepterUserDoc.data();

      if (accepterData != null && accepterData['coupleId'] != null) {
        throw const AlreadyConnectedException(message: '이미 다른 파트너와 연결되어 있습니다');
      }

      // 4. 이미 연결된 사용자인지 확인 (inviter)
      final inviterUserDoc = await _firestore
          .collection('users')
          .doc(inviterId)
          .get();
      final inviterData = inviterUserDoc.data();

      if (inviterData != null && inviterData['coupleId'] != null) {
        throw const AlreadyConnectedException(
          message: '초대한 사용자가 이미 다른 파트너와 연결되어 있습니다',
        );
      }

      // 5. couples 컬렉션 추가
      final coupleDocRef = await _firestore.collection('couples').add({
        'user1Id': inviterId,
        'user2Id': accepterId,
        'relationshipStage': null,
        'dailyVersePlan': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 6. 생성된 커플 문서 조회
      final coupleSnapshot = await coupleDocRef.get();
      final couple = CoupleModel.fromFirestore(
        coupleSnapshot.data()!,
        coupleSnapshot.id,
      );

      // 7. users 문서 업데이트 (두 사용자의 coupleId)
      final batch = _firestore.batch();
      batch.update(_firestore.collection('users').doc(inviterId), {
        'coupleId': couple.coupleId,
      });
      batch.update(_firestore.collection('users').doc(accepterId), {
        'coupleId': couple.coupleId,
      });
      await batch.commit();

      // 8. inviteLinks 업데이트 (isUsed=true)
      await inviteLinkDoc.reference.update({'isUsed': true});

      return couple;
    } on ExpiredInviteLinkException {
      rethrow;
    } on InvalidInviteLinkException {
      rethrow;
    } on AlreadyConnectedException {
      rethrow;
    } on FirebaseException catch (e) {
      throw DatabaseException('초대 수락 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '초대 수락 중 네트워크 오류', originalError: e);
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
      // 1. users 문서에서 coupleId 조회
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      if (userData == null) {
        throw const NoCoupleException(message: '사용자 정보를 찾을 수 없습니다');
      }

      final coupleId = userData['coupleId'] as String?;

      if (coupleId == null) {
        throw const NoCoupleException(message: '커플 정보를 찾을 수 없습니다');
      }

      // 2. couples 문서에서 커플 정보 조회
      final coupleDoc = await _firestore
          .collection('couples')
          .doc(coupleId)
          .get();

      if (!coupleDoc.exists) {
        throw const NoCoupleException(message: '커플 정보를 찾을 수 없습니다');
      }

      return CoupleModel.fromFirestore(coupleDoc.data()!, coupleDoc.id);
    } on NoCoupleException {
      rethrow;
    } on FirebaseException catch (e) {
      throw DatabaseException('커플 정보 조회 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '커플 정보 조회 중 네트워크 오류', originalError: e);
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
      // 1. 권한 확인: 커플 정보 조회하여 user1Id 또는 user2Id인지 확인
      final coupleDoc = await _firestore
          .collection('couples')
          .doc(coupleId)
          .get();

      if (!coupleDoc.exists) {
        throw const DatabaseException('커플 정보를 찾을 수 없습니다');
      }

      final coupleData = coupleDoc.data()!;
      final user1Id = coupleData['user1Id'] as String;
      final user2Id = coupleData['user2Id'] as String;

      if (userId != user1Id && userId != user2Id) {
        throw const UnauthorizedException(message: '커플 연결을 해제할 권한이 없습니다');
      }

      // 2. users 문서 업데이트 (두 사용자의 coupleId = null)
      final batch = _firestore.batch();
      batch.update(_firestore.collection('users').doc(user1Id), {
        'coupleId': null,
      });
      batch.update(_firestore.collection('users').doc(user2Id), {
        'coupleId': null,
      });

      // 3. couples 문서 삭제
      batch.delete(coupleDoc.reference);

      await batch.commit();
    } on UnauthorizedException {
      rethrow;
    } on FirebaseException catch (e) {
      throw DatabaseException('커플 연결 해제 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '커플 연결 해제 중 네트워크 오류', originalError: e);
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
      // couples 문서 업데이트 (dailyVersePlan 맵 필드)
      await _firestore.collection('couples').doc(coupleId).update({
        'dailyVersePlan': plan.toFirestore(),
      });

      // 업데이트된 문서 조회
      final coupleDoc = await _firestore
          .collection('couples')
          .doc(coupleId)
          .get();

      return CoupleModel.fromFirestore(coupleDoc.data()!, coupleDoc.id);
    } on FirebaseException catch (e) {
      throw DatabaseException('플랜 업데이트 실패', code: e.code, originalError: e);
    } catch (e) {
      throw NetworkException(message: '플랜 업데이트 중 네트워크 오류', originalError: e);
    }
  }
}
