import '../entities/routine.dart';

/// Contrato del repositorio de rutinas.
abstract class RoutineRepository {
  Future<List<Routine>> fetchRoutines(String userId);

  Future<Routine> generateRoutine({required String userId, required String focus});

  Future<void> saveRoutine({required String userId, required Routine routine});
}
