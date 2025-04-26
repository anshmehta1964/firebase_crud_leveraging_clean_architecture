part of 'firebase_signup_bloc.dart';

class FirebaseSignupEvent {}

class SignupEmailChangedEvent extends FirebaseSignupEvent {
  String email;
  // String password;
  SignupEmailChangedEvent({
    required this.email,
    // required this.password
  });
}

class SignupPasswordChangedEvent extends FirebaseSignupEvent {
  String email;
  String password;
  SignupPasswordChangedEvent({required this.password, required this.email});
}

class SingupSubmittedEvent extends FirebaseSignupEvent {
  String email;
  String password;
  SingupSubmittedEvent({required this.email, required this.password});
}
