import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa una rutina de entrenamiento.
class Routine extends Equatable {
  const Routine({
    required this.id,
    required this.name,
    required this.focus,
    required this.exercises,
  });

  final String id;
  final String name;
  final String focus;
  final List<RoutineExercise> exercises;

  @override
  List<Object?> get props => <Object?>[id, name, focus, exercises];
}

/// Modelo de ejercicio dentro de una rutina.
class RoutineExercise extends Equatable {
  const RoutineExercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.weight,
    this.recommendedWeight,
  });

  final String name;
  final int sets;
  final int reps;
  final double? weight;
  final double? recommendedWeight;

  @override
  List<Object?> get props => <Object?>[name, sets, reps, weight, recommendedWeight];
}
