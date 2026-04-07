/// 앱 설정 (Feature Flags)
///
/// Supabase와 Firebase 병행 운영을 위한 Feature Flag
class AppConfig {
  /// Firebase 사용 여부
  ///
  /// - true: Firebase 사용 (Phase 1 테스트 중 🔥)
  /// - false: Supabase 사용
  static const bool useFirebase = true; // Phase 1 테스트: Firebase 활성화!

  /// 디버그 모드
  static const bool isDebug = true;

  /// 로그 레벨
  static const String logLevel = 'debug'; // 'debug', 'info', 'warning', 'error'
}
