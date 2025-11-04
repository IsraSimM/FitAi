import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freet/app/state/app_settings_controller.dart';

void main() {
  group('AppSettingsController', () {
    test('initial state uses system theme and spanish locale', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(appSettingsControllerProvider);

      expect(state.themeChoice, ThemeChoice.system);
      expect(state.locale, const Locale('es'));
      expect(state.notifications.push, isTrue);
    });

    test('changeTheme updates theme choice', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appSettingsControllerProvider.notifier).changeTheme(ThemeChoice.dark);

      final updated = container.read(appSettingsControllerProvider);
      expect(updated.themeChoice, ThemeChoice.dark);
    });

    test('updateNotifications toggles push channel', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(appSettingsControllerProvider.notifier);
      final initial = container.read(appSettingsControllerProvider).notifications;

      notifier.updateNotifications(initial.copyWith(push: false));

      final updated = container.read(appSettingsControllerProvider).notifications;
      expect(updated.push, isFalse);
      expect(updated.inApp, isTrue);
    });
  });
}
