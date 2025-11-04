import '../dtos/routine_dto.dart';

/// Fuente de datos remota para rutinas desde Firestore/Cloud Functions.
abstract class RoutineRemoteDataSource {
  Future<List<RoutineDto>> fetchUserRoutines(String userId);

  Future<RoutineDto> generateRoutine({required String userId, required String focus});

  Future<void> saveRoutine({required String userId, required RoutineDto routine});
}

class FirebaseRoutineRemoteDataSource implements RoutineRemoteDataSource {
  @override
  Future<List<RoutineDto>> fetchUserRoutines(String userId) async {
    // TODO: Integrar Firestore queries reales.
    return const <RoutineDto>[];
  }

  @override
  Future<RoutineDto> generateRoutine({required String userId, required String focus}) async {
    // TODO: Integrar generación real en Cloud Functions.
    return RoutineDto(
      id: 'draft',
      name: 'Rutina $focus',
      focus: focus,
      exercises: const <RoutineExerciseDto>[],
    );
  }

  @override
  Future<void> saveRoutine({required String userId, required RoutineDto routine}) async {
    // TODO: Persistir rutina en Firestore.
  }
}
