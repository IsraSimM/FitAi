import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freet/sesion/components/text_field.dart';
import 'package:freet/sesion/components/button.dart';

class PhoneSignInPage extends StatefulWidget {
  const PhoneSignInPage({super.key});

  @override
  State<PhoneSignInPage> createState() => _PhoneSignInPageState();
}

class _PhoneSignInPageState extends State<PhoneSignInPage> {
  final _phoneCtrl = TextEditingController(); // ej: +5215551112222
  final _codeCtrl = TextEditingController(); // ej: 123456 (prueba)
  String? _verificationId;
  int? _resendToken;
  bool _sending = false;
  bool _verifying = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty || !phone.startsWith('+')) {
      _snack('Ingresa un teléfono con prefijo internacional, p. ej. +521...');
      return;
    }
    setState(() => _sending = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android: a veces se verifica automáticamente (instant/auto-retrieval)
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (mounted) _snack('¡Verificación automática exitosa!');
            if (mounted) Navigator.pop(context); // o navega a Home
          } catch (e) {
            if (mounted) _snack('Error al iniciar sesión automáticamente');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          _snack(_mapPhoneError(e));
          setState(() => _sending = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
            _sending = false;
          });
          _snack('Código enviado. Revisa SMS (o usa el de prueba).');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          // No es error; significa que debes pedir el código manualmente.
        },
      );
    } catch (e) {
      _snack('Error enviando código');
      setState(() => _sending = false);
    }
  }

  Future<void> _verifyCode() async {
    final code = _codeCtrl.text.trim();
    final verId = _verificationId;
    if (verId == null) {
      _snack('Primero envía el código.');
      return;
    }
    if (code.length < 4) {
      _snack('Código inválido.');
      return;
    }

    setState(() => _verifying = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: code,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        _snack('Inicio de sesión exitoso');
        Navigator.pop(context); // o navega a tu HomePage
      }
    } on FirebaseAuthException catch (e) {
      _snack(_mapPhoneError(e));
    } catch (_) {
      _snack('No se pudo verificar el código.');
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  String _mapPhoneError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Teléfono inválido.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'session-expired':
        return 'La sesión de verificación expiró. Reenvía el código.';
      case 'code-expired':
        return 'El código expiró. Reenvía el SMS.';
      case 'invalid-verification-code':
        return 'Código incorrecto.';
      case 'missing-client-identifier':
        return 'Falta configuración de dispositivo. Agrega SHA-256 en Firebase.';
      default:
        return 'Error: ${e.code}';
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar con teléfono')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              controller: _phoneCtrl,
              hintText: 'Teléfono (con +52...)',
              obscureText: false,
            ),
            const SizedBox(height: 12),
            MyButton(
              onTap: _sending ? () {} : _sendCode,
              text: _sending ? 'Enviando...' : 'Enviar código',
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: _codeCtrl,
              hintText: 'Código SMS',
              obscureText: false,
            ),
            const SizedBox(height: 12),
            MyButton(
              onTap: _verifying ? () {} : _verifyCode,
              text: _verifying ? 'Verificando...' : 'Verificar e ingresar',
            ),
          ],
        ),
      ),
    );
  }
}
