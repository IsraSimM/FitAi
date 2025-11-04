import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/state/user_controller.dart';
import '../../../data/repositories/routine_repository_impl.dart';
import '../../../domain/entities/routine.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/usecases/generate_routine.dart';

enum RoutineFocusFilter { all, full, leg, arm, cardio, custom }

enum AutogenerationFrequency { weekly, monthly, custom }

class RoutinesState {
  const RoutinesState({
    this.routines = const AsyncValue.loading(),
    this.focusFilter = RoutineFocusFilter.all,
    this.isGenerating = false,
    this.autogenerationEnabled = true,
    this.frequency = AutogenerationFrequency.weekly,
    this.lastGenerated,
  });

  final AsyncValue<List<Routine>> routines;
  final RoutineFocusFilter focusFilter;
  final bool isGenerating;
  final bool autogenerationEnabled;
  final AutogenerationFrequency frequency;
  final DateTime? lastGenerated;

  RoutinesState copyWith({
    AsyncValue<List<Routine>>? routines,
    RoutineFocusFilter? focusFilter,
    bool? isGenerating,
    bool? autogenerationEnabled,
    AutogenerationFrequency? frequency,
    DateTime? lastGenerated,
  }) {
    return RoutinesState(
      routines: routines ?? this.routines,
      focusFilter: focusFilter ?? this.focusFilter,
      isGenerating: isGenerating ?? this.isGenerating,
      autogenerationEnabled: autogenerationEnabled ?? this.autogenerationEnabled,
      frequency: frequency ?? this.frequency,
      lastGenerated: lastGenerated ?? this.lastGenerated,
    );
  }
}

class RoutinesController extends StateNotifier<RoutinesState> {
  RoutinesController(this._ref, this._repository)
      : super(const RoutinesState());

  final Ref _ref;
  final RoutineRepository _repository;

  Future<void> load() async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }
    state = state.copyWith(routines: const AsyncValue.loading());
    try {
      final routines = await _repository.fetchRoutines(userId);
      state = state.copyWith(routines: AsyncValue.data(routines));
    } on Object catch (error, stackTrace) {
      state = state.copyWith(routines: AsyncValue.error(error, stackTrace));
    }
  }

  void changeFocus(RoutineFocusFilter filter) {
    state = state.copyWith(focusFilter: filter);
  }

  void toggleAutogeneration(bool value) {
    state = state.copyWith(autogenerationEnabled: value);
  }

  void changeFrequency(AutogenerationFrequency frequency) {
    state = state.copyWith(frequency: frequency);
  }

  Future<void> generateRoutine(RoutineFocusFilter focus) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }
    state = state.copyWith(isGenerating: true);
    try {
      final generator = GenerateRoutine(_repository, userId);
      final focusLabel = _focusLabel(focus);
      final routine = await generator.call(focus: focusLabel);
      await _repository.saveRoutine(userId: userId, routine: routine);
      await load();
      state = state.copyWith(
        isGenerating: false,
        lastGenerated: DateTime.now(),
      );
    } on Object catch (error, stackTrace) {
      state = state.copyWith(
        isGenerating: false,
        routines: AsyncValue.error(error, stackTrace),
      );
    }
  }

  List<Routine> filteredRoutines() {
    final routinesValue = state.routines.value;
    if (routinesValue == null) {
      return const <Routine>[];
    }
    if (state.focusFilter == RoutineFocusFilter.all) {
      return routinesValue;
    }
    final focusLabel = _focusLabel(state.focusFilter);
    return routinesValue
        .where((routine) => routine.focus.toLowerCase().contains(focusLabel.toLowerCase()))
        .toList();
  }

  String _focusLabel(RoutineFocusFilter focus) {
    switch (focus) {
      case RoutineFocusFilter.full:
        return 'Completo';
      case RoutineFocusFilter.leg:
        return 'Pierna';
      case RoutineFocusFilter.arm:
        return 'Brazo';
      case RoutineFocusFilter.cardio:
        return 'Cardio';
      case RoutineFocusFilter.custom:
        return 'Personalizado';
      case RoutineFocusFilter.all:
      default:
        return 'Completo';
    }
  }
}

final routinesControllerProvider =
    StateNotifierProvider<RoutinesController, RoutinesState>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  final controller = RoutinesController(ref, repository);

  ref.listen<String?>(currentUserIdProvider, (_, next) {
    if (next != null) {
      controller.load();
    }
  }, fireImmediately: true);

  return controller;
});
