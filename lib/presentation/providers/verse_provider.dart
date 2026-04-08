import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_config.dart';
import '../../core/utils/logger.dart';
import '../../data/datasources/firebase_verse_datasource.dart';
import '../../data/datasources/supabase_verse_datasource.dart';
import '../../data/repositories/verse_repository_impl.dart';
import '../../domain/repositories/verse_repository.dart';
import 'verse_state.dart';

/// VerseRepository Provider
///
/// Repository 싱글톤 제공
/// Feature Flag에 따라 Firebase 또는 Supabase DataSource 사용
final verseRepositoryProvider = Provider<VerseRepository>((ref) {
  if (AppConfig.useFirebase) {
    // Firebase 사용
    final firebaseDataSource = FirebaseVerseDataSource();
    return VerseRepositoryImpl(firebaseDataSource: firebaseDataSource);
  } else {
    // Supabase 사용
    final supabaseDataSource = SupabaseVerseDataSource();
    return VerseRepositoryImpl(supabaseDataSource: supabaseDataSource);
  }
});

/// VerseProvider (StateNotifier)
///
/// 말씀 상태를 관리하고, 말씀 조회 등의 작업 수행
class VerseNotifier extends StateNotifier<VerseState> {
  final VerseRepository _repository;

  VerseNotifier(this._repository) : super(VerseState.initial());

  /// 대시보드 데이터 로드 (오늘의 말씀 + 주간 말씀)
  ///
  /// [coupleId] 커플 ID (Edge Function 호출용)
  Future<void> loadDashboardData({required String coupleId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. 오늘의 말씀 조회
      final todayVerseResult = await _repository.getTodayVerse();

      // 2. 주간 말씀 조회 (최근 7일)
      final weeklyVersesResult = await _repository.getVerseHistory(coupleId, 7);

      // 3. 결과 처리
      todayVerseResult.fold(
        (failure) {
          // 오늘의 말씀이 없는 경우
          logger.warning(
            'VerseNotifier: 오늘의 말씀을 찾을 수 없습니다 - ${failure.message}',
          );

          weeklyVersesResult.fold(
            (weeklyFailure) {
              // 주간 말씀도 실패
              state = state.copyWith(
                isLoading: false,
                error: 'Failed to load the verse. Please try again shortly.',
              );
            },
            (weeklyVerses) {
              // 주간 말씀만 성공
              state = state.copyWith(
                isLoading: false,
                todayVerse: null,
                selectedVerse: null,
                weeklyVerses: weeklyVerses,
                error: 'Today\'s verse is not ready yet.',
              );
            },
          );
        },
        (todayVerse) {
          // 오늘의 말씀 성공
          weeklyVersesResult.fold(
            (weeklyFailure) {
              // 주간 말씀 실패 (오늘 말씀만 표시)
              logger.warning(
                'VerseNotifier: 주간 말씀 조회 실패 - ${weeklyFailure.message}',
              );
              state = state.copyWith(
                isLoading: false,
                todayVerse: todayVerse,
                selectedVerse: todayVerse,
                weeklyVerses: [],
                error: null,
              );
            },
            (weeklyVerses) {
              // 모두 성공
              state = state.copyWith(
                isLoading: false,
                todayVerse: todayVerse,
                selectedVerse: todayVerse,
                weeklyVerses: weeklyVerses,
                error: null,
              );
            },
          );
        },
      );
    } catch (error) {
      logger.error(
        'VerseNotifier: failed to load dashboard verse data',
        error: error,
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load the verse. Please try again shortly.',
      );
    }
  }

  /// 특정 말씀 조회 (ID 기반)
  ///
  /// [verseId] 말씀 ID
  ///
  /// NOTE: 현재 Repository에는 ID 기반 조회 메서드가 없으므로
  /// 임시로 주석 처리. 필요시 Repository에 메서드 추가 필요.
  Future<void> loadVerseById(String verseId) async {
    state = state.copyWith(isLoading: true, error: null);

    // TODO: Repository에 getVerseById 메서드 추가 필요
    // 현재는 기능 사용하지 않으므로 에러 처리만
    logger.warning('VerseNotifier: loadVerseById는 아직 지원되지 않습니다');
    state = state.copyWith(
      isLoading: false,
      error: 'This feature is not yet supported.',
    );
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// VerseProvider 전역 인스턴스
final verseProvider = StateNotifierProvider<VerseNotifier, VerseState>((ref) {
  final repository = ref.read(verseRepositoryProvider);
  return VerseNotifier(repository);
});
