import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_ai_app/store/settings/providers/locale_controller.dart';

void main() {
  testWidgets('LocaleController updates locale', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SizedBox()));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SizedBox)),
    );

    container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('en'));

    // Espera el debounce y asienta
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(container.read(localeControllerProvider).languageCode, 'en');
  });
}
