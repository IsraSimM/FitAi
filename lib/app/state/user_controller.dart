import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

class UserController extends StateNotifier<AsyncValue<UserProfile>> {
  UserController(this._repository) : super(const AsyncValue.loading());

  final UserRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.fetchCurrentUser();
      state = AsyncValue.data(profile);
    } on Object catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateMetrics({double? weightKg, double? heightCm}) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.updateBodyMetrics(
        weightKg: weightKg,
        heightCm: heightCm,
      );
      state = AsyncValue.data(profile);
    } on Object catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePreferences({String? languageCode, String? theme}) async {
    final previous = state.value;
    state = const AsyncValue.loading();
    try {
      await _repository.updatePreferences(
        languageCode: languageCode,
        theme: theme,
      );
      final profile = await _repository.fetchCurrentUser();
      state = AsyncValue.data(profile);
    } on Object catch (error, stackTrace) {
      if (previous != null) {
        state = AsyncValue.data(previous);
      } else {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<UserProfile>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  final controller = UserController(repository);
  controller.load();
  return controller;
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(userControllerProvider).maybeWhen(
        data: (user) => user.id,
        orElse: () => null,
      );
});
