import '../entities/dashboard_snapshot.dart';

/// Contrato para obtener datos agregados del dashboard.
abstract class DashboardRepository {
  Future<DashboardSnapshot> fetchSnapshot(String userId);

  Future<void> registerAttendance(String userId);
}
