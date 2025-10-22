/// Menu item model for FitAi global navigation.
class MenuItem {
  final String id; // e.g. 'dashboard', 'settings'
  final String titleKey; // i18n key, e.g. 'menu.dashboard'
  final String route; // GoRouter route path
  final String iconName; // material icon name (string ref)
  final bool isEnabled; // derived at composition time
  final int order; // for user-defined ordering

  const MenuItem({
    required this.id,
    required this.titleKey,
    required this.route,
    required this.iconName,
    this.isEnabled = true,
    this.order = 0,
  });

  MenuItem copyWith({bool? isEnabled, int? order}) => MenuItem(
    id: id,
    titleKey: titleKey,
    route: route,
    iconName: iconName,
    isEnabled: isEnabled ?? this.isEnabled,
    order: order ?? this.order,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'titleKey': titleKey,
    'route': route,
    'iconName': iconName,
    'isEnabled': isEnabled,
    'order': order,
  };

  factory MenuItem.fromMap(Map<String, dynamic> map) => MenuItem(
    id: map['id'] as String,
    titleKey: map['titleKey'] as String,
    route: map['route'] as String,
    iconName: map['iconName'] as String,
    isEnabled: (map['isEnabled'] as bool?) ?? true,
    order: (map['order'] as int?) ?? 0,
  );
}
