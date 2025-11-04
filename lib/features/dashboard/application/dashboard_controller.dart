import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/state/user_controller.dart';
import '../../../data/repositories/dashboard_repository_impl.dart';
import '../../../domain/entities/dashboard_snapshot.dart';
import '../../../domain/repositories/dashboard_repository.dart';

class DashboardState {
  const DashboardState({
    this.snapshot = const AsyncValue.loading(),
    this.isRefreshing = false,
    this.attendanceJustRegistered = false,
  });

  final AsyncValue<DashboardSnapshot> snapshot;
  final bool isRefreshing;
  final bool attendanceJustRegistered;

  DashboardState copyWith({
    AsyncValue<DashboardSnapshot>? snapshot,
    bool? isRefreshing,
    bool? attendanceJustRegistered,
  }) {
    return DashboardState(
      snapshot: snapshot ?? this.snapshot,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      attendanceJustRegistered:
          attendanceJustRegistered ?? this.attendanceJustRegistered,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._ref, this._repository)
      : super(const DashboardState());

  final Ref _ref;
  final DashboardRepository _repository;

  Future<void> load() async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }
    state = state.copyWith(snapshot: const AsyncValue.loading());
    try {
      final snapshot = await _repository.fetchSnapshot(userId);
      state = state.copyWith(
        snapshot: AsyncValue.data(snapshot),
        isRefreshing: false,
        attendanceJustRegistered: false,
      );
    } on Object catch (error, stackTrace) {
      state = state.copyWith(
        snapshot: AsyncValue.error(error, stackTrace),
        isRefreshing: false,
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await load();
  }

  Future<void> registerAttendance() async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }
    state = state.copyWith(isRefreshing: true);
    try {
      await _repository.registerAttendance(userId);
      final snapshot = await _repository.fetchSnapshot(userId);
      state = state.copyWith(
        snapshot: AsyncValue.data(snapshot),
        isRefreshing: false,
        attendanceJustRegistered: true,
      );
    } on Object catch (error, stackTrace) {
      state = state.copyWith(
        snapshot: AsyncValue.error(error, stackTrace),
        isRefreshing: false,
        attendanceJustRegistered: false,
      );
    }
  }
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  final controller = DashboardController(ref, repository);

  ref.listen<String?>(currentUserIdProvider, (_, next) {
    if (next != null) {
      controller.load();
    }
  }, fireImmediately: true);

  return controller;
});
