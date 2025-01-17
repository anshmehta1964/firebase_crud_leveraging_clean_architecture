import 'dart:math';

import 'package:api_handling/components/temp_screen.dart';
import 'package:api_handling/components/theme_provider.dart';
import 'package:api_handling/data/models/post_model.dart';
import 'package:api_handling/data/repositories/post_repository.dart';
import 'package:api_handling/firebaseCRUD/crud_screen.dart';
import 'package:api_handling/firebaseCRUD/fb_login_screen.dart';
import 'package:api_handling/firebaseCRUD/firebase_crud.dart';
import 'package:api_handling/firebaseCRUD/networkController/dependency_injection.dart';
import 'package:api_handling/firebaseCRUD/splash_screen.dart';
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
import 'firebase_options.dart';
import 'package:api_handling/components/theme.dart';

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
    return GetMaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      // darkTheme: darkMode,
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
       home: BlocProvider(
         create: (context) => PostCubit(),
        child: SplashScreen(),
       ),
    );
  }
}