import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/models/menu_item.dart';
import '../../settings/repo/settings_storage.dart';
import '../../settings/utils/debounce.dart';
import '../../../config/schema.dart';

class MenuState {
  final List<String> enabledIds;
  final List<String> orderIds;
  final bool dynamicEnabled;
  const MenuState({
    required this.enabledIds,
    required this.orderIds,
    required this.dynamicEnabled,
  });

  MenuState copyWith({
    List<String>? enabledIds,
    List<String>? orderIds,
    bool? dynamicEnabled,
  }) => MenuState(
    enabledIds: enabledIds ?? this.enabledIds,
    orderIds: orderIds ?? this.orderIds,
    dynamicEnabled: dynamicEnabled ?? this.dynamicEnabled,
  );
}

class MenuController extends Notifier<MenuState> {
  final _storage = SettingsStorage();
  final _debouncer = Debouncer(const Duration(milliseconds: 250));

  @override
  MenuState build() {
    ref.onDispose(_debouncer.dispose);
    return const MenuState(enabledIds: [], orderIds: [], dynamicEnabled: true);
  }

  Future<void> bootstrap({
    required List<String> enabled,
    required List<String> order,
    required bool dynamicEnabled,
  }) async {
    state = MenuState(
      enabledIds: enabled,
      orderIds: order,
      dynamicEnabled: dynamicEnabled,
    );
  }

  void enable(String id) {
    if (!AppMenuRegistry.available.any((m) => m.id == id)) return;
    if (state.enabledIds.contains(id)) return;
    final updated = [...state.enabledIds, id];
    state = state.copyWith(enabledIds: updated);
    _scheduleSave(enabledIds: updated);
  }

  void disable(String id) {
    final updated = state.enabledIds.where((e) => e != id).toList();
    state = state.copyWith(enabledIds: updated);
    _scheduleSave(enabledIds: updated);
  }

  void reorder(List<String> orderedIds) {
    final setAvail = HashSet.of(AppMenuRegistry.available.map((m) => m.id));
    final filtered = orderedIds.where(setAvail.contains).toList();
    state = state.copyWith(orderIds: filtered);
    _scheduleSave(orderIds: filtered);
  }

  void setDynamic(bool on) {
    state = state.copyWith(dynamicEnabled: on);
    _scheduleSave(dynamicEnabled: on);
  }

  List<MenuItem> materialize() {
    final base = AppMenuRegistry.available;
    final orderIndex = {
      for (var i = 0; i < state.orderIds.length; i++) state.orderIds[i]: i,
    };

    final list = base.map((m) {
      final enabled = state.dynamicEnabled
          ? state.enabledIds.contains(m.id)
          : true;
      final order = orderIndex[m.id] ?? 9999;
      return m.copyWith(isEnabled: enabled, order: order);
    }).toList();

    list.sort((a, b) => a.order.compareTo(b.order));
    return state.dynamicEnabled
        ? list.where((m) => m.isEnabled).toList()
        : list;
  }

  Future<void> resetToDefaults({
    required List<String> defaultEnabled,
    required List<String> defaultOrder,
    required bool defaultDynamic,
  }) async {
    state = MenuState(
      enabledIds: defaultEnabled,
      orderIds: defaultOrder,
      dynamicEnabled: defaultDynamic,
    );
    await _storage.savePartial(
      SettingsPartial(
        enabledIds: defaultEnabled,
        orderIds: defaultOrder,
        menuDynamicEnabled: defaultDynamic,
      ),
    );
  }

  void _scheduleSave({
    List<String>? enabledIds,
    List<String>? orderIds,
    bool? dynamicEnabled,
  }) {
    _debouncer.run(() {
      _storage.savePartial(
        SettingsPartial(
          enabledIds: enabledIds ?? state.enabledIds,
          orderIds: orderIds ?? state.orderIds,
          menuDynamicEnabled: dynamicEnabled ?? state.dynamicEnabled,
        ),
      );
    });
  }
}

final menuControllerProvider = NotifierProvider<MenuController, MenuState>(
  () => MenuController(),
);
