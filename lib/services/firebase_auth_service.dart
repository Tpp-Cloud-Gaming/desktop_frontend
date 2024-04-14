import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final StreamController<bool> _emailVerificationController = StreamController<bool>.broadcast();

  Stream<bool> get emailVerificationStatus => _emailVerificationController.stream;

  Future<String?> loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      //Comentar si no se quiere imprimir el token
      print(await FirebaseAuth.instance.currentUser!.getIdToken());
      await prefs.setString('username', FirebaseAuth.instance.currentUser!.displayName ?? "username");
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Revisar el usuario y/o contraseña.';
      } else if (e.code == 'wrong-password') {
        return 'Revisar el usuario y/o contraseña.';
      } else if (e.code == "user-disabled") {
        return "Usuario Bloqueado";
      }
    }
    return 'Error inesperado';
  }

  String? getUsername() {
    if (FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    return FirebaseAuth.instance.currentUser!.displayName;
  }

  String? getEmail() {
    return FirebaseAuth.instance.currentUser!.email;
  }

  Future<String?> registerWithEmail(String email, String password, String username) async {
    UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    await user.user!.updateDisplayName(username);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    //TODO: encriptar?
    await prefs.setString('password', password);
    //return sendEmailVerification();
    return user.user!.getIdToken();
  }

  Future<bool> changeUsername(String username) async {
    FirebaseAuth.instance.currentUser?.updateDisplayName(username);
    return true;
  }

  Future<void> startEmailVerificationCheck() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      bool isVerified = await isEmailVerified();
      // print("Email verification status: $isVerified");
      _emailVerificationController.add(isVerified);
      if (isVerified) {
        break;
      }
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
    await user?.reload();
    _emailVerificationController.add(user?.emailVerified ?? false);
  }

  Future<String?> getToken() async {
    return await FirebaseAuth.instance.currentUser!.getIdToken();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
