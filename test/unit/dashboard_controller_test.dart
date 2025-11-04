import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freet/app/state/user_controller.dart';
import 'package:freet/features/dashboard/application/dashboard_controller.dart';

void main() {
  group('DashboardController', () {
    test('load retrieves snapshot data', () async {
      final container = ProviderContainer(overrides: [
        currentUserIdProvider.overrideWithValue('user-001'),
      ]);
      addTearDown(container.dispose);

      final controller = container.read(dashboardControllerProvider.notifier);
      await controller.load();

      final state = container.read(dashboardControllerProvider);
      expect(state.snapshot.hasValue, isTrue);
      final snapshot = state.snapshot.value;
      expect(snapshot, isNotNull);
      expect(snapshot!.todaysRoutine, isNotEmpty);
    });

    test('registerAttendance marks attendance', () async {
      final container = ProviderContainer(overrides: [
        currentUserIdProvider.overrideWithValue('user-001'),
      ]);
      addTearDown(container.dispose);

      final controller = container.read(dashboardControllerProvider.notifier);
      await controller.load();
      await controller.registerAttendance();

      final state = container.read(dashboardControllerProvider);
      expect(state.attendanceJustRegistered, isTrue);
      expect(state.snapshot.hasValue, isTrue);
    });
  });
}
