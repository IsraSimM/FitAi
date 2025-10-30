import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_ai_app/job/outine_refresh_service.dart';
import 'package:flutter/material.dart';
import 'verify_email_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    _checkVerification();
    _checkAndRefreshRoutines(); // ← AGREGADO: Verificar rutinas
  }

  Future<void> _checkVerification() async {
    // Espera un poco a que Firebase cargue el usuario actual
    await Future.delayed(const Duration(milliseconds: 500));

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && !currentUser.emailVerified) {
      // Si el correo NO está verificado, lo mandamos a la pantalla de verificación
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
        );
      }
    }
  }

  /// Verifica y actualiza las rutinas diarias si es necesario
  Future<void> _checkAndRefreshRoutines() async {
    try {
      final service = RoutineRefreshService();
      final wasUpdated = await service.checkAndRefreshIfNeeded();

      if (wasUpdated) {
        debugPrint('✅ Rutinas actualizadas automáticamente');

        // Opcional: Mostrar notificación al usuario
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text('Rutinas actualizadas para hoy')),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        debugPrint('ℹ️ Las rutinas ya están actualizadas para hoy');
      }
    } catch (e) {
      debugPrint('❌ Error al verificar rutinas: $e');
      // No mostramos error crítico al usuario para no interrumpir la experiencia
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80),
            const SizedBox(height: 20),
            Text(
              '¡Bienvenido!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Correo: ${user?.email ?? "Desconocido"}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
