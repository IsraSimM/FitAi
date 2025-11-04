import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/state/app_settings_controller.dart';
import '../../../app/state/user_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/free_t_top_bar.dart';
import '../../../domain/entities/dashboard_snapshot.dart';
import '../../../domain/entities/routine.dart';
import '../../../domain/entities/tip.dart';
import '../../notifications/presentation/notifications_sheet.dart';
import '../../settings/presentation/settings_sheet.dart';
import '../application/dashboard_controller.dart';

/// Vista principal que muestra progreso diario, rutina y tips personalizados.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  static const routeName = 'dashboard';
  static const routePath = '/dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final dashboardController = ref.read(dashboardControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final userState = ref.watch(userControllerProvider);

    final username = userState.maybeWhen(
      data: (profile) => profile.displayName,
      orElse: () => 'FreeT',
    );
    final photoUrl = userState.asData?.value.photoUrl;

    return Scaffold(
      appBar: FreeTTopBar(
        username: username,
        photoUrl: photoUrl,
        onNotificationsPressed: () => _openNotifications(context),
        onSettingsPressed: () => _openSettings(context),
      ),
      body: RefreshIndicator(
        onRefresh: dashboardController.refresh,
        child: dashboardState.snapshot.when(
          data: (snapshot) {
            return CustomScrollView(
              slivers: <Widget>[
                if (dashboardState.attendanceJustRegistered)
                  const SliverToBoxAdapter(
                    child: _AttendanceBanner(),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        _SummarySection(summary: snapshot.summary),
                        const SizedBox(height: AppSpacing.lg),
                        _RoutineSection(routine: snapshot.todaysRoutine),
                        const SizedBox(height: AppSpacing.lg),
                        _StatsSection(stats: snapshot.weeklyStats),
                        const SizedBox(height: AppSpacing.lg),
                        _GoalsSection(goals: snapshot.goals),
                        const SizedBox(height: AppSpacing.lg),
                        _TipsSection(tips: snapshot.tips),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _DashboardError(
            message: l10n.dashboardError,
            onRetry: dashboardController.load,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: dashboardState.isRefreshing ? null : dashboardController.registerAttendance,
        icon: const Icon(Icons.check_circle_outline),
        label: Text(dashboardState.attendanceJustRegistered ? l10n.dashboardAttendanceRegistered : l10n.dashboardRegisterAttendance),
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const NotificationsSheet(),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SettingsSheet(),
      ),
    );
  }
}

class _AttendanceBanner extends ConsumerWidget {
  const _AttendanceBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.emoji_events_outlined),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.dashboardStreakBanner,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.summary});

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cards = <Widget>[
      _SummaryCard(
        title: l10n.dashboardSummaryProgressTitle,
        value: '${(summary.completion * 100).round()}%',
        subtitle: l10n.dashboardSummaryProgressSubtitle,
        icon: Icons.task_alt,
      ),
      _SummaryCard(
        title: l10n.dashboardSummaryStreakTitle,
        value: l10n.timeDays(summary.activeStreak),
        subtitle: l10n.dashboardSummaryStreakSubtitle,
        icon: Icons.local_fire_department_outlined,
      ),
      _SummaryCard(
        title: l10n.dashboardSummaryCaloriesTitle,
        value: '${summary.calories} kcal',
        subtitle: l10n.dashboardSummaryCaloriesSubtitle,
        icon: Icons.local_fire_department,
      ),
      _SummaryCard(
        title: l10n.dashboardSummaryReadinessTitle,
        value: '${summary.readinessScore.round()}%',
        subtitle: l10n.dashboardSummaryReadinessSubtitle,
        icon: Icons.bolt_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.dashboardSummaryTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: cards,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutineSection extends ConsumerWidget {
  const _RoutineSection({required this.routine});

  final List<RoutineExercise> routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(l10n.dashboardRoutineTitle,
                style: Theme.of(context).textTheme.titleLarge),
            TextButton.icon(
              onPressed: () =>
                  ref.read(dashboardControllerProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh_outlined),
              label: Text(l10n.commonRefresh),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...routine.map(
          (exercise) => Card(
            child: ListTile(
              title: Text(exercise.name),
              subtitle: Text(
                l10n.routineSetsReps(exercise.sets, exercise.reps),
              ),
              trailing: exercise.weight != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${exercise.weight!.toStringAsFixed(1)} kg',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        if (exercise.recommendedWeight != null)
                          Text(
                            '${l10n.routineRecommended}: ${exercise.recommendedWeight!.toStringAsFixed(1)} kg',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    )
                  : Text(
                      l10n.routineBodyweight,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.stats});

  final List<TrendStat> stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.dashboardStatsTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: stats
              .map(
                (stat) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(stat.label,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: AppSpacing.sm),
                          LinearProgressIndicator(
                            value: (stat.latestValue / stat.goalValue).clamp(0, 1),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '${l10n.dashboardStatsLatest}: ${stat.latestValue.toStringAsFixed(1)} ${stat.unit}',
                          ),
                          Text(
                            '${l10n.dashboardStatsGoal}: ${stat.goalValue.toStringAsFixed(1)} ${stat.unit}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _GoalsSection extends StatelessWidget {
  const _GoalsSection({required this.goals});

  final List<GoalProgress> goals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.dashboardGoalsTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ...goals.map(
          (goal) => Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(goal.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('${(goal.completion * 100).round()}%'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(value: goal.completion),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${l10n.dashboardGoalCurrent}: ${goal.current.toStringAsFixed(1)} ${goal.unit}',
                  ),
                  Text(
                    '${l10n.dashboardGoalTarget}: ${goal.target.toStringAsFixed(1)} ${goal.unit}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsSection extends StatelessWidget {
  const _TipsSection({required this.tips});

  final List<Tip> tips;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.dashboardTipsTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ...tips.map(
          (tip) => Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(tip.category.name.isNotEmpty
                    ? tip.category.name[0].toUpperCase()
                    : '?'),
              ),
              title: Text(tip.title),
              subtitle: Text(tip.description),
              trailing: tip.ctaLabel != null
                  ? TextButton(
                      onPressed: () {},
                      child: Text(tip.ctaLabel!),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_outlined),
            label: Text(l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}
