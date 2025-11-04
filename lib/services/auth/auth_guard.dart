import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/onboarding_page.dart';

/// Estado mínimo para representar autenticación del usuario.
final authStateProvider = StateProvider<AuthStatus>((ref) {
  return AuthStatus.unauthenticated;
});

/// Encapsula la lógica de redirección para el router.
class AuthGuard {
  const AuthGuard(this.ref);

  final Ref ref;

  String? handleRedirect(BuildContext context, GoRouterState state) {
    final status = ref.read(authStateProvider);
    final isOnboarding = state.matchedLocation == OnboardingPage.routePath;

    if (status == AuthStatus.authenticated && isOnboarding) {
      return '/dashboard';
    }

    if (status == AuthStatus.unauthenticated && !isOnboarding) {
      return OnboardingPage.routePath;
    }

    return null;
  }
}

final authGuardProvider = Provider<AuthGuard>((ref) {
  return AuthGuard(ref);
});

/// Representa los posibles estados de sesión.
enum AuthStatus { unauthenticated, onboarding, authenticated }
