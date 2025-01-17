import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:api_handling/firebaseCRUD/fb_home_screen.dart';
import 'package:api_handling/firebaseCRUD/fb_login_screen.dart';
import 'package:api_handling/firebaseCRUD/firebase%20signup/firebase_signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Image(
              image: AssetImage("assets/firebase_logo.png"),
              height: 200,
              width: 200,
            ),
          ),
        ),
        // splashIconSize: 100.0,
        centered: true,
        duration: 3100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        disableNavigation: false,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: Duration(seconds: 3),
        nextScreen:fbHomeScreen(),
        );
  }
}
