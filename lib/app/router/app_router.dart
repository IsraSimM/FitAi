import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Páginas
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/evaluation/presentation/evaluation_page.dart';
import '../../features/more/presentation/more_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/routines/presentation/routines_page.dart';
import '../../features/social/presentation/social_page.dart';

// Pantalla de sesión
import '../../sesion/auth/auth.dart';

/// Stream de usuario Firebase
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// Refresca GoRouter cuando cambie el estado de sesión
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// Router principal con login antes de onboarding
GoRouter createRouter(Ref ref) {
  final authStream = ref.watch(authStateProvider.stream);

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authStream),
    initialLocation: '/auth',
    redirect: (context, state) {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      final bool goingToAuth = state.matchedLocation == '/auth';

      // 🚪 Si NO hay sesión y NO estamos en /auth → manda a /auth
      if (!loggedIn && !goingToAuth) return '/auth';

      // ✅ Si HAY sesión y estamos en /auth → manda al Onboarding (config)
      if (loggedIn && goingToAuth) return OnboardingPage.routePath;

      return null;
    },
    routes: [
      // 🔐 Sesión
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),

      // 🏁 Configuración inicial
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        builder: (context, state) => const OnboardingPage(),
      ),

      // 🔄 Resto del flujo con barra inferior
      ShellRoute(
        builder: (context, state, child) => NavigationScaffold(child: child),
        routes: [
          GoRoute(
            path: DashboardPage.routePath,
            name: DashboardPage.routeName,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: RoutinesPage.routePath,
            name: RoutinesPage.routeName,
            builder: (context, state) => const RoutinesPage(),
          ),
          GoRoute(
            path: EvaluationPage.routePath,
            name: EvaluationPage.routeName,
            builder: (context, state) => const EvaluationPage(),
          ),
          GoRoute(
            path: SocialPage.routePath,
            name: SocialPage.routeName,
            builder: (context, state) => const SocialPage(),
          ),
          GoRoute(
            path: MorePage.routePath,
            name: MorePage.routeName,
            builder: (context, state) => const MorePage(),
          ),
        ],
      ),
    ],
  );
}

/// Scaffold con barra inferior
class NavigationScaffold extends ConsumerWidget {
  const NavigationScaffold({required this.child, super.key});
  final Widget child;

  static const _destinations = [
    _NavigationDestination(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: DashboardPage.routePath,
    ),
    _NavigationDestination(
      label: 'Routines',
      icon: Icons.fitness_center_outlined,
      route: RoutinesPage.routePath,
    ),
    _NavigationDestination(
      label: 'Evaluation',
      icon: Icons.camera_alt_outlined,
      route: EvaluationPage.routePath,
    ),
    _NavigationDestination(
      label: 'Social',
      icon: Icons.emoji_events_outlined,
      route: SocialPage.routePath,
    ),
    _NavigationDestination(
      label: 'More',
      icon: Icons.menu,
      route: MorePage.routePath,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _destinations.indexWhere(
      (destination) => location.startsWith(destination.route),
    );

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                label: d.label,
              ),
            )
            .toList(),
        onDestinationSelected: (index) {
          final route = _destinations[index].route;
          if (route != location) context.go(route);
        },
      ),
    );
  }
}

class _NavigationDestination {
  const _NavigationDestination({
    required this.label,
    required this.icon,
    required this.route,
  });
  final String label;
  final IconData icon;
  final String route;
}
