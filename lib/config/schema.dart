import '../store/settings/models/menu_item.dart';

/// Central registry of available menu entries. This is the source of truth
/// for routes shown in the global navigation (dynamic enabling applies).
class AppMenuRegistry {
  static final List<MenuItem> available = <MenuItem>[
    MenuItem(
      id: 'dashboard',
      titleKey: 'menu.dashboard',
      route: '/',
      iconName: 'home',
      isEnabled: true,
      order: 0,
    ),
    MenuItem(
      id: 'settings',
      titleKey: 'menu.settings',
      route: '/settings',
      iconName: 'settings',
      isEnabled: true,
      order: 1,
    ),
    // Futuro: rutinas, técnicas, datos, ecosistemas, estadísticas, social, notificaciones...
  ];
}
