import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController =
      AnimationController(duration: const Duration(seconds: 5), vsync: this);

  @override
  void initState() {
    animationController.forward();
    isLogin(context);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> fadeAnimator = CurvedAnimation(
        parent: animationController, curve: Curves.fastEaseInToSlowEaseOut);
    return Scaffold(
        body: Center(
            child: FadeTransition(
                opacity: fadeAnimator,
                child: Image.asset(
                  'assets/firebase_logo.png',
                  height: 50,
                  width: 50,
                ))));
  }

  void isLogin(BuildContext context) {
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.homeScreen, (route) => false));
  }
}
