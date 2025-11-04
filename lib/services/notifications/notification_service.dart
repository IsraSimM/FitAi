import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Servicio centralizado para manejar preferencias y entrega de notificaciones.
class NotificationService {
  const NotificationService();

  Future<void> requestPermissions() async {
    // TODO: Integrar Firebase Messaging y permisos de plataforma.
  }

  Future<void> scheduleReminder({required String id}) async {
    // TODO: Implementar programación de recordatorios personalizados.
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return const NotificationService();
});
