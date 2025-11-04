import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/state/app_settings_controller.dart';
import '../../../app/state/user_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/free_t_top_bar.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../services/auth/auth_repository.dart';
import '../../notifications/presentation/notifications_sheet.dart';
import '../../settings/presentation/settings_sheet.dart';

/// Menu extendido con accesos a modulos secundarios.
class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  static const routeName = 'more';
  static const routePath = '/more';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);
    final settings = ref.watch(appSettingsControllerProvider);
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
      body: userState.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            _ProfileHeader(profile: profile),
            const SizedBox(height: AppSpacing.lg),
            _DevicesSection(devices: profile.devices),
            const SizedBox(height: AppSpacing.lg),
            _SettingsSection(settings: settings),
            const SizedBox(height: AppSpacing.lg),
            _SupportSection(onLogout: () => _logout(ref, context)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(l10n.profileLoadError),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () =>
                    ref.read(userControllerProvider.notifier).load(),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
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

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.signOut();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).profileLogoutSuccess)),
      );
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 32,
                  backgroundImage: profile.photoUrl != null
                      ? NetworkImage(profile.photoUrl!)
                      : null,
                  child: profile.photoUrl == null
                      ? Text(
                          profile.displayName.isNotEmpty
                              ? profile.displayName[0]
                              : '?',
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        profile.displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        profile.email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.commonEdit),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MetricTile(
                    label: l10n.profileWeight,
                    value: '${profile.weightKg.toStringAsFixed(1)} kg',
                    icon: Icons.monitor_weight_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _MetricTile(
                    label: l10n.profileHeight,
                    value: '${profile.heightCm.toStringAsFixed(0)} cm',
                    icon: Icons.height,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Row(
        children: <Widget>[
          Icon(icon),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _DevicesSection extends StatelessWidget {
  const _DevicesSection({required this.devices});

  final List<UserDevice> devices;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.profileLinkedDevices,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            if (devices.isEmpty) Text(l10n.profileNoDevices),
            ...devices.map(
              (device) => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: device.isActive,
                title: Text(device.name),
                subtitle: Text(
                  '${l10n.profileDeviceTypeLabel}: ${device.type.name}',
                ),
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_link),
              label: Text(l10n.profileLinkNewDevice),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends ConsumerWidget {
  const _SettingsSection({required this.settings});

  final AppSettingsState settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = settings.notifications;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.settingsPreferences,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language),
              title: Text(l10n.settingsLanguageTab),
              subtitle: Text(settings.locale.languageCode.toUpperCase()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                builder: (_) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SettingsSheet(),
                ),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: prefs.personalizedTips,
              title: Text(l10n.notificationsTips),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(
                      prefs.copyWith(personalizedTips: value),
                    );
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: prefs.dailyReminders,
              title: Text(l10n.notificationsDaily),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(
                      prefs.copyWith(dailyReminders: value),
                    );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.analytics_outlined),
              title: Text(l10n.settingsTelemetryTitle),
              subtitle: Text(l10n.settingsTelemetrySubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.supportTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.support_agent_outlined),
              title: Text(l10n.supportFaq),
              subtitle: Text(l10n.supportFaqSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout),
              title: Text(l10n.supportLogout),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

