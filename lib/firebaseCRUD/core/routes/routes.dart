import 'package:api_handling/firebaseCRUD/core/routes/routes_name.dart';
import 'package:api_handling/firebaseCRUD/screens/crud%20screen/pages/crud_screen.dart';
import 'package:api_handling/firebaseCRUD/screens/home%20screen/pages/fb_home_screen.dart';
import 'package:api_handling/firebaseCRUD/screens/login%20screen/pages/fb_login_screen.dart';
import 'package:api_handling/firebaseCRUD/screens/signup%20screen/pages/fb_signup_screen.dart';
import 'package:api_handling/firebaseCRUD/screens/crud%20screen/bloc/firebase_crud_bloc.dart';
import 'package:api_handling/firebaseCRUD/screens/login%20screen/bloc/firebase_login_bloc.dart';
import 'package:api_handling/firebaseCRUD/screens/signup%20screen/bloc/firebase_signup_bloc.dart';
import 'package:api_handling/firebaseCRUD/screens/splash%20screen/pages/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes{
  static Route<dynamic> generateRoutes(RouteSettings settings){
    return CupertinoPageRoute(
        builder: (context) => _buildScreen(settings));
  }

  static Widget _buildScreen(RouteSettings settings){
    switch(settings.name){
      case RoutesName.splashScreen:
        return _withBloc(SplashScreen());
      case RoutesName.loginScreen:
        return _withBloc(FbLogin(), FirebaseLoginBloc());
      case RoutesName.signUpScreen:
        return _withBloc(FbSignUp(), FirebaseSignupBloc());
      case RoutesName.crudScreen:
        return _withBloc(CrudScreen(), FirebaseCrudBloc());
      default:
        return _withBloc(FbHomeScreen());
    }
  }

  static _withBloc(Widget screen, [BlocBase? bloc]){
    if(bloc != null){
      return BlocProvider(
          create: (_) => bloc,
          child: screen
      );
    } else {
      return screen;
    }
  }
}