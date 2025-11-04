import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/state/app_settings_controller.dart';
import '../../../app/state/user_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../services/auth/auth_guard.dart';
import '../../dashboard/presentation/dashboard_page.dart';

/// Pantalla de onboarding inicial con accesos a configuraciÃƒÂ³n bÃƒÂ¡sica.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  static const routeName = 'onboarding';
  static const routePath = '/onboarding';

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  bool _devicesConnected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onboardingTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: <Widget>[
            LinearProgressIndicator(value: (_currentIndex + 1) / 4),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _LanguageStep(onSelected: _onLanguageSelected, current: settings.locale),
                  _ThemeStep(onSelected: _onThemeSelected, current: settings.themeChoice),
                  _DevicesStep(
                    connected: _devicesConnected,
                    onToggle: (value) => setState(() => _devicesConnected = value),
                  ),
                  _SummaryStep(settings: settings, devicesConnected: _devicesConnected),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                if (_currentIndex > 0)
                  TextButton(
                    onPressed: _previous,
                    child: Text(l10n.commonBack),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _currentIndex == 3 ? _finish : _next,
                  child: Text(
                    _currentIndex == 3 ? l10n.commonFinish : l10n.commonNext,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onLanguageSelected(Locale locale) {
    ref.read(appSettingsControllerProvider.notifier).changeLocale(locale);
    ref.read(userControllerProvider.notifier).updatePreferences(languageCode: locale.languageCode);
  }

  void _onThemeSelected(ThemeChoice choice) {
    ref.read(appSettingsControllerProvider.notifier).changeTheme(choice);
    ref.read(userControllerProvider.notifier).updatePreferences(theme: choice.name);
  }

  void _next() {
    if (_currentIndex < 3) {
      setState(() => _currentIndex += 1);
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex -= 1);
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finish() {
    ref.read(authStateProvider.notifier).state = AuthStatus.authenticated;
    if (mounted) {
      context.go(DashboardPage.routePath);
    }
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({required this.onSelected, required this.current});

  final ValueChanged<Locale> onSelected;
  final Locale current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locales = const <Locale>[Locale('es'), Locale('en'), Locale('pt')];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.onboardingLanguageTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        ...locales.map(
          (locale) => RadioListTile<Locale>(
            value: locale,
            groupValue: current,
            title: Text(l10n.languageLabel(locale.languageCode)),
            onChanged: (selected) {
              if (selected != null) {
                onSelected(selected);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeStep extends StatelessWidget {
  const _ThemeStep({required this.onSelected, required this.current});

  final ValueChanged<ThemeChoice> onSelected;
  final ThemeChoice current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.onboardingThemeTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          children: ThemeChoice.values
              .map(
                (choice) => ChoiceChip(
                  label: Text(choice.name.toUpperCase()),
                  selected: choice == current,
                  onSelected: (value) {
                    if (value) {
                      onSelected(choice);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DevicesStep extends StatelessWidget {
  const _DevicesStep({required this.connected, required this.onToggle});

  final bool connected;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.onboardingDevicesTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          value: connected,
          title: Text(l10n.onboardingDevicesBandTitle),
          subtitle: Text(l10n.onboardingDevicesBandSubtitle),
          onChanged: onToggle,
        ),
        SwitchListTile(
          value: connected,
          title: Text(l10n.onboardingDevicesSensorTitle),
          subtitle: Text(l10n.onboardingDevicesSensorSubtitle),
          onChanged: onToggle,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_link),
          label: Text(l10n.onboardingDevicesManual),
        ),
      ],
    );
  }
}

class _SummaryStep extends StatelessWidget {
  const _SummaryStep({required this.settings, required this.devicesConnected});

  final AppSettingsState settings;
  final bool devicesConnected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.onboardingSummaryTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.settingsLanguageTab),
          subtitle: Text(settings.locale.languageCode.toUpperCase()),
        ),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(l10n.settingsThemeTab),
          subtitle: Text(settings.themeChoice.name.toUpperCase()),
        ),
        ListTile(
          leading: const Icon(Icons.watch_outlined),
          title: Text(l10n.onboardingSummaryDevices),
          subtitle: Text(
            devicesConnected
                ? l10n.onboardingSummaryDevicesConnected
                : l10n.onboardingSummaryDevicesPending,
          ),
        ),
        const Spacer(),
        Text(l10n.onboardingSummaryNote),
      ],
    );
  }
}
