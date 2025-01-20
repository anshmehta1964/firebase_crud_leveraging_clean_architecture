import 'package:api_handling/firebaseCRUD/components/MyTextField.dart';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:api_handling/firebaseCRUD/crud%20services/crud_services.dart';
import 'package:api_handling/firebaseCRUD/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:api_handling/firebaseCRUD/auth_service.dart';
import 'package:api_handling/firebaseCRUD/firebase%20signup/firebase_signup_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FbSignUp extends StatefulWidget {
  const FbSignUp({super.key});

  @override
  State<FbSignUp> createState() => _FbSignUpState();
}

class _FbSignUpState extends State<FbSignUp> {
  CrudServices va = CrudServices();
  final _auth = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTitle(title: 'Signup'),
                SizedBox(height: 20),
                BlocBuilder<FirebaseSignupBloc, FirebaseSignupState>(
                    builder: (context, state) {
                  if (state is SignupInvalidState) {
                    return Text(
                      state.errorMessage,
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return Container();
                  }
                }),
                SizedBox(height: 20),
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    onTextChanged: (val){
                      BlocProvider.of<FirebaseSignupBloc>(context).add(
                          SignupEmailChangedEvent(email: emailController.text));
                    }
                ),
                SizedBox(height: 10),
                MyTextField(
                    obscureText: true,
                    controller: passController,
                    hintText: 'Password',
                    onTextChanged: (val){
                      BlocProvider.of<FirebaseSignupBloc>(context).add(
                          SignupPasswordChangedEvent(
                              email: emailController.text,
                              password: passController.text));
                    }),
                SizedBox(height: 20),
                BlocBuilder<FirebaseSignupBloc, FirebaseSignupState>(
                  builder: (context, state) {
                    return CupertinoButton(
                      onPressed: (state is SignupValidState) ? () {
                        Navigator.pushNamed(context,RoutesName.loginScreen);
                              va.signUp(emailController.text,passController.text);
                              emailController.clear();
                              passController.clear();
                            } : () { },
                      color: (state is SignupInvalidState || state is SigninInitialState) ? Colors.grey : Theme.of(context).colorScheme.primary,
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        )
    );
  }
}
