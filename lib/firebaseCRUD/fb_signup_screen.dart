import 'package:api_handling/firebaseCRUD/components/MyTextField.dart';
import 'package:api_handling/firebaseCRUD/fb_login_screen.dart';
import 'package:api_handling/firebaseCRUD/firebase%20login/firebase_login_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:api_handling/firebaseCRUD/auth_service.dart';
import 'package:api_handling/firebaseCRUD/firebase%20signup/firebase_signup_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FbSignUp extends StatefulWidget {
  const FbSignUp({super.key});

  @override
  State<FbSignUp> createState() => _FbSignUpState();
}

class _FbSignUpState extends State<FbSignUp> {
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
                Text(
                  'Signup',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
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
                      onPressed: (state is SignupValidState)
                          ? () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (context) =>
                                                FirebaseLoginBloc(),
                                            child: FbLogin(),
                                          )));
                              signUp();
                              emailController.clear();
                              passController.clear();
                            }
                          : () {},
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
  signUp() async {
    final user = await _auth.createUserWithEmailAndPassword(emailController.text, passController.text);
    if(user != null){
      log("user created successfully");
    } else {
      log("user not created");
    }
  }
}
