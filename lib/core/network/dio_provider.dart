import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:logger/logger.dart' as log;

/// Dio Provider
///
/// 책임:
/// - Dio 인스턴스 생성 및 제공
/// - HTTP 클라이언트 설정
/// - 로깅 인터셉터 추가
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // 로깅 인터셉터 추가 (개발 환경)
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );

  final logger = log.Logger();
  logger.i('✅ Dio 인스턴스 생성 완료');

  return dio;
});
