import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/in_memory_data_source.dart';

/// Implementación basada en [InMemoryAppDataSource] para desarrollo local.
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._dataSource);

  final InMemoryAppDataSource _dataSource;

  @override
  Future<DashboardSnapshot> fetchSnapshot(String userId) {
    return _dataSource.fetchDashboard(userId);
  }

  @override
  Future<void> registerAttendance(String userId) {
    return _dataSource.registerAttendance(userId);
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dataSource = ref.watch(inMemoryDataSourceProvider);
  return DashboardRepositoryImpl(dataSource);
});
