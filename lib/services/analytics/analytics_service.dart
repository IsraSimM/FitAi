import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstracción para eventos de analítica y telemetría.
class AnalyticsService {
  const AnalyticsService();

  Future<void> logEvent(String name, [Map<String, Object?> parameters = const {}]) async {
    // TODO: Integrar Firebase Analytics y BigQuery export.
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return const AnalyticsService();
});
