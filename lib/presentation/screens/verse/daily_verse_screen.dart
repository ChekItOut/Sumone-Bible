import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../domain/entities/daily_verse.dart';
import '../../providers/auth_provider.dart';
import '../../providers/couple_provider.dart';
import '../../providers/verse_provider.dart';
import '../../providers/verse_state.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/base_card.dart';
import '../../widgets/loading/loading_indicator.dart';
import 'widgets/question_card.dart';
import 'widgets/verse_text.dart';

class DailyVerseScreen extends ConsumerStatefulWidget {
  final String? verseId;

  const DailyVerseScreen({super.key, this.verseId});

  @override
  ConsumerState<DailyVerseScreen> createState() => _DailyVerseScreenState();
}

class _DailyVerseScreenState extends ConsumerState<DailyVerseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVerse();
    });
  }

  Future<void> _loadVerse() async {
    final verseNotifier = ref.read(verseProvider.notifier);
    final verseState = ref.read(verseProvider);

    if (widget.verseId != null) {
      await verseNotifier.loadVerseById(widget.verseId!);
      return;
    }

    if (verseState.todayVerse != null) {
      return;
    }

    final authState = ref.read(authProvider);
    final coupleState = ref.read(coupleProvider);
    final coupleId = coupleState.couple?.coupleId;

    if (authState.user != null && coupleId != null) {
      await verseNotifier.loadDashboardData(coupleId: coupleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final verseState = ref.watch(verseProvider);
    final verse = widget.verseId != null
        ? verseState.selectedVerse
        : (verseState.todayVerse ?? verseState.selectedVerse);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Today\'s Verse'),
      body: SafeArea(
        child: verseState.isLoading && verse == null
            ? const Center(child: LoadingIndicator())
            : _buildBody(context, verseState, verse),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    VerseState verseState,
    DailyVerse? verse,
  ) {
    if (verse == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BaseCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 56,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  verseState.error ?? 'There is no verse to display.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VerseText(reference: verse.reference, text: verse.textKorean),
          const SizedBox(height: 16),
          QuestionCard(
            question: verse.questionKorean,
            isLoading: verseState.isGenerating,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Write Reflection',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'The reflection screen will be connected in Phase 3.',
                  ),
                ),
              );
            },
            fullWidth: true,
            icon: Icons.edit_outlined,
          ),
        ],
      ),
    );
  }
}
