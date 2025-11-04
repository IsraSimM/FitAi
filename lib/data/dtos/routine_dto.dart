import '../../domain/entities/routine.dart';

/// DTO serializable para rutinas sincronizadas con Firestore.
class RoutineDto {
  const RoutineDto({
    required this.id,
    required this.name,
    required this.focus,
    required this.exercises,
  });

  final String id;
  final String name;
  final String focus;
  final List<RoutineExerciseDto> exercises;

  factory RoutineDto.fromDomain(Routine routine) {
    return RoutineDto(
      id: routine.id,
      name: routine.name,
      focus: routine.focus,
      exercises: routine.exercises
          .map(
            (exercise) => RoutineExerciseDto(
              name: exercise.name,
              sets: exercise.sets,
              reps: exercise.reps,
              weight: exercise.weight,
              recommendedWeight: exercise.recommendedWeight,
            ),
          )
          .toList(),
    );
  }

  Routine toDomain() {
    return Routine(
      id: id,
      name: name,
      focus: focus,
      exercises: exercises
          .map(
            (exercise) => RoutineExercise(
              name: exercise.name,
              sets: exercise.sets,
              reps: exercise.reps,
              weight: exercise.weight,
              recommendedWeight: exercise.recommendedWeight,
            ),
          )
          .toList(),
    );
  }
}

/// DTO para ejercicios dentro de la rutina.
class RoutineExerciseDto {
  const RoutineExerciseDto({
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
}
