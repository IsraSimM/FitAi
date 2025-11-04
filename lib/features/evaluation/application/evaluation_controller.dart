import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EvaluationPhase { calibrating, ready, recording, reviewing }

enum EvaluationCue { posture, range, speed }

class EvaluationMetric {
  const EvaluationMetric({
    required this.label,
    required this.value,
    required this.score,
  });

  final String label;
  final String value;
  final double score;
}

class EvaluationState {
  const EvaluationState({
    this.phase = EvaluationPhase.calibrating,
    this.metrics = const <EvaluationMetric>[],
    this.elapsedSeconds = 0,
    this.cues = const {EvaluationCue.posture},
  });

  final EvaluationPhase phase;
  final List<EvaluationMetric> metrics;
  final int elapsedSeconds;
  final Set<EvaluationCue> cues;

  EvaluationState copyWith({
    EvaluationPhase? phase,
    List<EvaluationMetric>? metrics,
    int? elapsedSeconds,
    Set<EvaluationCue>? cues,
  }) {
    return EvaluationState(
      phase: phase ?? this.phase,
      metrics: metrics ?? this.metrics,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      cues: cues ?? this.cues,
    );
  }
}

class EvaluationController extends StateNotifier<EvaluationState> {
  EvaluationController() : super(const EvaluationState());

  void toggleCue(EvaluationCue cue) {
    final updated = Set<EvaluationCue>.from(state.cues);
    if (updated.contains(cue)) {
      updated.remove(cue);
    } else {
      updated.add(cue);
    }
    state = state.copyWith(cues: updated);
  }

  Future<void> startSession() async {
    state = state.copyWith(phase: EvaluationPhase.calibrating, elapsedSeconds: 0);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(phase: EvaluationPhase.recording);
  }

  Future<void> updateElapsed(int seconds) async {
    state = state.copyWith(elapsedSeconds: seconds);
  }

  Future<void> finishSession() async {
    state = state.copyWith(phase: EvaluationPhase.reviewing);
    final metrics = <EvaluationMetric>[
      const EvaluationMetric(label: 'Reps válidas', value: '18', score: 0.92),
      const EvaluationMetric(label: 'Profundidad sentadilla', value: '87%', score: 0.85),
      const EvaluationMetric(label: 'Ritmo', value: 'Controlado', score: 0.78),
    ];
    state = state.copyWith(metrics: metrics);
  }

  void reset() {
    state = const EvaluationState(phase: EvaluationPhase.ready);
  }
}

final evaluationControllerProvider =
    StateNotifierProvider<EvaluationController, EvaluationState>((ref) {
  return EvaluationController();
});
