import 'package:api_handling/firebaseCRUD/components/MyTextField.dart';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes_name.dart';
import '../bloc/login/login_bloc.dart';

class TempLogin extends StatefulWidget {
  const TempLogin({super.key});

  @override
  State<TempLogin> createState() => _FbLoginState();
}

class _FbLoginState extends State<TempLogin> {
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
                BlocBuilder<TempLogInBloc, TempLogInState>(
                    builder: (context, state) {
                  if (state is TempLogInInvalidState) {
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
                    onTextChanged: (val) {
                      BlocProvider.of<TempLogInBloc>(context).add(
                          TempLogInEmailChangedEvent(
                              email: emailController.text));
                    }),
                SizedBox(height: 10),
                MyTextField(
                    obscureText: true,
                    controller: passController,
                    hintText: 'Password',
                    onTextChanged: (val) {
                      BlocProvider.of<TempLogInBloc>(context).add(
                          TempLogInPasswordChangedEvent(
                              email: emailController.text,
                              password: passController.text));
                    }),
                SizedBox(height: 20),
                BlocListener<TempLogInBloc, TempLogInState>(
                  listener: (context, state) {
                    if (state is TempCredentialsVerifiedState) {
                      Navigator.pushNamed(context, RoutesName.tempCrudScreen);
                      emailController.clear();
                      passController.clear();
                    }
                  },
                  child: BlocBuilder<TempLogInBloc, TempLogInState>(
                    builder: (context, state) {
                      return CupertinoButton(
                        onPressed: () {
                          BlocProvider.of<TempLogInBloc>(context).add(
                              TempLogInSubmittedEvent(
                                  email: emailController.text,
                                  password: passController.text));
                        },
                        color: (state is TempLogInInvalidState ||
                                state is TempLogInInitialState)
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        child: Text(
                          'Log in',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
