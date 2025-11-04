import '../entities/routine.dart';
import '../repositories/routine_repository.dart';

/// Caso de uso para generar rutinas con IA.
class GenerateRoutine {
  const GenerateRoutine(this._repository, this._userId);

  final RoutineRepository _repository;
  final String _userId;

  Future<Routine> call({required String focus}) {
    return _repository.generateRoutine(userId: _userId, focus: focus);
  }
}
