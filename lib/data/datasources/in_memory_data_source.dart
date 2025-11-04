import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/leaderboard.dart';
import '../../domain/entities/routine.dart';
import '../../domain/entities/tip.dart';
import '../../domain/entities/user_profile.dart';
import '../dtos/routine_dto.dart';
import 'routine_remote_datasource.dart';

/// Fuente de datos local que simula Firestore/Cloud Functions para pruebas.
class InMemoryAppDataSource implements RoutineRemoteDataSource {
  InMemoryAppDataSource();

  UserProfile _profile = UserProfile(
    id: 'user-001',
    displayName: 'Alex Martínez',
    email: 'alex@example.com',
    photoUrl:
        'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=200&q=80',
    languageCode: 'es',
    themePreference: 'system',
    weightKg: 74.5,
    heightCm: 177,
    devices: const <UserDevice>[
      UserDevice(
        id: 'band-01',
        name: 'FreeT Band Pro',
        type: DeviceType.band,
        isActive: true,
        lastSyncedAt: null,
      ),
      UserDevice(
        id: 'hrm-01',
        name: 'Polar H10',
        type: DeviceType.heartRateMonitor,
        isActive: true,
        lastSyncedAt: null,
      ),
    ],
  );

  final List<RoutineDto> _routines = <RoutineDto>[
    RoutineDto(
      id: 'routine-1',
      name: 'Fuerza total',
      focus: 'Completo',
      exercises: const <RoutineExerciseDto>[
        RoutineExerciseDto(
          name: 'Sentadilla frontal',
          sets: 4,
          reps: 8,
          weight: 62,
          recommendedWeight: 65,
        ),
        RoutineExerciseDto(
          name: 'Press banca',
          sets: 4,
          reps: 10,
          weight: 42,
          recommendedWeight: 45,
        ),
        RoutineExerciseDto(
          name: 'Remo con barra',
          sets: 4,
          reps: 10,
          weight: 38,
          recommendedWeight: 40,
        ),
      ],
    ),
    RoutineDto(
      id: 'routine-2',
      name: 'Pierna avanzada',
      focus: 'Pierna',
      exercises: const <RoutineExerciseDto>[
        RoutineExerciseDto(
          name: 'Hip thrust',
          sets: 5,
          reps: 12,
          weight: 75,
          recommendedWeight: 80,
        ),
        RoutineExerciseDto(
          name: 'Peso muerto rumano',
          sets: 4,
          reps: 8,
          weight: 70,
          recommendedWeight: 72,
        ),
      ],
    ),
    RoutineDto(
      id: 'routine-3',
      name: 'HIIT Cardio',
      focus: 'Cardio',
      exercises: const <RoutineExerciseDto>[
        RoutineExerciseDto(
          name: 'Sprints en cinta',
          sets: 8,
          reps: 1,
          weight: null,
          recommendedWeight: null,
        ),
        RoutineExerciseDto(
          name: 'Remo intenso',
          sets: 6,
          reps: 2,
          weight: null,
          recommendedWeight: null,
        ),
      ],
    ),
  ];

  double _completionBoost = 0;
  int _manualAttendance = 0;

  final Map<LeaderboardType, List<LeaderboardEntry>> _leaderboards = <LeaderboardType, List<LeaderboardEntry>>{
    LeaderboardType.streak: const <LeaderboardEntry>[
      LeaderboardEntry(
        userId: 'user-001',
        displayName: 'Alex Martínez',
        avatarUrl: null,
        position: 1,
        value: 26,
        delta: 3,
      ),
      LeaderboardEntry(
        userId: 'user-002',
        displayName: 'Dana Ruiz',
        avatarUrl: null,
        position: 2,
        value: 21,
        delta: -1,
      ),
      LeaderboardEntry(
        userId: 'user-003',
        displayName: 'Marco Silva',
        avatarUrl: null,
        position: 3,
        value: 17,
        delta: 2,
      ),
    ],
    LeaderboardType.weightLifted: const <LeaderboardEntry>[
      LeaderboardEntry(
        userId: 'user-003',
        displayName: 'Marco Silva',
        avatarUrl: null,
        position: 1,
        value: 12250,
        delta: 430,
      ),
      LeaderboardEntry(
        userId: 'user-001',
        displayName: 'Alex Martínez',
        avatarUrl: null,
        position: 2,
        value: 11020,
        delta: 520,
      ),
      LeaderboardEntry(
        userId: 'user-004',
        displayName: 'Sofía Rey',
        avatarUrl: null,
        position: 3,
        value: 9570,
        delta: -230,
      ),
    ],
    LeaderboardType.cardioMinutes: const <LeaderboardEntry>[
      LeaderboardEntry(
        userId: 'user-002',
        displayName: 'Dana Ruiz',
        avatarUrl: null,
        position: 1,
        value: 480,
        delta: 40,
      ),
      LeaderboardEntry(
        userId: 'user-001',
        displayName: 'Alex Martínez',
        avatarUrl: null,
        position: 2,
        value: 455,
        delta: 35,
      ),
      LeaderboardEntry(
        userId: 'user-005',
        displayName: 'Luis Ortega',
        avatarUrl: null,
        position: 3,
        value: 430,
        delta: 20,
      ),
    ],
    LeaderboardType.communityScore: const <LeaderboardEntry>[
      LeaderboardEntry(
        userId: 'user-004',
        displayName: 'Sofía Rey',
        avatarUrl: null,
        position: 1,
        value: 920,
        delta: 50,
      ),
      LeaderboardEntry(
        userId: 'user-001',
        displayName: 'Alex Martínez',
        avatarUrl: null,
        position: 2,
        value: 880,
        delta: 30,
      ),
      LeaderboardEntry(
        userId: 'user-006',
        displayName: 'Tomás Ibarra',
        avatarUrl: null,
        position: 3,
        value: 845,
        delta: -10,
      ),
    ],
  };

