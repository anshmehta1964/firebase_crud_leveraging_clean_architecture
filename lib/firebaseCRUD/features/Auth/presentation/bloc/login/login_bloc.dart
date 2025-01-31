import 'dart:developer';

import 'package:api_handling/firebaseCRUD/core/localization/languages.dart';
import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecase/auth_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class TempLogInBloc extends Bloc<TempLogInEvent, TempLogInState> {
  late final UserLogIn _userLogIn;
  @override
  void onChange(Change<TempLogInState> change){
    log('From : ${change.currentState} To : ${change.nextState}');
    super.onChange(change);
  }
  TempLogInBloc({required UserLogIn userLogIn})
      : _userLogIn = userLogIn,
        super(TempLogInInitialState()) {
    on<TempLogInEmailChangedEvent>((event, emit) {
      if(event.email == "" && event.password == ""){
        emit(TempLogInInitialState());
      } else if (!(EmailValidator.validate(event.email))) {
        emit(TempLogInInvalidState(errorMessage: AppLocale.emailerror.getString(event.context)));
      } else if (EmailValidator.validate(event.email) && event.password.length < 8){
        emit(TempLogInInitialState());
      } else {
        emit(TempLogInValidState());
      }
    });
    on<TempLogInPasswordChangedEvent>((event, emit) {
      if(event.email == "" && event.password == ""){
        emit(TempLogInInitialState());
      } else if (event.password.length < 8) {
        emit(TempLogInInvalidState(
            errorMessage: AppLocale.passerror.getString(event.context)));
        // print('login invalid state');
      } else if (!(EmailValidator.validate(event.email))) {
        emit(TempLogInInvalidState(errorMessage: AppLocale.emailerror.getString(event.context)));
        // print('login invalid state');
      } else {
        emit(TempLogInValidState());
        // print('Login valid state');
      }
    });
    on<TempLogInSubmittedEvent>((event, emit) async {
      bool checkCredentials = await _userLogIn
          .call(Parameters(email: event.email, password: event.password));
      // print('value of checkCredentials is : $checkCredentials');
      if (EmailValidator.validate(event.email) && !(event.password.length < 8) && checkCredentials) {
        emit(TempCredentialsVerifiedState());
        // print('credentials verified state');
      } else {
        // print('Login invalid state');
        emit(TempLogInInvalidState(
            errorMessage: AppLocale.emailAndPassError.getString(event.context)));
      }
    });
  }
}
