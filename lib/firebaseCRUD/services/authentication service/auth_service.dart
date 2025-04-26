import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final createCredentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return createCredentials.user;
    } catch (e) {
      log("Error Occurred in auth_service.dart file createUserMethod");
    }
    return null;
  }

  Future<User?> loginUserWithEmailPassword(
      String email, String password) async {
    try {
      final loginCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return loginCredentials.user;
    } catch (e) {
      log("Error Occurred in auth_service.dart file loginUserMethod");
    }
    return null;
  }
}
