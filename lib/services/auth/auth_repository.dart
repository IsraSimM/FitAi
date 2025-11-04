import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_guard.dart';

/// Contrato principal para operaciones de autenticación con Firebase Auth.
class AuthRepository {
  AuthRepository(this.ref);

  final Ref ref;

  Future<void> signInWithEmail(String email, String password) async {
    // TODO: Integrar Firebase Auth.
    ref.read(authStateProvider.notifier).state = AuthStatus.authenticated;
  }

  Future<void> signOut() async {
    // TODO: Cerrar sesión y limpiar tokens.
    ref.read(authStateProvider.notifier).state = AuthStatus.unauthenticated;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});
