import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/supabase_couple_datasource.dart';
import '../../data/repositories/couple_repository_impl.dart';
import '../../domain/entities/daily_verse_plan.dart';
import '../../domain/repositories/couple_repository.dart';
import '../../domain/usecases/couple/accept_invite_usecase.dart';
import '../../domain/usecases/couple/create_invite_link_usecase.dart';
import '../../domain/usecases/couple/disconnect_couple_usecase.dart';
import '../../domain/usecases/couple/get_couple_usecase.dart';
import '../../domain/usecases/couple/update_daily_verse_plan_usecase.dart';
import 'couple_state.dart';

/// CoupleRepository Provider
///
/// Repository 싱글톤 제공
final coupleRepositoryProvider = Provider<CoupleRepository>((ref) {
  final dataSource = SupabaseCoupleDataSource();
  return CoupleRepositoryImpl(dataSource: dataSource);
});

/// CoupleProvider (StateNotifier)
///
/// 커플 상태를 관리하고, 초대/연결/플랜 설정 등의 작업 수행
class CoupleNotifier extends StateNotifier<CoupleState> {
  final CoupleRepository _repository;

  // UseCases
  late final CreateInviteLinkUseCase _createInviteLinkUseCase;
  late final AcceptInviteUseCase _acceptInviteUseCase;
  late final GetCoupleUseCase _getCoupleUseCase;
  late final DisconnectCoupleUseCase _disconnectCoupleUseCase;
  late final UpdateDailyVersePlanUseCase _updateDailyVersePlanUseCase;

  CoupleNotifier(this._repository) : super(CoupleState.initial()) {
    // UseCases 초기화
    _createInviteLinkUseCase = CreateInviteLinkUseCase(_repository);
    _acceptInviteUseCase = AcceptInviteUseCase(_repository);
    _getCoupleUseCase = GetCoupleUseCase(_repository);
    _disconnectCoupleUseCase = DisconnectCoupleUseCase(_repository);
    _updateDailyVersePlanUseCase = UpdateDailyVersePlanUseCase(_repository);
  }

  /// 커플 정보 조회
  ///
  /// [userId] 조회할 사용자 ID
  Future<void> loadCouple(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getCoupleUseCase.call(userId);

    result.fold(
      (failure) {
        // 커플 정보가 없는 경우는 에러가 아니라 정상 상태
        if (failure.message.contains('찾을 수 없습니다')) {
          state = CoupleState.initial();
        } else {
          state = state.copyWith(isLoading: false, error: failure.message);
        }
      },
      (couple) => state = CoupleState.loaded(couple),
    );
  }

  /// 초대 링크 생성
  ///
  /// [userId] 초대를 생성하는 사용자 ID
  Future<void> createInviteLink(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _createInviteLinkUseCase.call(userId);

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (inviteLink) {
        state = CoupleState.inviteLinkCreated(inviteLink);
      },
    );
  }

  /// 초대 수락 (커플 연결)
  ///
  /// [token] 초대 링크 토큰
  /// [accepterId] 초대를 수락하는 사용자 ID
  Future<void> acceptInvite({
    required String token,
    required String accepterId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _acceptInviteUseCase.call(
      AcceptInviteParams(token: token, accepterId: accepterId),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (couple) => state = CoupleState.loaded(couple),
    );
  }

  /// 커플 연결 해제
  ///
  /// [coupleId] 해제할 커플 ID
  /// [userId] 해제를 요청하는 사용자 ID
  Future<void> disconnectCouple({
    required String coupleId,
    required String userId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _disconnectCoupleUseCase.call(
      DisconnectCoupleParams(coupleId: coupleId, userId: userId),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = CoupleState.initial(), // 연결 해제 성공 -> 초기 상태
    );
  }

  /// 일일 말씀 플랜 업데이트
  ///
  /// [coupleId] 플랜을 업데이트할 커플 ID
  /// [plan] 새로운 플랜 정보
  Future<void> updateDailyVersePlan({
    required String coupleId,
    required DailyVersePlan plan,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _updateDailyVersePlanUseCase.call(
      UpdateDailyVersePlanParams(coupleId: coupleId, plan: plan),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (couple) => state = CoupleState.loaded(couple),
    );
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 초대 링크 초기화
  void clearInviteLink() {
    state = state.copyWith(inviteLink: null);
  }
}

/// CoupleProvider 전역 인스턴스
final coupleProvider = StateNotifierProvider<CoupleNotifier, CoupleState>((ref) {
  final repository = ref.read(coupleRepositoryProvider);
  return CoupleNotifier(repository);
});
