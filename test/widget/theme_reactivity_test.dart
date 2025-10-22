import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_ai_app/store/settings/providers/theme_controller.dart';

void main() {
  testWidgets('ThemeController updates theme mode', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            final container = ProviderScope.containerOf(context);
            final theme = container.read(themeControllerProvider);
            return MaterialApp(themeMode: theme, home: const SizedBox());
          },
        ),
      ),
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SizedBox)),
    );
    container.read(themeControllerProvider.notifier).setTheme(ThemeMode.dark);

    // Espera el debounce y asienta
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(container.read(themeControllerProvider), ThemeMode.dark);
  });
}
