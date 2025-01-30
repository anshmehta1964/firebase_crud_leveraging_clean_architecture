import 'package:api_handling/firebaseCRUD/core/localization/languages.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/data/datasource/auth_remote_data_source.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/data/repository/auth_repository_impl.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/domain/usecase/auth_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:meta/meta.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class TempSignUpBloc extends Bloc<TempSignUpEvent, TempSignUpState> {
  late UserSignUp _userSignUp;
  TempSignUpBloc({required UserSignUp userSignUp})
      : _userSignUp = userSignUp,
        super(TempSignUpInitial()) {
    on<TempSignUpEmailChangedEvent>((event, emit) {
      if (!(EmailValidator.validate(event.email))) {
        emit(TempSignUpInvalidState(
            errorMessage: AppLocale.emailerror.getString(event.context)));
      } else {
        emit(TempSignInInitialState());
      }
    });
    on<TempSignUpPasswordChangedEvent>((event, emit) {
      if (event.password.length < 8) {
        emit(TempSignUpInvalidState(
            errorMessage: AppLocale.passerror.getString(event.context)));
      } else if (!(EmailValidator.validate(event.email))) {
        emit(
            TempSignUpInvalidState(errorMessage: AppLocale.emailerror.getString(event.context)));
      } else {
        emit(TempSignUpValidState());
      }
    });
    on<TempSignUpSubmittedEvent>((event, emit) {
      if (EmailValidator.validate(event.email) && event.password.length > 8) {
        // _userSignUp = UserSignUp(AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance,FirebaseFirestore.instance)));
        _userSignUp
            .call(Parameters(email: event.email, password: event.password));
      } else {
        emit(TempSignUpInvalidState(
            errorMessage: AppLocale.emailAndPassError.getString(event.context)));
      }
    });
  }
}
