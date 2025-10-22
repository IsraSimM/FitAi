import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_ai_app/store/settings/providers/menu_controller.dart';

void main() {
  test('Enable/disable and reorder works over registry', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Dispara build() del Notifier
    container.read(menuControllerProvider);

    final ctrl = container.read(menuControllerProvider.notifier);
    await ctrl.bootstrap(
      enabled: const ['dashboard', 'settings'],
      order: const ['settings', 'dashboard'],
      dynamicEnabled: true,
    );

    var list = ctrl.materialize();
    expect(list.first.id, 'settings');

    ctrl.disable('settings');
    list = ctrl.materialize();
    expect(list.any((e) => e.id == 'settings'), isFalse);

    ctrl.enable('settings');
    list = ctrl.materialize();
    expect(list.any((e) => e.id == 'settings'), isTrue);
  });
}
