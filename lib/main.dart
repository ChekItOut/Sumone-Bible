import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // flutterfire configure 실행 후 생성됨
import 'package:logger/logger.dart';
import 'app/app.dart';
import 'data/datasources/local_bible_datasource.dart';
import 'core/constants/app_config.dart';

/// Bible SumOne 앱 진입점
///
/// 초기화 순서:
/// 1. Flutter 바인딩 초기화
/// 2. 환경 변수 로드 (.env)
/// 3. Supabase 초기화 ✅ Phase 0.2 완료
/// 4. Firebase 초기화 🔄 Phase 0 진행 중
/// 5. Bible 데이터 초기화 ✅ Phase 2.1 완료
/// 6. Riverpod ProviderScope로 앱 실행
void main() async {
  final logger = Logger();

  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: '.env');

  // Supabase 초기화
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      // 웹 환경에서도 세션 유지
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Bible 데이터 초기화 (Phase 2.1)
  try {
    final bibleDataSource = LocalBibleDataSource();
    await bibleDataSource.initialize();
    logger.i('✅ Bible 데이터 초기화 완료');
  } catch (e) {
    logger.e('❌ Bible 데이터 초기화 실패: $e');
    // 앱은 계속 실행 (오프라인 기능 제한)
  }

  // Firebase 초기화 (Phase 0)
  // NOTE: firebase_options.dart는 'flutterfire configure' 명령어로 생성됩니다
  if (AppConfig.useFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('✅ Firebase 초기화 완료');
  }

  // 앱 실행
  runApp(const ProviderScope(child: BibleSumOneApp()));
}
