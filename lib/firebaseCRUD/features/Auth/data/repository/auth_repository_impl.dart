import 'dart:developer';

import 'package:api_handling/firebaseCRUD/features/Auth/data/datasource/auth_remote_data_source.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  AuthRepositoryImpl(this.remoteDatasource);
  @override
  Future<bool> logInWithEmailPassword(
      {required String email, required String password}) async {
    // log('Auth Repo Impl : Log In() called');
    return await remoteDatasource.logInWithEmailPassword(
        email: email, password: password);
  }

  @override
  void signInWithEmailPassword(
      {required String email, required String password}) {
    remoteDatasource.signInWithEmailPassword(email: email, password: password);
    // log('Auth Repo Impl : Sign In() called');
  }
}
