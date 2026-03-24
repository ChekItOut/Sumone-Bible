import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 클라이언트 전역 인스턴스
///
/// 앱 전체에서 동일한 Supabase 클라이언트를 사용하기 위한 전역 변수
/// main.dart에서 Supabase.initialize() 호출 후 사용 가능
///
/// 사용 예시:
/// ```dart
/// final user = supabase.auth.currentUser;
/// final data = await supabase.from('users').select();
/// ```
final supabase = Supabase.instance.client;
