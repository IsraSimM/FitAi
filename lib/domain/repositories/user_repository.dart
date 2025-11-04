import '../entities/user_profile.dart';

/// Acceso a datos de perfil y preferencias de usuario.
abstract class UserRepository {
  Future<UserProfile> fetchCurrentUser();

  Future<UserProfile> updateBodyMetrics({double? weightKg, double? heightCm});

  Future<void> updatePreferences({String? languageCode, String? theme});
}
