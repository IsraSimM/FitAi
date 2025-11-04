import 'package:equatable/equatable.dart';

/// Tipo de leaderboard soportado por la sección social.
enum LeaderboardType {
  streak,
  weightLifted,
  cardioMinutes,
  communityScore,
}

/// Agrupa entradas de ranking por periodo y métrica.
class LeaderboardSnapshot extends Equatable {
  const LeaderboardSnapshot({
    required this.type,
    required this.periodLabel,
    required this.entries,
  });

  final LeaderboardType type;
  final String periodLabel;
  final List<LeaderboardEntry> entries;

  @override
  List<Object?> get props => <Object?>[type, periodLabel, entries];
}

/// Entrada individual de un ranking.
class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.position,
    required this.value,
    required this.delta,
  });

  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int position;
  final double value;
  final double delta;

  @override
  List<Object?> get props => <Object?>[userId, displayName, avatarUrl, position, value, delta];
}
