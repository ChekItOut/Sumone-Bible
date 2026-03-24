/// 앱 전역 상수
///
/// 앱 설정, 제한값, 기본값 등을 중앙 관리
class AppConstants {
  // ==================== 앱 정보 ====================
  static const String appName = 'Bible SumOne';
  static const String appVersion = '1.0.0';

  // ==================== 답변 관련 ====================
  static const int maxResponseLength = 500; // 최대 글자 수
  static const int recommendedResponseLength = 200; // 권장 글자 수

  // ==================== 스트릭 마일스톤 ====================
  static const List<int> streakMilestones = [7, 30, 100, 365];

  // ==================== 무료 vs 프리미엄 ====================
  static const int freeHistoryDays = 7; // 무료: 최근 7일만 보기

  // ==================== 알림 ====================
  static const String defaultNotificationTime = '09:00:00'; // 오전 9시

  // ==================== 성경 번역본 ====================
  static const String defaultBibleTranslation = 'KRV'; // 개역개정
  static const List<String> supportedTranslations = [
    'KRV', // 개역개정
    'NIV', // New International Version
  ];

  // ==================== 테마 ====================
  static const String defaultTheme = 'light';

  // ==================== 캐시 ====================
  static const int bibleCacheExpireDays = 30; // 성경 구절 캐시 유효 기간

  // ==================== AI ====================
  static const int maxQuestionLength = 50; // AI 생성 질문 최대 길이
  static const int aiRequestTimeout = 30; // AI API 타임아웃 (초)

  // ==================== 페이지네이션 ====================
  static const int defaultPageSize = 20;
}
