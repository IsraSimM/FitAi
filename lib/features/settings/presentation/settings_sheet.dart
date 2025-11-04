import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freet/app/localization/app_localizations.dart';
import 'package:freet/app/state/app_settings_controller.dart';
import 'package:freet/app/state/user_controller.dart';

class SettingsSheet extends ConsumerStatefulWidget {
  const SettingsSheet({super.key});

  @override
  ConsumerState<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<SettingsSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsControllerProvider);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          TabBar(
            controller: _controller,
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: <Tab>[
              Tab(text: l10n.settingsThemeTab),
              Tab(text: l10n.settingsLanguageTab),
              Tab(text: l10n.settingsNotificationsTab),
            ],
          ),
          SizedBox(
            height: 360,
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                _ThemeSettings(settings: settings),
                _LanguageSettings(settings: settings),
                _NotificationSettings(settings: settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ThemeSettings extends ConsumerWidget {
  const _ThemeSettings({required this.settings});

  final AppSettingsState settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.settingsThemeModeTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ThemeChoice.values
                .map(
                  (choice) => ChoiceChip(
                    label: Text(choice.name.toUpperCase()),
                    selected: settings.themeChoice == choice,
                    onSelected: (value) {
                      if (value) {
                        ref
                            .read(appSettingsControllerProvider.notifier)
                            .changeTheme(choice);
                        ref
                            .read(userControllerProvider.notifier)
                            .updatePreferences(theme: choice.name);
                      }
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settingsColorSection,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _ColorPreview(
                  label: l10n.settingsPrimaryColor,
                  color: settings.customLightColor,
                  onTap: () => _showColorPicker(context, ref, isDark: false),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ColorPreview(
                  label: l10n.settingsSecondaryColor,
                  color: settings.customDarkColor,
                  onTap: () => _showColorPicker(context, ref, isDark: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showColorPicker(
    BuildContext context,
    WidgetRef ref, {
    required bool isDark,
  }) async {
    final colors = <Color>[
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(dialogL10n.settingsSelectBaseColor),
          content: SizedBox(
            width: 300,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (color) => GestureDetector(
                      onTap: () {
                        if (isDark) {
                          ref
                              .read(appSettingsControllerProvider.notifier)
                              .updateCustomColors(dark: color);
                        } else {
                          ref
                              .read(appSettingsControllerProvider.notifier)
                              .updateCustomColors(light: color);
                        }
                        Navigator.of(dialogContext).pop();
                      },
                      child: CircleAvatar(backgroundColor: color, radius: 24),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _LanguageSettings extends ConsumerWidget {
  const _LanguageSettings({required this.settings});

  final AppSettingsState settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locales = const <Locale>[
      Locale('es'),
      Locale('en'),
      Locale('pt'),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.settingsSelectLanguage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...locales.map(
            (locale) => RadioListTile<Locale>(
              value: locale,
              groupValue: settings.locale,
              title: Text(l10n.languageLabel(locale.languageCode)),
              onChanged: (selected) {
                if (selected != null) {
                  ref
                      .read(appSettingsControllerProvider.notifier)
                      .changeLocale(selected);
                  ref.read(userControllerProvider.notifier).updatePreferences(
                        languageCode: selected.languageCode,
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettings extends ConsumerWidget {
  const _NotificationSettings({required this.settings});

  final AppSettingsState settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = settings.notifications;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
              value: prefs.push,
              title: Text(l10n.notificationsPush),
              subtitle: Text(l10n.notificationsPushSubtitle),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(prefs.copyWith(push: value));
              },
            ),
            SwitchListTile(
              value: prefs.email,
              title: Text(l10n.notificationsEmail),
              subtitle: Text(l10n.notificationsEmailSubtitle),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(prefs.copyWith(email: value));
              },
            ),
            SwitchListTile(
              value: prefs.inApp,
              title: Text(l10n.notificationsInApp),
              subtitle: Text(l10n.notificationsInAppSubtitle),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(prefs.copyWith(inApp: value));
              },
            ),
            const Divider(height: 32),
            CheckboxListTile(
              value: prefs.dailyReminders,
              title: Text(l10n.notificationsDaily),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(
                      prefs.copyWith(
                        dailyReminders: value ?? prefs.dailyReminders,
                      ),
                    );
              },
            ),
            CheckboxListTile(
              value: prefs.weeklySummary,
              title: Text(l10n.notificationsWeekly),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(
                      prefs.copyWith(
                        weeklySummary: value ?? prefs.weeklySummary,
                      ),
                    );
              },
            ),
            CheckboxListTile(
              value: prefs.personalizedTips,
              title: Text(l10n.notificationsTips),
              onChanged: (value) {
                ref
                    .read(appSettingsControllerProvider.notifier)
                    .updateNotifications(
                      prefs.copyWith(
                        personalizedTips: value ?? prefs.personalizedTips,
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
