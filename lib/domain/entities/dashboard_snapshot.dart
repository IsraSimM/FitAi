import 'package:equatable/equatable.dart';

import 'routine.dart';
import 'tip.dart';

/// Información agregada para poblar el dashboard principal del usuario.
class DashboardSnapshot extends Equatable {
  const DashboardSnapshot({
    required this.summary,
    required this.todaysRoutine,
    required this.weeklyStats,
    required this.goals,
    required this.tips,
  });

  final DailySummary summary;
  final List<RoutineExercise> todaysRoutine;
  final List<TrendStat> weeklyStats;
  final List<GoalProgress> goals;
  final List<Tip> tips;

  @override
  List<Object?> get props => <Object?>[summary, todaysRoutine, weeklyStats, goals, tips];
}

/// Métricas del día que se muestran en tarjetas resumidas.
class DailySummary extends Equatable {
  const DailySummary({
    required this.completion,
    required this.activeStreak,
    required this.calories,
    required this.readinessScore,
    required this.hydrationLevel,
    required this.date,
  });

  final double completion;
  final int activeStreak;
  final int calories;
  final double readinessScore;
  final double hydrationLevel;
  final DateTime date;

  @override
  List<Object?> get props => <Object?>[
        completion,
        activeStreak,
        calories,
        readinessScore,
        hydrationLevel,
        date,
      ];
}

/// Estadística semanal representable en gráfico/line chart.
class TrendStat extends Equatable {
  const TrendStat({
    required this.label,
    required this.dailyValues,
    required this.goalValue,
    required this.unit,
  });

  final String label;
  final List<double> dailyValues;
  final double goalValue;
  final String unit;

  double get latestValue => dailyValues.isEmpty ? 0 : dailyValues.last;

  @override
  List<Object?> get props => <Object?>[label, dailyValues, goalValue, unit];
}

/// Meta configurable por el usuario con progreso actual.
class GoalProgress extends Equatable {
  const GoalProgress({
    required this.name,
    required this.current,
    required this.target,
    required this.unit,
  });

  final String name;
  final double current;
  final double target;
  final String unit;

  double get completion => target == 0 ? 0 : (current / target).clamp(0, 1);

  @override
  List<Object?> get props => <Object?>[name, current, target, unit];
}
