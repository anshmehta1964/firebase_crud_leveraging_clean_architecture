import 'package:api_handling/firebaseCRUD/components/MyCupertinoButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../core/localization/languages.dart';
import '../../../../core/routes/routes_name.dart';

class TempHomeScreen extends StatelessWidget {
  const TempHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Colors.white,
                Colors.grey.shade300,
                Colors.grey.shade500,
                Colors.grey.shade900
              ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(5.80))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocale.title.getString(context),
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
                        title: AppLocale.signIn.getString(context)),
                    SizedBox(width: 15),
                    MyCupertinoButton(
                        onPress: () {
                          Navigator.pushNamed(
                              context, RoutesName.tempLoginScreen);
                        },
                        title: AppLocale.logIn.getString(context))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
