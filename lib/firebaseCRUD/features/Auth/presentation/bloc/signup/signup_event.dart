part of 'signup_bloc.dart';

@immutable
sealed class TempSignUpEvent {}

class TempSignUpEmailChangedEvent extends TempSignUpEvent {
  final String email;
  final String password;
  final BuildContext context;
  // String password;
  TempSignUpEmailChangedEvent({
    required this.email,
    required this.password,
    required this.context
    // required this.password
  });
}

class TempSignUpPasswordChangedEvent extends TempSignUpEvent {
  final String email;
  final String password;
  final BuildContext context;
  TempSignUpPasswordChangedEvent({
    required this.password,
    required this.email,
    required this.context
  });
}

class TempSignUpSubmittedEvent extends TempSignUpEvent {
  final String email;
  final String password;
  final BuildContext context;
  TempSignUpSubmittedEvent({
    required this.email,
    required this.password,
    required this.context
  });
}
