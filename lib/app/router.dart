import "package:go_router/go_router.dart";
import "../features/dashboard/dashboard_page.dart";

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      name: "dashboard",
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
