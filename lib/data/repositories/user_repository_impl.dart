import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/in_memory_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dataSource);

  final InMemoryAppDataSource _dataSource;

  @override
  Future<UserProfile> fetchCurrentUser() {
    return _dataSource.fetchUserProfile();
  }

  @override
  Future<UserProfile> updateBodyMetrics({double? weightKg, double? heightCm}) {
    return _dataSource.updateBodyMetrics(weightKg: weightKg, heightCm: heightCm);
  }

  @override
  Future<void> updatePreferences({String? languageCode, String? theme}) {
    return _dataSource.updateUserPreferences(languageCode: languageCode, theme: theme);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(inMemoryDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});
