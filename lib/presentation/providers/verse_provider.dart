import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/supabase_client.dart';
import '../../core/utils/logger.dart';
import '../../data/models/daily_verse_model.dart';
import '../../domain/entities/daily_verse.dart';
import 'verse_state.dart';

class VerseNotifier extends StateNotifier<VerseState> {
  VerseNotifier() : super(VerseState.initial());

  Future<void> loadDashboardData({required String coupleId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      DailyVerse? todayVerse = await _fetchTodayVerse();
      var weeklyVerses = await _fetchWeeklyVerses();

      if (todayVerse == null && coupleId.isNotEmpty) {
        final generated = await _tryGenerateTodayVerse();
        if (generated) {
          todayVerse = await _fetchTodayVerse();
          weeklyVerses = await _fetchWeeklyVerses();
        }
      }

      state = state.copyWith(
        isLoading: false,
        todayVerse: todayVerse,
        selectedVerse: todayVerse,
        weeklyVerses: weeklyVerses,
        error: todayVerse == null ? 'Today\'s verse is not ready yet.' : null,
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

  Future<void> loadVerseById(String verseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await supabase
          .from('daily_verses')
          .select()
          .eq('verse_id', verseId)
          .maybeSingle();

      final verse = response == null
          ? null
          : DailyVerseModel.fromJson(response).toEntity();

      state = state.copyWith(
        isLoading: false,
        selectedVerse: verse,
        error: verse == null ? 'Could not find the selected verse.' : null,
      );
    } catch (error) {
      logger.error('VerseNotifier: failed to load verse detail', error: error);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load verse details.',
      );
    }
  }

  Future<DailyVerse?> _fetchTodayVerse() async {
    final response = await supabase
        .from('daily_verses')
        .select()
        .eq('date', _formatDate(DateTime.now()))
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return DailyVerseModel.fromJson(response).toEntity();
  }

  Future<List<DailyVerse>> _fetchWeeklyVerses() async {
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 6));

    final response = await supabase
        .from('daily_verses')
        .select()
        .gte('date', _formatDate(startDate))
        .lte('date', _formatDate(today))
        .order('date');

    return response
        .map((row) => DailyVerseModel.fromJson(row).toEntity())
        .toList();
  }

  Future<bool> _tryGenerateTodayVerse() async {
    try {
      state = state.copyWith(isGenerating: true);
      logger.info('VerseNotifier: invoking generate-daily-verse function');
      await supabase.functions.invoke(
        'generate-daily-verse',
        body: {'triggeredBy': 'app'},
      );
      return true;
    } catch (error) {
      logger.warning('VerseNotifier: edge function failed - $error');
      return false;
    } finally {
      state = state.copyWith(isGenerating: false);
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

final verseProvider = StateNotifierProvider<VerseNotifier, VerseState>((ref) {
  return VerseNotifier();
});
