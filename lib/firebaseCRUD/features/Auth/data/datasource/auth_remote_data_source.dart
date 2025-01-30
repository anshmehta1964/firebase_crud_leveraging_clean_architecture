import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDatasource {
  Future<User?> signInWithEmailPassword(
      {required String email, required String password});
  Future<bool> logInWithEmailPassword(
      {required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuthInstance;
  final FirebaseFirestore firebaseFirestore;
  AuthRemoteDataSourceImpl(this.firebaseAuthInstance, this.firebaseFirestore);

  @override
  Future<bool> logInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final loginCredentials = await firebaseAuthInstance
          .signInWithEmailAndPassword(email: email, password: password);
      if (loginCredentials.user != null) {
        // log('Remote DataSource : user logged in successfully');
        return true;
      }
    } catch (e) {
      log("Error Occurred in auth_remote_data_source.dart file loginUserMethod");
    }
    return false;
  }

  @override
  Future<User?> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final createCredentials = await firebaseAuthInstance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (createCredentials.user != null) {
        // log('Remote Datasource : User Created Successfully');
      }
      return createCredentials.user;
    } catch (e) {
      // log("Remote Datasource : Error Occurred in auth_service.dart file createUserMethod");
    }
    return null;
  }
}