  @override
  Future<List<RoutineDto>> fetchUserRoutines(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _routines;
  }

  @override
  Future<RoutineDto> generateRoutine({required String userId, required String focus}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final random = Random();
    final exercises = List<RoutineExerciseDto>.generate(5, (index) {
      final double baseWeight = (40 + (index * 5)).toDouble();
      return RoutineExerciseDto(
        name: '$focus dinámico ${index + 1}',
        sets: 3 + (index % 2),
        reps: 10 - (index % 3),
        weight:
            focus == 'Cardio' ? null : baseWeight + random.nextInt(12).toDouble(),
        recommendedWeight: focus == 'Cardio'
            ? null
            : baseWeight + random.nextInt(18).toDouble(),
      );
    });

    return RoutineDto(
      id: 'generated-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Auto $focus ${DateTime.now().weekday}',
      focus: focus,
      exercises: exercises,
    );
  }

  @override
  Future<void> saveRoutine({required String userId, required RoutineDto routine}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    final index = _routines.indexWhere((element) => element.id == routine.id);
    if (index >= 0) {
      _routines[index] = routine;
    } else {
      _routines.add(routine);
    }
  }

  Future<UserProfile> fetchUserProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _profile;
  }

  Future<DashboardSnapshot> fetchDashboard(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final DailySummary summary = DailySummary(
      completion: (0.72 + _completionBoost).clamp(0, 1),
      activeStreak: 18 + _manualAttendance,
      calories: 540 + (_manualAttendance * 60),
      readinessScore: 85 + (_completionBoost * 10),
      hydrationLevel: 0.78,
      date: DateTime.now(),
    );

    final List<TrendStat> stats = <TrendStat>[
      TrendStat(
        label: 'Volumen (kg)',
        unit: 'kg',
        goalValue: 11000,
        dailyValues: const <double>[8800, 9400, 10100, 10800, 11200, 11800, 12200],
      ),
      TrendStat(
        label: 'Cardio (min)',
        unit: 'min',
        goalValue: 480,
        dailyValues: const <double>[50, 65, 70, 60, 80, 75, 85],
      ),
      TrendStat(
        label: 'Sueño (h)',
        unit: 'h',
        goalValue: 8,
        dailyValues: const <double>[7.2, 7.5, 7.8, 7.4, 7.9, 8.1, 7.6],
      ),
    ];

    final List<GoalProgress> goals = <GoalProgress>[
      const GoalProgress(name: 'Bajar % grasa', current: 14.2, target: 12, unit: '%'),
      const GoalProgress(name: 'Peso muerto', current: 140, target: 160, unit: 'kg'),
      const GoalProgress(name: 'Pasos diarios', current: 8200, target: 10000, unit: 'pasos'),
    ];

    final List<Tip> tips = <Tip>[
      const Tip(
        id: 'tip-1',
        category: TipCategory.nutrition,
        title: 'Refuerza la recuperación',
        description: 'Incluye proteína de alta calidad y carbohidratos complejos dentro de los 45 minutos posteriores al entreno.',
        ctaLabel: 'Ver recetas',
      ),
      const Tip(
        id: 'tip-2',
        category: TipCategory.technique,
        title: 'Postura en sentadilla',
        description: 'Mantén el centro activado y distribuye el peso en toda la planta del pie para evitar colapsos de rodilla.',
      ),
      const Tip(
        id: 'tip-3',
        category: TipCategory.mindset,
        title: 'Celebra micro logros',
        description: 'Reconoce cada sesión completada para fortalecer la motivación intrínseca y consolidar la racha.',
      ),
    ];

    return DashboardSnapshot(
      summary: summary,
      todaysRoutine: _routines.first.exercises.map((e) => RoutineExercise(
            name: e.name,
            sets: e.sets,
            reps: e.reps,
            weight: e.weight,
            recommendedWeight: e.recommendedWeight,
          ))
          .toList(),
      weeklyStats: stats,
      goals: goals,
      tips: tips,
    );
  }

  Future<LeaderboardSnapshot> fetchLeaderboard(LeaderboardType type) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final entries = _leaderboards[type] ?? const <LeaderboardEntry>[];
    return LeaderboardSnapshot(
      type: type,
      periodLabel: 'Semana actual',
      entries: entries,
    );
  }

  Future<void> registerAttendance(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    _completionBoost = min(1, _completionBoost + 0.18);
    _manualAttendance += 1;
  }

  Future<void> updateUserPreferences({String? languageCode, String? theme}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _profile = _profile.copyWith(
      languageCode: languageCode,
      themePreference: theme,
    );
  }

  Future<UserProfile> updateBodyMetrics({double? weightKg, double? heightCm}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _profile = _profile.copyWith(
      weightKg: weightKg,
      heightCm: heightCm,
    );
    return _profile;
  }
}

/// Proveedor global que expone la fuente de datos simulada.
final inMemoryDataSourceProvider = Provider<InMemoryAppDataSource>((ref) {
  return InMemoryAppDataSource();
});
