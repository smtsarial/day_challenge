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

  Future<String> signUp(String email, String password) async {
    UserCredential userCredentials = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredentials.user;
    return user?.uid ?? "";
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<User?> getUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user;
  }
}
