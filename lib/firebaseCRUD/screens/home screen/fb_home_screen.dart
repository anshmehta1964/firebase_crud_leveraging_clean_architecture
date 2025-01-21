import 'package:api_handling/firebaseCRUD/components/MyCupertinoButton.dart';
import 'package:api_handling/firebaseCRUD/fb_signup_screen.dart';
import 'package:api_handling/firebaseCRUD/firebase%20login/firebase_login_bloc.dart';
import 'package:api_handling/firebaseCRUD/firebase%20signup/firebase_signup_bloc.dart';
import 'package:api_handling/firebaseCRUD/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../fb_login_screen.dart';

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
                  MyCupertinoButton(onPress: (){
                    Navigator.pushNamed(context, RoutesName.signUpScreen);
                    },
                      title: 'Sign in'),
                  SizedBox(width: 15),
                  MyCupertinoButton(
                      onPress: (){
                        Navigator.pushNamed(context, RoutesName.loginScreen);
                      },
                      title: 'Login'
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
