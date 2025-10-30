import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialAuth {
  static final _auth = FirebaseAuth.instance;

  /// 🔹 Iniciar sesión con Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // usuario canceló

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error Google login: $e');
      return null;
    }
  }

  /// 🔹 Iniciar sesión con Facebook
  static Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(
          result.accessToken!.token,
        );
        return await _auth.signInWithCredential(credential);
      } else if (result.status == LoginStatus.cancelled) {
        return null;
      } else {
        print('Facebook login failed: ${result.message}');
        return null;
      }
    } catch (e) {
      print('Error Facebook login: $e');
      return null;
    }
  }

  /// 🔹 Cerrar sesión universal
  static Future<void> signOutAll() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
