import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meta/meta.dart';

part 'firebase_signup_event.dart';
part 'firebase_signup_state.dart';

class FirebaseSignupBloc extends Bloc<FirebaseSignupEvent, FirebaseSignupState> {
  FirebaseSignupBloc() : super(SigninInitialState()) {
    on<SignupEmailChangedEvent>((event,emit){
      if(!(EmailValidator.validate(event.email))){
        emit(SignupInvalidState(errorMessage: "Please enter a valid email!"));
      } else {
        emit(SigninInitialState());
      }
    });
    on<SignupPasswordChangedEvent>((event,emit){
      if(event.password.length < 8){
        emit(SignupInvalidState(errorMessage: "Please enter a valid password"));
      } else{
        emit(SignupValidState());
      }
    });
    on<SingupSubmittedEvent>((event,emit){
      if(EmailValidator.validate(event.email) && event.password.length < 8){
        emit(SignupInvalidState(errorMessage: "Email or password is not Valid"));
      } else{

      }
    });
  }
}
