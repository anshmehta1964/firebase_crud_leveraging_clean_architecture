import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecase/domain_usercase.dart';

part 'login_event.dart';
part 'login_state.dart';

class TempLogInBloc extends Bloc<TempLogInEvent, TempLogInState> {
  late final UserLogIn _userLogIn;
  TempLogInBloc({required UserLogIn userLogIn}) : _userLogIn = userLogIn, super(TempLogInInitialState()) {
    on<TempLogInEmailChangedEvent>((event,emit){
      if(!(EmailValidator.validate(event.email))){
        emit(TempLogInInvalidState(errorMessage: "Please enter a valid email!"));
      } else {
        emit(TempLogInInitialState());
      }
    });
    on<TempLogInPasswordChangedEvent>((event,emit){
      if(event.password.length < 8){
        emit(TempLogInInvalidState(errorMessage: "Please enter a valid password"));
        print('login invalid state');
      } else if(!(EmailValidator.validate(event.email))){
        emit(TempLogInInvalidState(errorMessage: "Please enter a valid email"));
        print('login invalid state');
      } else {
        emit(TempLogInValidState());
        print('Login valid state');
      }
    });
    on<TempLogInSubmittedEvent>((event,emit) async {
      bool checkCredentials = await _userLogIn.call(Parameters(email: event.email, password: event.password));
      // print('value of checkCredentials is : $checkCredentials');
      if(EmailValidator.validate(event.email) && !(event.password.length < 8 && checkCredentials)){
        emit(TempCredentialsVerifiedState());
        // print('credentials verified state');
      } else{
        // print('Login invalid state');
        emit(TempLogInInvalidState(errorMessage: "Email or password is not Valid"));
      }
    });
  }
}
