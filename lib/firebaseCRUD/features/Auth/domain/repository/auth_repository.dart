abstract interface class AuthRepository {
  void signInWithEmailPassword(
      {required String email, required String password});
  Future<bool> logInWithEmailPassword(
      {required String email, required String password});
}
