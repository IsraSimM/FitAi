import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freet/app/localization/app_localizations.dart';
import 'package:freet/app/state/user_controller.dart';
import 'package:freet/core/constants/app_spacing.dart';
import 'package:freet/core/widgets/free_t_top_bar.dart';
import 'package:freet/domain/entities/leaderboard.dart';
import 'package:freet/features/notifications/presentation/notifications_sheet.dart';
import 'package:freet/features/settings/presentation/settings_sheet.dart';
import 'package:freet/features/social/application/social_controller.dart';

/// Espacio social con rankings y actividad de la comunidad.
class SocialPage extends ConsumerWidget {
  const SocialPage({super.key});

  static const routeName = 'social';
  static const routePath = '/social';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialControllerProvider);
    final controller = ref.read(socialControllerProvider.notifier);
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
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 420;
                final selector = SegmentedButton<LeaderboardType>(
                  segments: LeaderboardType.values
                      .map(
                        (type) => ButtonSegment<LeaderboardType>(
                          value: type,
                          label: Text(_leaderboardLabel(l10n, type)),
                        ),
                      )
                      .toList(),
                  selected: <LeaderboardType>{state.selectedType},
                  onSelectionChanged: (selection) =>
                      controller.loadLeaderboard(selection.first),
                );

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.socialActiveRankings,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: selector,
                      ),
                    ],
                  );
                }

                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.socialActiveRankings,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    selector,
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: state.snapshot.when(
                data: (snapshot) {
                  return ListView.separated(
                    itemCount: snapshot.entries.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final entry = snapshot.entries[index];
                      return _LeaderboardTile(
                          entry: entry, position: index + 1);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(l10n.socialLoadError),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        onPressed: () =>
                            controller.loadLeaderboard(state.selectedType),
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.group_add_outlined),
        label: Text(l10n.socialInviteFriends),
      ),
    );
  }

  String _leaderboardLabel(AppLocalizations l10n, LeaderboardType type) {
    switch (type) {
      case LeaderboardType.streak:
        return l10n.leaderboardLabel('streak');
      case LeaderboardType.weightLifted:
        return l10n.leaderboardLabel('weight');
      case LeaderboardType.cardioMinutes:
        return l10n.leaderboardLabel('cardio');
      case LeaderboardType.communityScore:
        return l10n.leaderboardLabel('community');
    }
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

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({required this.entry, required this.position});

  final LeaderboardEntry entry;
  final int position;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1 * position),
          child: Text(position.toString()),
        ),
        title: Text(entry.displayName),
        subtitle: Text(
          '${l10n.socialScoreLabel}: ${l10n.formatNumber(entry.value)} '
          '(${l10n.socialScoreChange} ${l10n.formatSigned(entry.delta)})',
        ),
        trailing: Icon(
          position == 1
              ? Icons.emoji_events_outlined
              : Icons.military_tech_outlined,
        ),
      ),
    );
  }
}
