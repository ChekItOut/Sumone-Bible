import 'package:flutter/material.dart';

import '../../../widgets/dialogs/confirm_dialog.dart';

/// 커플 연결 해제 확인 다이얼로그
///
/// 파트너와의 연결 해제 전 최종 확인
class DisconnectDialog {
  /// 다이얼로그 표시
  ///
  /// 반환값: true (연결 해제 확인), false/null (취소)
  static Future<bool?> show(BuildContext context) {
    return ConfirmDialog.show(
      context,
      title: '파트너 연결 해제',
      message:
          '정말 파트너와의 연결을 해제하시겠습니까?\n\n'
          '연결 해제 시:\n'
          '• 함께 설정한 플랜이 삭제됩니다\n'
          '• 작성한 모든 소감이 삭제됩니다\n'
          '• 스트릭 기록이 초기화됩니다\n\n'
          '이 작업은 되돌릴 수 없습니다.',
      confirmText: '연결 해제',
      cancelText: '취소',
    );
  }
}
