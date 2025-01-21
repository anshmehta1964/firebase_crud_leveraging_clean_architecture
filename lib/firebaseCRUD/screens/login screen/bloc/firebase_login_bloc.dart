import 'dart:developer';

import 'package:api_handling/firebaseCRUD/services/authentication%20service/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';

part 'firebase_login_event.dart';
part 'firebase_login_state.dart';

class FirebaseLoginBloc extends Bloc<FirebaseLoginEvent, FirebaseLoginState> {
  final _auth = AuthService();

  FirebaseLoginBloc() : super(LoginInitialState()) {
    on<LoginEmailChangedEvent>((event,emit){
      if(!(EmailValidator.validate(event.email))){
        emit(LoginInvalidState(errorMessage: "Please enter a valid email!"));
      } else {
        emit(LoginInitialState());
      }
    });
    on<LoginPasswordChangedEvent>((event,emit){
      if(event.password.length < 8){
        emit(LoginInvalidState(errorMessage: "Please enter a valid password"));
      } else if(!(EmailValidator.validate(event.email))){
        emit(LoginInvalidState(errorMessage: "Please enter a valid email"));
      } else {
        emit(LoginValidState());
      }
    });
    on<LoginSubmittedEvent>((event,emit) async {
      bool checkCredentials = await login(event.email, event.password);
      if(EmailValidator.validate(event.email) && !(event.password.length < 8) && checkCredentials){
        emit(CredentialsVerifiedState());
      } else{
        emit(LoginInvalidState(errorMessage: "Email or password is not Valid"));
      }
    });
  }
  Future<bool> login(String email, String password) async {
    final user = await _auth.loginUserWithEmailPassword(email, password);
    if(user != null){
      log("User logged in Successfully");
      return true;
    } else {
      log("User not Logged in");
      return false;
    }
  }
}