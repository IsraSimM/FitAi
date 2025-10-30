// lib/pages/verify_email_page.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _canResend = true;
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startCooldown([int secs = 30]) async {
    setState(() {
      _canResend = false;
      _seconds = secs;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        setState(() {
          _canResend = true;
          _seconds = 0;
        });
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _resend() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await user.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enlace enviado. Revisa tu correo.')),
        );
      }
      await _startCooldown();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al reenviar: $e')));
      }
    }
  }

  Future<void> _checkVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    final refreshed = FirebaseAuth.instance.currentUser;
    if (refreshed != null && refreshed.emailVerified) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo verificado. ¡Bienvenido!')),
        );
        // Aquí redirige a tu Home:
        Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aún no se ha verificado.')),
        );
      }
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.of(context).pop(); // regresa al login
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Verifica tu correo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread, size: 80),
            const SizedBox(height: 16),
            Text(
              'Te enviamos un enlace de verificación a:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _canResend ? _resend : null,
              icon: const Icon(Icons.refresh),
              label: Text(
                _canResend
                    ? 'Reenviar enlace'
                    : 'Espera $_seconds s para reenviar',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _checkVerified,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Ya verifiqué'),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
