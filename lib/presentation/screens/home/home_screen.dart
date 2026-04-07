import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/daily_verse.dart';
import '../../providers/auth_provider.dart';
import '../../providers/couple_provider.dart';
import '../../providers/couple_state.dart';
import '../../providers/verse_provider.dart';
import '../../providers/verse_state.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/base_card.dart';
import '../../widgets/loading/loading_indicator.dart';
import '../_test/widgets/holy_fire_widget.dart';
import '../couple/widgets/couple_status_card.dart';
import 'widgets/daily_verse_card.dart';
import 'widgets/weekly_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCoupleData();
    });
  }

  Future<void> _loadCoupleData() async {
    final authState = ref.read(authProvider);

    if (authState.isLoading) {
      logger.debug('HomeScreen: auth state is still loading');
      return;
    }

    final user = authState.user;
    if (user == null) {
      logger.error('HomeScreen: user not found while opening home');
      if (mounted) {
        context.go('/onboarding');
      }
      return;
    }

    await ref.read(coupleProvider.notifier).loadCouple(user.id);
    final coupleState = ref.read(coupleProvider);

    if (coupleState.isConnected && coupleState.hasPlan) {
      await ref
          .read(verseProvider.notifier)
          .loadDashboardData(coupleId: coupleState.couple!.coupleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final coupleState = ref.watch(coupleProvider);
    final verseState = ref.watch(verseProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Bible SumOne',
        showBackButton: false,
        centerTitle: true,
        actions: [
          if (coupleState.isConnected)
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => context.push('/couple/manage'),
              tooltip: 'Manage couple',
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings will be added in Phase 5.'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCoupleData,
          child: coupleState.isLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${authState.user?.name ?? 'User'}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _buildCoupleStatusSection(context, coupleState),
                      const SizedBox(height: 24),
                      _buildWeeklyCalendarSection(
                        context,
                        coupleState,
                        verseState,
                      ),
                      const SizedBox(height: 24),
                      _buildHolyFireSection(context),
                      const SizedBox(height: 24),
                      _buildDailyVerseSection(context, coupleState, verseState),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCoupleStatusSection(
    BuildContext context,
    CoupleState coupleState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Couple Status',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (coupleState.isConnected)
          Column(
            children: [
              CoupleStatusCard(
                couple: coupleState.couple!,
                onManageTap: () => context.push('/couple/manage'),
              ),
              if (!coupleState.couple!.hasPlan) ...[
                const SizedBox(height: 16),
                BaseCard(
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 48,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Set up your reading plan',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Once the plan is ready, a new verse and question will appear here every day.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Set Plan',
                        onPressed: () => context.push('/couple/plan'),
                        icon: Icons.book,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          )
        else
          _buildCoupleNotConnectedCard(context),
      ],
    );
  }

  Widget _buildCoupleNotConnectedCard(BuildContext context) {
    return BaseCard(
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'You are not connected with a partner yet.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Send an invite link to start reading together.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Invite Partner',
            onPressed: () => context.push('/couple/invite'),
            icon: Icons.send,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCalendarSection(
    BuildContext context,
    CoupleState coupleState,
    VerseState verseState,
  ) {
    if (!coupleState.isConnected || !coupleState.hasPlan) {
      return const SizedBox.shrink();
    }

    final weekData = _buildWeeklyStatuses(verseState.weeklyVerses);

    return WeeklyCalendar(
      weekData: weekData,
      onTapDate: (item) {
        if (item.verse != null) {
          context.push('/verse/${item.verse!.verseId}');
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Detailed history for this date will be added later.',
            ),
          ),
        );
      },
    );
  }

  Widget _buildHolyFireSection(BuildContext context) {
    return BaseCard(
      child: Row(
        children: [
          const HolyFireWidget(
            imagePath: 'assets/_test/holy_fire_sample.png',
            size: 92,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Holy Fire',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This placeholder reserves the streak character area for a later phase.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyVerseSection(
    BuildContext context,
    CoupleState coupleState,
    VerseState verseState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Verse',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (!coupleState.isConnected)
          _buildInfoCard(
            context,
            icon: Icons.favorite_border,
            title:
                'Connect with your partner to start today\'s verse together.',
            description: 'Finish the couple invite flow first.',
          )
        else if (!coupleState.hasPlan)
          _buildInfoCard(
            context,
            icon: Icons.auto_stories_outlined,
            title: 'Set a reading plan to receive today\'s verse.',
            description:
                'Choose your starting point and range, then the card will appear here.',
          )
        else
          DailyVerseCard(
            verse: verseState.todayVerse,
            isLoading: verseState.isLoading || verseState.isGenerating,
            onTap: verseState.todayVerse == null
                ? null
                : () => context.push('/verse/daily'),
          ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return BaseCard(
      child: Column(
        children: [
          Icon(icon, size: 52, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<WeeklyVerseStatus> _buildWeeklyStatuses(List<DailyVerse> weeklyVerses) {
    final today = DateTime.now();
    final normalizedToday = _normalizeDate(today);
    final startDate = normalizedToday.subtract(const Duration(days: 6));
    final verseMap = {
      for (final verse in weeklyVerses) _normalizeDate(verse.date): verse,
    };

    return List.generate(7, (index) {
      final date = startDate.add(Duration(days: index));
      final verse = verseMap[_normalizeDate(date)];

      return WeeklyVerseStatus(
        date: date,
        isCompleted: verse != null,
        isToday: _normalizeDate(date) == normalizedToday,
        verse: verse,
      );
    });
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
