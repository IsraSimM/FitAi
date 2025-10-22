import "package:flutter/material.dart";

/// Shell muy simple para futuras barras persistentes (NavigationRail/Bar).
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
