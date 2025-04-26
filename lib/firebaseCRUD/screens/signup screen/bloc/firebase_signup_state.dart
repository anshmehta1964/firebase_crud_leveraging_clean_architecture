part of 'firebase_signup_bloc.dart';

class FirebaseSignupState {}

class SigninInitialState extends FirebaseSignupState {}

class SignupEmailValidState extends FirebaseSignupState {}

class SignupPasswordValidState extends FirebaseSignupState {}

class SignupInvalidState extends FirebaseSignupState {
  String errorMessage;
  SignupInvalidState({required this.errorMessage});
}

class SignupValidState extends FirebaseSignupState {}
