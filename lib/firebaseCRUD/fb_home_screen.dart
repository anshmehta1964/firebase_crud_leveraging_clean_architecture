import 'package:api_handling/firebaseCRUD/fb_signup_screen.dart';
import 'package:api_handling/firebaseCRUD/firebase%20login/firebase_login_bloc.dart';
import 'package:api_handling/firebaseCRUD/firebase%20signup/firebase_signup_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fb_login_screen.dart';

class fbHomeScreen extends StatelessWidget {
  const fbHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 40
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text('Sign in',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, CupertinoPageRoute(builder: (context) =>
                            BlocProvider(
                              create: (context) => FirebaseSignupBloc(),
                              child: FbSignUp(),
                            )));
                      }),
                  SizedBox(width: 15),
                  CupertinoButton(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text('Log in',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary
                          )
                      ),
                      onPressed: () {
                        Navigator.push(context, CupertinoPageRoute(
                            builder: (context) =>
                                BlocProvider(
                                  create: (context) => FirebaseLoginBloc(),
                                  child: FbLogin(),
                                )));
                      })
                ],
              )
            ],
          ),
        )
    );
  }
}
