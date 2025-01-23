import 'dart:math';

import 'package:api_handling/data/models/post_model.dart';
import 'package:api_handling/data/repositories/post_repository.dart';
import 'package:api_handling/firebaseCRUD/screens/crud%20screen/pages/crud_screen.dart';
import 'package:api_handling/firebaseCRUD/screens/login%20screen/pages/fb_login_screen.dart';
import 'package:api_handling/firebaseCRUD/networkController/dependency_injection.dart';
import 'package:api_handling/logic/cubits/post_cubit/post_cubit.dart';
import 'package:api_handling/presentation/screens/home_screen.dart';
import 'package:api_handling/rxdart/rx_home.dart';
import 'package:api_handling/services/notification_service.dart';
import 'package:api_handling/streams/basic_streams.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'firebaseCRUD/core/routes/routes.dart';
import 'firebaseCRUD/core/routes/routes_name.dart';
import 'firebaseCRUD/core/theme/theme_provider.dart';
import 'firebaseCRUD/screens/crud screen/bloc/firebase_crud_bloc.dart';
import 'firebaseCRUD/screens/login screen/bloc/firebase_login_bloc.dart';
import 'firebaseCRUD/screens/signup screen/bloc/firebase_signup_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  // await NotificationService.instance.intialize();
  // PostRepository postRepository = PostRepository();
  // List<PostModel> postModels = await postRepository.fetchPosts();
  runApp(
      ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: const MyApp(),
      )
  );
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<FirebaseLoginBloc>(
            create: (context) => FirebaseLoginBloc(),
          ),
          BlocProvider<FirebaseSignupBloc>(
            create: (context) => FirebaseSignupBloc(),
          ),
          BlocProvider<FirebaseCrudBloc>(
            create: (context) => FirebaseCrudBloc(),
          ),
        ],
        child: GetMaterialApp(
        theme: Provider.of<ThemeProvider>(context).themeData,
    // darkTheme: darkMode,
    // themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    initialRoute: RoutesName.splashScreen,
    onGenerateRoute: Routes.generateRoutes,
          // checking the branch
      )
    );
  }
}