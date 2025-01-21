part of 'firebase_login_bloc.dart';

class FirebaseLoginState {}

class LoginEmailValidState extends FirebaseLoginState {}

class LoginPasswordValidState extends FirebaseLoginState{}

class LoginInvalidState extends FirebaseLoginState {
  String errorMessage;
  LoginInvalidState({required this.errorMessage});
}

class LoginValidState extends FirebaseLoginState{}

class CredentialsVerifiedState extends FirebaseLoginState{}

class LoginInitialState extends FirebaseLoginState{}
