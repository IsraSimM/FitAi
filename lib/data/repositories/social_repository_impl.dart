import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/leaderboard.dart';
import '../../domain/repositories/social_repository.dart';
import '../datasources/in_memory_data_source.dart';

class SocialRepositoryImpl implements SocialRepository {
  SocialRepositoryImpl(this._dataSource);

  final InMemoryAppDataSource _dataSource;

  @override
  Future<LeaderboardSnapshot> fetchLeaderboard(LeaderboardType type) {
    return _dataSource.fetchLeaderboard(type);
  }
}

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final dataSource = ref.watch(inMemoryDataSourceProvider);
  return SocialRepositoryImpl(dataSource);
});
