import 'package:api_handling/firebaseCRUD/components/MyTextField.dart';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:api_handling/firebaseCRUD/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase login/firebase_login_bloc.dart';

class FbLogin extends StatefulWidget {
  const FbLogin({super.key});

  @override
  State<FbLogin> createState() => _FbLoginState();
}

class _FbLoginState extends State<FbLogin> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
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
                MyTitle(title: 'Login'),
                SizedBox(height: 20),
                BlocBuilder<FirebaseLoginBloc, FirebaseLoginState>(
                    builder: (context, state) {
                  if (state is LoginInvalidState) {
                    return Text(
                      state.errorMessage,
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return Container();
                  }
                }),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    onTextChanged: (val){
                      BlocProvider.of<FirebaseLoginBloc>(context).add(
                          LoginEmailChangedEvent(email: emailController.text));
                    }),
                SizedBox(height: 10),
                MyTextField(
                    obscureText: true,
                    controller: passController,
                    hintText: 'Password',
                    onTextChanged: (val){
                      BlocProvider.of<FirebaseLoginBloc>(context).add(
                          LoginPasswordChangedEvent(
                              email: emailController.text,
                              password: passController.text));
                    }),
                SizedBox(height: 20),
                BlocListener<FirebaseLoginBloc, FirebaseLoginState>(
                  listener: (context, state) {
                    if (state is CredentialsVerifiedState) {
                      Navigator.pushNamed(context, RoutesName.crudScreen);
                      emailController.clear();
                      passController.clear();
                    }
                  },
                  child: BlocBuilder<FirebaseLoginBloc, FirebaseLoginState>(
                    builder: (context, state) {
                      return CupertinoButton(
                        onPressed: () {
                          BlocProvider.of<FirebaseLoginBloc>(context).add(
                              LoginSubmittedEvent(
                                  email: emailController.text,
                                  password: passController.text));
                        },
                        color: (state is LoginInvalidState || state is LoginInitialState)
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
  
}
