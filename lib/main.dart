import 'dart:ui';

import 'package:api_handling/firebaseCRUD/core/singletons/shared_pref_singleton.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/data/datasource/auth_remote_data_source.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/data/repository/auth_repository_impl.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/domain/usecase/auth_usecase.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:api_handling/firebaseCRUD/features/crud/data/datasource/crud_local_datasource.dart';
import 'package:api_handling/firebaseCRUD/features/crud/data/datasource/crud_remote_datasource.dart';
import 'package:api_handling/firebaseCRUD/networkController/dependency_injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebaseCRUD/core/localization/languages.dart';
import 'firebaseCRUD/core/routes/routes.dart';
import 'firebaseCRUD/core/routes/routes_name.dart';
import 'firebaseCRUD/core/theme/theme_provider.dart';
import 'firebaseCRUD/features/crud/data/repository/crud_repository_impl.dart';
import 'firebaseCRUD/features/crud/domain/usecase/crud_usecase.dart';
import 'firebaseCRUD/features/crud/presentation/bloc/crud_bloc.dart';
import 'firebaseCRUD/features/Auth/presentation/bloc/login/login_bloc.dart';
import 'firebase_options.dart';

late SharedPreferences prefs;
late final FlutterLocalization localization;
late Locale deviceLocale;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SingletonSharedPreference.instance.init();
  await FlutterLocalization.instance.ensureInitialized();
  deviceLocale = PlatformDispatcher.instance.locale;
  print("Device Language: ${deviceLocale.languageCode}");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final internetServices = await InternetServices.createInstance();
  // await NotificationService.instance.intialize();
  // PostRepository postRepository = PostRepository();
  // List<PostModel> postModels = await postRepository.fetchPosts();
  prefs = await SharedPreferences.getInstance();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    localization = FlutterLocalization.instance;
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('hi', AppLocale.HI),
        const MapLocale('gr', AppLocale.GR),
      ],
      // initLanguageCode: deviceLocale.languageCode,
      initLanguageCode: deviceLocale.languageCode,
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {
      print('set state called');
    });
  }
  // SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TempLogInBloc>(
            create: (context) => TempLogInBloc(
                userLogIn: UserLogIn(AuthRepositoryImpl(
                    AuthRemoteDataSourceImpl(
                        FirebaseAuth.instance, FirebaseFirestore.instance)))),
          ),
          // BlocProvider<FirebaseSignupBloc>(
          //   create: (context) => FirebaseSignupBloc(),
          // ),
          BlocProvider<TempCrudBloc>(
            create: (context) => TempCrudBloc(
              insertusecase: InsertDataUseCase(CrudRepositoryImpl(
                  CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
                  CrudLocalDatasourceImpl(prefs))),
              Readusecase: ReadDataUseCase(CrudRepositoryImpl(
                  CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
                  CrudLocalDatasourceImpl(prefs))),
              deleteusecase: DeleteDataUseCase(CrudRepositoryImpl(
                  CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
                  CrudLocalDatasourceImpl(prefs))),
              offlineusecase: OfflineDataUseCase(CrudRepositoryImpl(
                  CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
                  CrudLocalDatasourceImpl(prefs))),
              dataRetDUC: OfflineDataRetrievalUseCase(CrudRepositoryImpl(
                  CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
                  CrudLocalDatasourceImpl(prefs))),
              insertoffDUC: InsertingOfflineData(CrudRepositoryImpl(
                CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
                CrudLocalDatasourceImpl(prefs))),
              updateDataDUC: UpdateDataUseCase(CrudRepositoryImpl(
                CrudRemoteDataSourceImpl(FirebaseFirestore.instance),
                CrudLocalDatasourceImpl(prefs))),
            ),
          ),
          BlocProvider<TempSignUpBloc>(
            create: (context) => TempSignUpBloc(
                userSignUp: UserSignUp(AuthRepositoryImpl(
                    AuthRemoteDataSourceImpl(
                        FirebaseAuth.instance, FirebaseFirestore.instance)))),
          ),
        ],
        child: GetMaterialApp(
          supportedLocales: localization.supportedLocales,
          localizationsDelegates: localization.localizationsDelegates,
          theme: Provider.of<ThemeProvider>(context).themeData,
          // darkTheme: darkMode,
          // themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesName.tempSplashScreen,
          onGenerateRoute: Routes.generateRoutes,
        ));
  }
}
