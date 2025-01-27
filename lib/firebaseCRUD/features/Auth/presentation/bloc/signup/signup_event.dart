part of 'signup_bloc.dart';

@immutable
sealed class TempSignUpEvent {}

class TempSignUpEmailChangedEvent extends TempSignUpEvent{
  final String email;
  // String password;
  TempSignUpEmailChangedEvent({
    required this.email,
    // required this.password
  });
}

class TempSignUpPasswordChangedEvent extends TempSignUpEvent{
  final String email;
  final String password;
  TempSignUpPasswordChangedEvent({required this.password, required this.email});
}

class TempSignUpSubmittedEvent extends TempSignUpEvent{
  final String email;
  final String password;
  TempSignUpSubmittedEvent({required this.email, required this.password});
}
