import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/evaluation/presentation/evaluation_page.dart';
import '../../features/more/presentation/more_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/routines/presentation/routines_page.dart';
import '../../features/social/presentation/social_page.dart';
import '../../services/auth/auth_guard.dart';

/// Definición del router principal basado en GoRouter.
GoRouter createRouter(Ref ref) {
  final authGuard = ref.read(authGuardProvider);

  return GoRouter(
    initialLocation: OnboardingPage.routePath,
    redirect: authGuard.handleRedirect,
    routes: <RouteBase>[
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => NavigationScaffold(child: child),
        routes: <RouteBase>[
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

/// Scaffold base con barra inferior configurada.
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
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
              ),
            )
            .toList(),
        onDestinationSelected: (index) {
          final route = _destinations[index].route;
          if (route != location) {
            context.go(route);
          }
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
