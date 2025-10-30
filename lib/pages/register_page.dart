import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_ai_app/components/button.dart';
import 'package:fit_ai_app/components/text_field.dart';
import 'package:fit_ai_app/pages/verify_email_page.dart';
import 'package:flutter/material.dart';

/// ===== Helpers de contraseña =====
bool _hasUpper(String s) => RegExp(r'[A-Z]').hasMatch(s);
bool _hasLower(String s) => RegExp(r'[a-z]').hasMatch(s);
bool _hasDigit(String s) => RegExp(r'\d').hasMatch(s);
bool _hasSpecial(String s) {
  return RegExp(r'[^\w\s]').hasMatch(s);
}

int _strengthScore(String s) {
  var score = 0;
  if (s.length >= 6) score++;
  if (s.length >= 10) score++; // bonus por longitud extra
  if (_hasUpper(s)) score++;
  if (_hasLower(s)) score++;
  if (_hasDigit(s)) score++;
  if (_hasSpecial(s)) score++;
  return score.clamp(0, 6);
}

List<String> _passwordIssues(String p) {
  final issues = <String>[];
  if (p.length < 6) issues.add('Al menos 6 caracteres');
  if (!_hasUpper(p)) issues.add('Al menos 1 mayúscula (A-Z)');
  if (!_hasLower(p)) issues.add('Al menos 1 minúscula (a-z)');
  if (!_hasDigit(p)) issues.add('Al menos 1 número (0-9)');
  if (!_hasSpecial(p)) issues.add('Al menos 1 carácter especial (!@#\$%...)');
  return issues;
}

/// Color de fuerza: rojo (débil) → azul (fuerte) usando HSV (0° a 220°)
Color _strengthColor(int score) {
  final t = (score / 6).clamp(0.0, 1.0);
  final hue = 220.0 * t; // 0=rojo, 220=azulado
  return HSVColor.fromAHSV(1, hue, 0.9, 0.9).toColor();
}

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  bool _showPassword = false; // 👁️ control del icono

  @override
  void initState() {
    super.initState();
    passwordTextController.addListener(() => setState(() {}));
  }

  bool get _showPasswordHelp => passwordTextController.text.isNotEmpty;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message)),
    );
  }

  Future<void> signUp() async {
    final pass = passwordTextController.text;
    final confirm = confirmPasswordTextController.text;

    if (pass != confirm) {
      displayMessage("Passwords don't match!");
      return;
    }

    final issues = _passwordIssues(pass);
    if (issues.isNotEmpty) {
      displayMessage('Tu contraseña no cumple:\n• ${issues.join('\n• ')}');
      return;
    }

    final score = _strengthScore(pass);
    if (score < 4) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Contraseña débil'),
          content: const Text(
            'Tu contraseña es válida, pero se considera débil.\n'
            'Usa 10+ caracteres con mayúsculas, minúsculas, números y símbolos.\n\n'
            '¿Deseas continuar de todas formas?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Mejorar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: pass,
      );

      final user = cred.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      if (mounted) Navigator.pop(context);
      if (mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const VerifyEmailPage()));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.message ?? e.code);
    }
  }

  Widget _strengthBar() {
    final score = _strengthScore(passwordTextController.text);
    final color = _strengthColor(score);
    final label = (score >= 5)
        ? 'Fuerte'
        : (score >= 3)
        ? 'Media'
        : 'Débil';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: score / 6,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text('Fuerza: $label', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _passwordChecklist() {
    final p = passwordTextController.text;
    final items = <_ReqItem>[
      _ReqItem('Al menos 6 caracteres', p.length >= 6),
      _ReqItem('Al menos 1 mayúscula (A-Z)', _hasUpper(p)),
      _ReqItem('Al menos 1 minúscula (a-z)', _hasLower(p)),
      _ReqItem('Al menos 1 número (0-9)', _hasDigit(p)),
      _ReqItem('Al menos 1 carácter especial (!@#\$%...)', _hasSpecial(p)),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: items
            .map(
              (e) => Row(
                children: [
                  Icon(
                    e.ok ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: e.ok ? Colors.green : Colors.redAccent,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      e.text,
                      style: TextStyle(
                        fontSize: 12,
                        color: e.ok ? Colors.green[800] : Colors.red[800],
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 100),
                  const SizedBox(height: 50),
                  const Text("Let's create an account for you!"),
                  const SizedBox(height: 25),

                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // 🔒 Campo de contraseña con icono de mostrar/ocultar
                  TextField(
                    controller: passwordTextController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),

                  // Solo mostrar barra y checklist cuando haya texto
                  if (_showPasswordHelp) ...[
                    _strengthBar(),
                    _passwordChecklist(),
                  ],

                  const SizedBox(height: 10),

                  TextField(
                    controller: confirmPasswordTextController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  MyButton(onTap: signUp, text: 'Sign Up'),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReqItem {
  final String text;
  final bool ok;
  _ReqItem(this.text, this.ok);
}
