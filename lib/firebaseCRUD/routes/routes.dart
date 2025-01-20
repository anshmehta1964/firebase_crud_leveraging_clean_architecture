import 'package:api_handling/firebaseCRUD/crud_screen.dart';
import 'package:api_handling/firebaseCRUD/fb_home_screen.dart';
import 'package:api_handling/firebaseCRUD/fb_login_screen.dart';
import 'package:api_handling/firebaseCRUD/fb_signup_screen.dart';
import 'package:api_handling/firebaseCRUD/firebase%20crud%20bloc/firebase_crud_bloc.dart';
import 'package:api_handling/firebaseCRUD/firebase%20login/firebase_login_bloc.dart';
import 'package:api_handling/firebaseCRUD/firebase%20signup/firebase_signup_bloc.dart';
import 'package:api_handling/firebaseCRUD/routes/routes_name.dart';
import 'package:api_handling/firebaseCRUD/splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class Routes{
  static Route<dynamic> generateRoutes(RouteSettings settings){
    return CupertinoPageRoute(
        builder: (context) => _buildScreen(settings));
  }

  static Widget _buildScreen(RouteSettings settings){
    switch(settings.name){
      case RoutesName.splashScreen:
        return _withBloc(SplashScreen(), FirebaseCrudBloc());
      case RoutesName.loginScreen:
        return _withBloc(FbLogin(), FirebaseLoginBloc());
      case RoutesName.signUpScreen:
        return _withBloc(FbSignUp(), FirebaseSignupBloc());
      case RoutesName.crudScreen:
        return _withBloc(CrudScreen(), FirebaseCrudBloc());
      // case RoutesName.tempSplashScreen:
      //   return _withBloc(SplashScreenTemp());
      default:
        return _withBloc(fbHomeScreen());
    }
  }
  

  static _withBloc(Widget screen, [BlocBase? bloc]){
    if(bloc != null){
      return BlocProvider(
          create: (context) => bloc,
          child: screen
      );
    } else {
      return screen;
    }
  }
}