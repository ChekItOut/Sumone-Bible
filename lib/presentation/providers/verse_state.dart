import '../../domain/entities/daily_verse.dart';

class VerseState {
  static const Object _unset = Object();

  final bool isLoading;
  final bool isGenerating;
  final DailyVerse? todayVerse;
  final DailyVerse? selectedVerse;
  final String? error;
  final List<DailyVerse> weeklyVerses;

  const VerseState({
    required this.isLoading,
    required this.isGenerating,
    this.todayVerse,
    this.selectedVerse,
    this.error,
    required this.weeklyVerses,
  });

  factory VerseState.initial() =>
      const VerseState(isLoading: false, isGenerating: false, weeklyVerses: []);

  VerseState copyWith({
    bool? isLoading,
    bool? isGenerating,
    Object? todayVerse = _unset,
    Object? selectedVerse = _unset,
    Object? error = _unset,
    List<DailyVerse>? weeklyVerses,
  }) {
    return VerseState(
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      todayVerse: identical(todayVerse, _unset)
          ? this.todayVerse
          : todayVerse as DailyVerse?,
      selectedVerse: identical(selectedVerse, _unset)
          ? this.selectedVerse
          : selectedVerse as DailyVerse?,
      error: identical(error, _unset) ? this.error : error as String?,
      weeklyVerses: weeklyVerses ?? this.weeklyVerses,
    );
  }
}
