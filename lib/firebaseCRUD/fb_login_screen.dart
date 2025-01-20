import 'dart:developer';

import 'package:api_handling/firebaseCRUD/auth_service.dart';
import 'package:api_handling/firebaseCRUD/crud_screen.dart';
import 'package:api_handling/firebaseCRUD/firebase%20crud%20bloc/firebase_crud_bloc.dart';
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
                Text(
                  'Login',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
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
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                  onChanged: (val) {
                    BlocProvider.of<FirebaseLoginBloc>(context).add(
                        LoginEmailChangedEvent(email: emailController.text));
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: passController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      filled: true,
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                  onChanged: (val) {
                    BlocProvider.of<FirebaseLoginBloc>(context).add(
                        LoginPasswordChangedEvent(
                          email: emailController.text,
                            password: passController.text));
                  },
                ),
                SizedBox(height: 20),
                BlocListener<FirebaseLoginBloc, FirebaseLoginState>(
                  listener: (context, state) {
                    if (state is CredentialsVerifiedState) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => FirebaseCrudBloc(),
                                    child: CrudScreen(),
                                  )
                          )
                      );
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
        ));
  }
  
}
