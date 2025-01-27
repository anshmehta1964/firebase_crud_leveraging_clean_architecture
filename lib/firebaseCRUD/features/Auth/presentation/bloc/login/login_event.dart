part of 'login_bloc.dart';

@immutable
sealed class TempLogInEvent {}

class TempLogInEmailChangedEvent extends TempLogInEvent{
  final String email;
  TempLogInEmailChangedEvent({required this.email});
}

class TempLogInPasswordChangedEvent extends TempLogInEvent{
  final String password;
  final String email;
  TempLogInPasswordChangedEvent({required this.password, required this.email});
}

class TempLogInSubmittedEvent extends TempLogInEvent{
  final String email;
  final String password;
  TempLogInSubmittedEvent({required this.email, required this.password});
}

class TempCredentialsVerifiedEvent extends TempLogInEvent{}