import 'package:api_handling/firebaseCRUD/components/MyCupertinoButton.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/routes_name.dart';

class TempHomeScreen extends StatelessWidget {
  const TempHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyCupertinoButton(
                      onPress: () {
                        Navigator.pushNamed(
                            context, RoutesName.tempSignUpScreen);
                      },
                      title: 'Sign in'),
                  SizedBox(width: 15),
                  MyCupertinoButton(
                      onPress: () {
                        Navigator.pushNamed(
                            context, RoutesName.tempLoginScreen);
                      },
                      title: 'Login')
                ],
              )
            ],
          ),
        ));
  }
}
