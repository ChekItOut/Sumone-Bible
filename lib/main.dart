import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

/// Bible SumOne 앱 진입점
///
/// 초기화 순서:
/// 1. Flutter 바인딩 초기화
/// 2. 환경 변수 로드 (.env)
/// 3. Supabase 초기화 ✅ Phase 0.2 완료
/// 4. Riverpod ProviderScope로 앱 실행
void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: '.env');

  // Supabase 초기화
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // TODO: Phase 5.1 - Firebase 초기화
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // 앱 실행
  runApp(const ProviderScope(child: BibleSumOneApp()));
}
