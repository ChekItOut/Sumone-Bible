/// 앱 설정 (Feature Flags)
///
/// Supabase와 Firebase 병행 운영을 위한 Feature Flag
class AppConfig {
  /// Firebase 사용 여부
  ///
  /// - true: Firebase 사용 (마이그레이션 완료 후)
  /// - false: Supabase 사용 (현재)
  static const bool useFirebase = false;

  /// 디버그 모드
  static const bool isDebug = true;

  /// 로그 레벨
  static const String logLevel = 'debug'; // 'debug', 'info', 'warning', 'error'
}
