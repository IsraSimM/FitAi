import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../datasources/in_memory_data_source.dart';
import '../datasources/routine_remote_datasource.dart';
import '../dtos/routine_dto.dart';

/// Implementación concreta del repositorio de rutinas apoyado en Firestore.
class RoutineRepositoryImpl implements RoutineRepository {
  RoutineRepositoryImpl(this.remoteDataSource);

  final RoutineRemoteDataSource remoteDataSource;

  @override
  Future<List<Routine>> fetchRoutines(String userId) async {
    final routines = await remoteDataSource.fetchUserRoutines(userId);
    return routines.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Routine> generateRoutine({required String userId, required String focus}) async {
    final dto = await remoteDataSource.generateRoutine(userId: userId, focus: focus);
    return dto.toDomain();
  }

  @override
  Future<void> saveRoutine({required String userId, required Routine routine}) {
    final dto = RoutineDto.fromDomain(routine);
    return remoteDataSource.saveRoutine(userId: userId, routine: dto);
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final dataSource = ref.watch(inMemoryDataSourceProvider);
  return RoutineRepositoryImpl(dataSource);
});
