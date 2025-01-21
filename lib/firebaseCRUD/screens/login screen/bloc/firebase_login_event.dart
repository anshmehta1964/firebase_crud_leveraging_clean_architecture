part of 'firebase_login_bloc.dart';

class FirebaseLoginEvent {}

class LoginEmailChangedEvent extends FirebaseLoginEvent{
  String email;
  LoginEmailChangedEvent({required this.email});
}

class LoginPasswordChangedEvent extends FirebaseLoginEvent{
  String password;
  String email;
  LoginPasswordChangedEvent({required this.password, required this.email});
}

class LoginSubmittedEvent extends FirebaseLoginEvent{
  String email;
  String password;
  LoginSubmittedEvent({required this.email, required this.password});
}

class CredentialsVerifiedEvent extends FirebaseLoginEvent{}