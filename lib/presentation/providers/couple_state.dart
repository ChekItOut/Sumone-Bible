import '../../domain/entities/couple.dart';
import '../../domain/entities/invite_link.dart';

/// 커플 상태 클래스
///
/// 불변 상태 클래스
/// copyWith를 통해 안전하게 상태 업데이트
class CoupleState {
  /// 로딩 중인지 여부
  final bool isLoading;

  /// 현재 커플 정보 (null이면 연결되지 않은 상태)
  final Couple? couple;

  /// 생성된 초대 링크 (null이면 링크 미생성)
  final InviteLink? inviteLink;

  /// 에러 메시지 (null이면 에러 없음)
  final String? error;

  const CoupleState({
    required this.isLoading,
    this.couple,
    this.inviteLink,
    this.error,
  });

  /// 초기 상태
  factory CoupleState.initial() => const CoupleState(
        isLoading: false,
        couple: null,
        inviteLink: null,
        error: null,
      );

  /// 로딩 상태
  factory CoupleState.loading() => const CoupleState(
        isLoading: true,
        couple: null,
        inviteLink: null,
        error: null,
      );

  /// 커플 로드 완료 상태
  factory CoupleState.loaded(Couple couple) => CoupleState(
        isLoading: false,
        couple: couple,
        inviteLink: null,
        error: null,
      );

  /// 초대 링크 생성 완료 상태
  factory CoupleState.inviteLinkCreated(InviteLink inviteLink) => CoupleState(
        isLoading: false,
        couple: null,
        inviteLink: inviteLink,
        error: null,
      );

  /// 에러 상태
  factory CoupleState.error(String message) => CoupleState(
        isLoading: false,
        couple: null,
        inviteLink: null,
        error: message,
      );

  /// copyWith 메서드 (상태 업데이트)
  CoupleState copyWith({
    bool? isLoading,
    Couple? couple,
    InviteLink? inviteLink,
    String? error,
  }) {
    return CoupleState(
      isLoading: isLoading ?? this.isLoading,
      couple: couple ?? this.couple,
      inviteLink: inviteLink ?? this.inviteLink,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoupleState &&
        other.isLoading == isLoading &&
        other.couple == couple &&
        other.inviteLink == inviteLink &&
        other.error == error;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        couple.hashCode ^
        inviteLink.hashCode ^
        error.hashCode;
  }

  @override
  String toString() {
    return 'CoupleState(isLoading: $isLoading, isConnected: $isConnected, hasPlan: $hasPlan, hasError: $hasError)';
  }
}

/// CoupleState 확장
extension CoupleStateX on CoupleState {
  /// 커플에 연결되어 있는지 확인
  bool get isConnected => couple != null;

  /// 플랜이 설정되어 있는지 확인
  bool get hasPlan => couple?.hasPlan ?? false;

  /// 에러가 있는지 확인
  bool get hasError => error != null;

  /// 초대 링크가 생성되었는지 확인
  bool get hasInviteLink => inviteLink != null;
}
