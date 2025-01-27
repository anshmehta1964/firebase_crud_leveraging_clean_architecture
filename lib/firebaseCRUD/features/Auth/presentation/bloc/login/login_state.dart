part of 'login_bloc.dart';

@immutable
sealed class TempLogInState {}

class TempLogInEmailValidState extends TempLogInState {}

class TempLogInPasswordValidState extends TempLogInState{}

class TempLogInInvalidState extends TempLogInState {
  final String errorMessage;
  TempLogInInvalidState({required this.errorMessage});
}

class TempLogInValidState extends TempLogInState{}

class TempCredentialsVerifiedState extends TempLogInState{}

class TempLogInInitialState extends TempLogInState{}