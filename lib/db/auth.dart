import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> login(String email, String password) async {
    UserCredential userCredentials = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredentials.user;
    return user?.uid ?? "HATA";
  }

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredentials.user;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String?> getUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user?.email;
  }
}
