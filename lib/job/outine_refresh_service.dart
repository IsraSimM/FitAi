// lib/services/routine_refresh_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineRefreshService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _lastRefreshKey = 'last_routine_refresh';

  /// Verifica y actualiza las rutinas si es necesario
  Future<bool> checkAndRefreshIfNeeded() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final lastRefresh = prefs.getString(_lastRefreshKey);
    final today = _getTodayString();

    // Si ya se actualizó hoy, no hacer nada
    if (lastRefresh == today) {
      print('✅ Rutinas ya actualizadas hoy');
      return false;
    }

    // Actualizar rutinas
    await _refreshRoutines(user.uid);

    // Guardar fecha de actualización
    await prefs.setString(_lastRefreshKey, today);

    print('✅ Rutinas actualizadas para el día $today');
    return true;
  }

  /// Actualiza todas las rutinas activas del usuario
  Future<void> _refreshRoutines(String userId) async {
    try {
      final routinesRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('routines');

      // Obtener todas las rutinas activas
      final snapshot = await routinesRef.where('active', isEqualTo: true).get();

      if (snapshot.docs.isEmpty) {
        print('ℹ️ No hay rutinas activas para actualizar');
        return;
      }

      // Usar batch para actualizar múltiples documentos eficientemente
      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {
          'status': 'pending', // Estado inicial del día
          'completedToday': false,
          'completedExercises': 0,
          'lastUpdated': FieldValue.serverTimestamp(),
          'refreshDate': _getTodayString(),
        });
      }

      await batch.commit();
      print('✅ ${snapshot.docs.length} rutinas actualizadas');
    } catch (e) {
      print('❌ Error actualizando rutinas: $e');
      rethrow;
    }
  }

  /// Fuerza la actualización de rutinas (para testing)
  Future<void> forceRefresh() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _refreshRoutines(user.uid);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRefreshKey, _getTodayString());
  }

  /// Obtiene la fecha actual en formato YYYY-MM-DD
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Limpia el registro de actualización (para testing)
  Future<void> clearRefreshRecord() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastRefreshKey);
  }
}
