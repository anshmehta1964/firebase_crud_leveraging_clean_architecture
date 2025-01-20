import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

class MyAnimatedSplashScreen extends StatelessWidget{
  Widget nextScreen;
  MyAnimatedSplashScreen({super.key, required this.nextScreen});

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
      nextScreen: nextScreen,
    );
  }
}