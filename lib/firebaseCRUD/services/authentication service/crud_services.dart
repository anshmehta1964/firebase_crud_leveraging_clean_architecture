import 'dart:developer';
import 'auth_service.dart';

class CrudServices {
  // CrudServices instance = CrudServices();
  static final _auth = AuthService();

  Future<void> signUp(String email, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(email, password);
    if (user != null) {
      log("user created successfully using Crud Services");
    } else {
      log("user not created using Crud Services");
    }
  }
}
