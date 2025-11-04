import 'package:firebase_auth/firebase_auth.dart';
import 'package:freet/sesion/auth/social_auth.dart';
import 'package:freet/sesion/components/button.dart';
import 'package:freet/sesion/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:freet/sesion/pages/reset_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  //text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  //sign user in method
  void signIn() async {
    //
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void resetPassword() {
    //
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
    );
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                Icon(Icons.lock, size: 100),

                //message
                const SizedBox(height: 50),
                Text('Welcome back you\'ve been missed!'),
                const SizedBox(height: 25),

                //username textfield(email)
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                //password textfield
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                //go to register page
                const SizedBox(height: 10),
                MyButton(onTap: signIn, text: 'Sign In'),

                const SizedBox(height: 25),

                const SizedBox(height: 20),
                Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google
                    IconButton(
                      icon: Image.asset('assets/images/google.png', width: 30),
                      onPressed: () async {
                        final user = await SocialAuth.signInWithGoogle();
                        if (user != null) {
                          // Navega al Home o AuthGate automáticamente
                        }
                      },
                    ),

                    const SizedBox(width: 20),

                    // Facebook
                    IconButton(
                      icon:
                          Image.asset('assets/images/facebook.png', width: 30),
                      onPressed:
                          () {} /* async {
                        final user = await SocialAuth.signInWithFacebook();
                        if (user != null) {
                          // Navega al Home o AuthGate automáticamente
                        }
                      }, */
                      ,
                    ),

                    const SizedBox(width: 20),

                    // Phone
                    IconButton(
                      onPressed: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneSignInPage(),
                          ),
                        ); */
                      },
                      icon: Image.asset('assets/images/phone.png', width: 30),
                    ),
                  ],
                ),

                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),

                //forgot password
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    resetPassword();
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
