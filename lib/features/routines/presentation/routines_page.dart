import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/state/user_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/free_t_top_bar.dart';
import '../../../domain/entities/routine.dart';
import '../../notifications/presentation/notifications_sheet.dart';
import '../../settings/presentation/settings_sheet.dart';
import '../application/routines_controller.dart';

class RoutinesPage extends ConsumerWidget {
  const RoutinesPage({super.key});

  static const routeName = 'routines';
  static const routePath = '/routines';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesState = ref.watch(routinesControllerProvider);
    final routinesController = ref.read(routinesControllerProvider.notifier);
    final userState = ref.watch(userControllerProvider);
    final l10n = AppLocalizations.of(context);

    final username = userState.maybeWhen(
      data: (profile) => profile.displayName,
      orElse: () => 'FreeT',
    );

    return Scaffold(
      appBar: FreeTTopBar(
        username: username,
        onNotificationsPressed: () => _openNotifications(context),
        onSettingsPressed: () => _openSettings(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  l10n.routinesTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                FilledButton.icon(
                  onPressed: routinesState.isGenerating
                      ? null
                      : () => routinesController.generateRoutine(routinesState.focusFilter),
                  icon: routinesState.isGenerating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    routinesState.isGenerating
                        ? l10n.routinesGenerating
                        : l10n.routinesGenerateAi,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: RoutineFocusFilter.values
                    .map(
                      (focus) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: ChoiceChip(
                          label: Text(l10n.routineFocusLabel(focus.name)),
                          selected: routinesState.focusFilter == focus,
                          onSelected: (_) => routinesController.changeFocus(focus),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: routinesState.autogenerationEnabled,
              title: Text(l10n.routinesAutogenerationTitle),
              subtitle: Text(l10n.routinesAutogenerationSubtitle),
              onChanged: routinesController.toggleAutogeneration,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: routinesState.autogenerationEnabled
                  ? Row(
                      children: <Widget>[
                        Text('${l10n.commonFrequency}:'),
                        const SizedBox(width: AppSpacing.sm),
                        DropdownButton<AutogenerationFrequency>(
                          value: routinesState.frequency,
                          items: AutogenerationFrequency.values
                              .map(
                                (frequency) => DropdownMenuItem<AutogenerationFrequency>(
                                  value: frequency,
                                  child: Text(
                                    l10n.routineFrequencyLabel(frequency.name),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              routinesController.changeFrequency(value);
                            }
                          },
                        ),
                        const Spacer(),
                        if (routinesState.lastGenerated != null)
                          Text(
                            '${l10n.commonLast}: ${_relativeTime(context, routinesState.lastGenerated!)}',
                          ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: routinesState.routines.when(
                data: (routines) {
                  final filtered = routinesController.filteredRoutines();
                  if (filtered.isEmpty) {
                    return _EmptyState();
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final routine = filtered[index];
                      return _RoutineCard(routine: routine);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _RoutineError(
                  onRetry: routinesController.load,
                ),
              ),
            ),
          ],
        ),
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

  String _relativeTime(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${l10n.timeMinuteShort}';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} ${l10n.timeHourShort}';
    }
    return '${difference.inDays} ${l10n.timeDayShort}';
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ExpansionTile(
        title: Text(routine.name),
        subtitle: Text(routine.focus),
        leading: const Icon(Icons.fitness_center_outlined),
        children: routine.exercises
            .map(
              (exercise) => ListTile(
                title: Text(exercise.name),
                subtitle: Text(
                  l10n.routineSetsReps(exercise.sets, exercise.reps),
                ),
                trailing: exercise.weight != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('${exercise.weight?.toStringAsFixed(1)} kg'),
                          if (exercise.recommendedWeight != null)
                            Text(
                              '${l10n.routineRecommended}: ${exercise.recommendedWeight?.toStringAsFixed(1)} kg',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      )
                    : Text(
                        l10n.routineBodyweight,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RoutineError extends StatelessWidget {
  const _RoutineError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(l10n.routinesLoadError),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: onRetry,
            child: Text(l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.inbox_outlined, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.routinesEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.routinesEmptySubtitle,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
