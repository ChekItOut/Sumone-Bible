import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API 관련 상수
///
/// 모든 외부 API URL과 엔드포인트를 중앙 관리
/// .env 파일에서 환경 변수 로드
class ApiConstants {
  // ==================== Supabase ====================
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // ==================== Bible (로컬 JSON) ====================
  // NOTE: 로컬 JSON 파일 사용 (assets/data/bible.json)
  // 외부 API 불필요

  // ==================== Gemini API ====================
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get geminiApiUrl =>
      dotenv.env['GEMINI_API_URL'] ??
      'https://generativelanguage.googleapis.com/v1beta';

  static String get geminiGenerateContentUrl =>
      '$geminiApiUrl/models/gemini-1.5-flash:generateContent?key=$geminiApiKey';

  // ==================== Firebase ====================
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
}
