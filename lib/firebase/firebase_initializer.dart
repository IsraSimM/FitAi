import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Inicializa los servicios de Firebase cuando las credenciales estén
/// disponibles. Actualmente se ejecuta en modo "stub" para permitir la
/// ejecución de pruebas sin dependencias nativas.
Future<void> ensureFirebaseInitialized() async {
  // TODO(firebase): Reemplazar con `Firebase.initializeApp` y registros
  // adicionales cuando se provean los archivos de configuración oficiales.
  debugPrint('Firebase initialization skipped (stubbed environment).');
}

/// Punto único para exponer identificadores o instancias que dependan de
/// Firebase. Mantiene la firma esperada por los módulos de datos y
/// presentación sin acoplarse a la implementación real.
abstract class FirebaseGateways {
  const FirebaseGateways();

  /// Ejemplo de getter a implementar cuando se expongan instancias reales.
  Object? get firestoreClient;

  Object? get authClient;

  Object? get remoteConfig;
}

class StubFirebaseGateways extends FirebaseGateways {
  const StubFirebaseGateways();

  @override
  Object? get firestoreClient => null;

  @override
  Object? get authClient => null;

  @override
  Object? get remoteConfig => null;
}

final firebaseGatewaysProvider = Provider<FirebaseGateways>((ref) {
  // TODO(firebase): Devolver implementación concreta con instancias reales.
  return const StubFirebaseGateways();
});
