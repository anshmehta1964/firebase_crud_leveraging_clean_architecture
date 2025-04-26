part of 'login_bloc.dart';

@immutable
sealed class TempLogInEvent {}

class TempLogInEmailChangedEvent extends TempLogInEvent {
  final String email;
  final String password;
  final BuildContext context;
  TempLogInEmailChangedEvent(
      {required this.email, required this.password, required this.context});
}

class TempLogInPasswordChangedEvent extends TempLogInEvent {
  final String password;
  final String email;
  final BuildContext context;
  TempLogInPasswordChangedEvent(
      {required this.password, required this.email, required this.context});
}

class TempLogInSubmittedEvent extends TempLogInEvent {
  final String email;
  final String password;
  final BuildContext context;
  TempLogInSubmittedEvent(
      {required this.email, required this.password, required this.context});
}

class TempCredentialsVerifiedEvent extends TempLogInEvent {}
