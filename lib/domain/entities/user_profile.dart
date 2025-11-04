import 'package:equatable/equatable.dart';

/// Información principal del usuario autenticado.
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.languageCode,
    required this.themePreference,
    required this.weightKg,
    required this.heightCm,
    required this.devices,
  });

  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String languageCode;
  final String themePreference;
  final double weightKg;
  final double heightCm;
  final List<UserDevice> devices;

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? photoUrl,
    String? languageCode,
    String? themePreference,
    double? weightKg,
    double? heightCm,
    List<UserDevice>? devices,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      languageCode: languageCode ?? this.languageCode,
      themePreference: themePreference ?? this.themePreference,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      devices: devices ?? this.devices,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        displayName,
        email,
        photoUrl,
        languageCode,
        themePreference,
        weightKg,
        heightCm,
        devices,
      ];
}

/// Dispositivo conectado mediante BLE o servicios externos.
class UserDevice extends Equatable {
  const UserDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.lastSyncedAt,
  });

  final String id;
  final String name;
  final DeviceType type;
  final bool isActive;
  final DateTime? lastSyncedAt;

  @override
  List<Object?> get props => <Object?>[id, name, type, isActive, lastSyncedAt];
}

/// Tipos soportados de dispositivos vinculados.
enum DeviceType {
  band,
  heartRateMonitor,
  scale,
  camera,
  other,
}
