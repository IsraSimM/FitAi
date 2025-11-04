import '../entities/leaderboard.dart';

/// Contrato para recuperar rankings y métricas sociales.
abstract class SocialRepository {
  Future<LeaderboardSnapshot> fetchLeaderboard(LeaderboardType type);
}
