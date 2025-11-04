import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/social_repository_impl.dart';
import '../../../domain/entities/leaderboard.dart';
import '../../../domain/repositories/social_repository.dart';

class SocialState {
  const SocialState({
    this.selectedType = LeaderboardType.streak,
    this.snapshot = const AsyncValue.loading(),
  });

  final LeaderboardType selectedType;
  final AsyncValue<LeaderboardSnapshot> snapshot;

  SocialState copyWith({
    LeaderboardType? selectedType,
    AsyncValue<LeaderboardSnapshot>? snapshot,
  }) {
    return SocialState(
      selectedType: selectedType ?? this.selectedType,
      snapshot: snapshot ?? this.snapshot,
    );
  }
}

class SocialController extends StateNotifier<SocialState> {
  SocialController(this._repository) : super(const SocialState()) {
    loadLeaderboard(LeaderboardType.streak);
  }

  final SocialRepository _repository;

  Future<void> loadLeaderboard(LeaderboardType type) async {
    state = state.copyWith(
      selectedType: type,
      snapshot: const AsyncValue.loading(),
    );
    try {
      final snapshot = await _repository.fetchLeaderboard(type);
      state = state.copyWith(snapshot: AsyncValue.data(snapshot));
    } on Object catch (error, stackTrace) {
      state = state.copyWith(snapshot: AsyncValue.error(error, stackTrace));
    }
  }
}

final socialControllerProvider =
    StateNotifierProvider<SocialController, SocialState>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return SocialController(repository);
});
