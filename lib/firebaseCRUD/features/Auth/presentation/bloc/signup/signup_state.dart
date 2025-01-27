part of 'signup_bloc.dart';

@immutable
sealed class TempSignUpState {}

final class TempSignUpInitial extends TempSignUpState {}

class TempSignInInitialState extends TempSignUpState{}

class TempSignUpEmailValidState extends TempSignUpState {}

class TempSignUpPasswordValidState extends TempSignUpState{}

class TempSignUpInvalidState extends TempSignUpState {
  final String errorMessage;
  TempSignUpInvalidState({
    required this.errorMessage
  });
}

class TempSignUpValidState extends TempSignUpState{}

