part of 'firebase_signup_bloc.dart';

class FirebaseSignupEvent {}

class SignupEmailChangedEvent extends FirebaseSignupEvent{
  String email;
  SignupEmailChangedEvent({required this.email});
}

class SignupPasswordChangedEvent extends FirebaseSignupEvent{
  String password;
  SignupPasswordChangedEvent({required this.password});
}

class SingupSubmittedEvent extends FirebaseSignupEvent{
  String email;
  String password;
  SingupSubmittedEvent({required this.email, required this.password});
}



