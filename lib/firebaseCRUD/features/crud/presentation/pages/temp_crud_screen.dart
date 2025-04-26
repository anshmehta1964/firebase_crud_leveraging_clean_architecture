import 'dart:async';
import 'dart:developer';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:api_handling/firebaseCRUD/core/localization/languages.dart';
import 'package:api_handling/firebaseCRUD/features/crud/presentation/bloc/crud_bloc.dart';
import 'package:api_handling/firebaseCRUD/features/crud/presentation/widgets/crud_cupertinobutton.dart';
import 'package:api_handling/firebaseCRUD/features/crud/presentation/widgets/crud_textformfield.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../Auth/presentation/widgets/auth_dialogbox.dart';
import '../widgets/crud_dialogbox.dart';

final Connectivity _connectivity = Connectivity();
StreamController<bool> streamController = StreamController.broadcast();

class TempCrudScreen extends StatefulWidget {
  const TempCrudScreen({super.key});
  @override
  State<TempCrudScreen> createState() => _TempCrudScreenState();
}

class _TempCrudScreenState extends State<TempCrudScreen> {
  FocusNode nameTextField = FocusNode();
  FocusNode emailTextField = FocusNode();
  FocusNode phoneTextField = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isConnected = false;
  late StreamSubscription<bool> subscription;
  bool hasData = false;
  bool checkFirstTime = true;
  @override
  void initState() {
    subscription = streamController.stream.listen((value) {
      log('Stream listened: $value');
      setState(() {
        isConnected = value;
      });
      _connectivity.onConnectivityChanged.listen(_crudConnectivityStatus);
      log('Value of isConnected variable is: $isConnected');
    });
    checkInitialStatus();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    subscription.cancel();
    super.dispose();
  }

  void unFocusAllNodes() {
    nameTextField.unfocus();
    emailTextField.unfocus();
    phoneTextField.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  AppLocale.themebutton.getString(context),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              )
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: MyTitle(title: AppLocale.appbar.getString(context), size: 20),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                // Color(0xfffdfbfb),
                // Colors.white,
                // Colors.grey.shade300,
                // Colors.grey.shade500,
                // Colors.grey.shade900
                Theme.of(context).colorScheme.inversePrimary,
                Theme.of(context).colorScheme.inverseSurface
              ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(5.80))),
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              spacing: 10,
              children: <Widget>[
                BlocBuilder<TempCrudBloc, TempCrudState>(
                    builder: (context, state) {
                  if (state is TempDataValidState && isConnected) {
                    BlocProvider.of<TempCrudBloc>(context).add(
                        TempDataValidAndConnectedEvent(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text));
                    return SizedBox();
                  } else if (state is TempFetchingDataState ||
                      state is TempCrudInitialState ||
                      state is TempInternetConnectedState ||
                      state is TempInternetLostState ||
                      state is TempValidTextState) {
                    return SizedBox();
                  } else {
                    return Text(
                      AppLocale.dataerror.getString(context),
                      style: TextStyle(color: Colors.red),
                    );
                  }
                }),
                CrudTextFormField(
                    focusNode: nameTextField,
                    controller: nameController,
                    hintText: AppLocale.name.getString(context),
                    onTextChanged: (val) {
                      BlocProvider.of<TempCrudBloc>(context).add(
                          TempTextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                CrudTextFormField(
                    type: TextInputType.emailAddress,
                    focusNode: emailTextField,
                    controller: emailController,
                    hintText: AppLocale.email.getString(context),
                    onTextChanged: (val) {
                      BlocProvider.of<TempCrudBloc>(context).add(
                          TempTextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                CrudTextFormField(
                    focusNode: phoneTextField,
                    type: TextInputType.number,
                    controller: phoneController,
                    hintText: AppLocale.phone.getString(context),
                    formatter: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onTextChanged: (val) {
                      BlocProvider.of<TempCrudBloc>(context).add(
                          TempTextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                // CREATE BUTTON
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CrudCupertinoButton(
                        onPress: () async {
                          if (isConnected) {
                            BlocProvider.of<TempCrudBloc>(context).add(
                                TempInsertDataEvent(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text));
                          } else {
                            // print('Storing offline data');
                            BlocProvider.of<TempCrudBloc>(context).add(
                                StoreOfflineDataEvent(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text));
                            hasData = true;
                            // print('Value of has data is : $hasData');
                            // hasData = await TempServices.saveUserData(nameController.text, emailController.text, phoneController.text);
                          }
                        },
                        title: AppLocale.create.getString(context)),
                    CrudCupertinoButton(
                        onPress: () {
                          nameController.clear();
                          emailController.clear();
                          phoneController.clear();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              });
                          // Future.delayed(Duration(milliseconds: 400),(){
                          //     Navigator.pop(context);
                          // });
                          Timer(const Duration(milliseconds: 1500),
                              () => Navigator.pop(context));
                          BlocProvider.of<TempCrudBloc>(context)
                              .add(TempDataFetchEvent());
                          unFocusAllNodes();
                        },
                        title: AppLocale.read.getString(context)),
                    BlocBuilder<TempCrudBloc, TempCrudState>(
                      builder: (context, state) {
                        return CrudCupertinoButton(
                            color: state is TempValidTextState
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            onPress: () {
                              if (state is TempValidTextState) {
                                BlocProvider.of<TempCrudBloc>(context).add(
                                    UpdateDataEvent(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text));
                                // updateData();
                                // FirebaseServices.updateData(nameController.text, emailController.text, phoneController.text);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    });
                                Timer(Duration(milliseconds: 600), () {
                                  Navigator.pop(context);
                                });
                                Future.delayed(Duration(seconds: 1), () {
                                  nameController.clear();
                                  emailController.clear();
                                  phoneController.clear();
                                });
                              } else {}
                            },
                            title: AppLocale.update.getString(context));
                      },
                    ),
                  ],
                ),
                BlocBuilder<TempCrudBloc, TempCrudState>(
                    builder: (context, state) {
                  if (state is TempFetchingDataState) {
                    // print("Name List : ${state.nameList}");
                    // print("Email List : ${state.emailList}");
                    // print("Phone List : ${state.phoneList}");
                    return Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 0),
                          itemCount: state.nameList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => CrudDialogbox(
                                                title: "Confirm Delete",
                                                content:
                                                    "Are you sure to delete the data?",
                                                btnText1: "Yes",
                                                btnText2: "No",
                                                onBtn1pressed: () {
                                                  BlocProvider.of<TempCrudBloc>(
                                                          context)
                                                      .add(TempDeleteDataEvent(
                                                          name: state.nameList[
                                                              index]));
                                                  Navigator.pop(context);
                                                  // showDialog(
                                                  //     context: context,
                                                  //     builder: (context){
                                                  //       return Center(child: CircularProgressIndicator());
                                                  //     });
                                                  // Future.delayed(Duration(milliseconds: 600),(){
                                                  //   Navigator.pop(context);
                                                  // });
                                                },
                                                onBtn2pressed: () {
                                                  Navigator.pop(context);
                                                }));
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor: Colors.red.shade500,
                                      icon: Icons.delete,
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    nameController.text = state.nameList[index];
                                    emailController.text =
                                        state.emailList[index];
                                    phoneController.text =
                                        state.phoneList[index];
                                    BlocProvider.of<TempCrudBloc>(context).add(
                                        TempTextChangedEvent(
                                            name: nameController.text,
                                            email: emailController.text,
                                            phone: phoneController.text));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                            Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                          ],
                                          stops: [
                                            0.42,
                                            1.2,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          transform: GradientRotation(0.50)),
                                      borderRadius: BorderRadius.circular(13),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    // color:
                                    //     Theme.of(context).colorScheme.secondary,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        spacing: 10,
                                        children: [
                                          Text(state.nameList[index]),
                                          Text(state.emailList[index]),
                                          Text(state.phoneList[index]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
                BlocListener<TempCrudBloc, TempCrudState>(
                  listener: (context, state) {
                    if (state is DataUpdatedState) {
                      BlocProvider.of<TempCrudBloc>(context)
                          .add(TempDataFetchEvent());
                    }
                    if (state is TempInternetConnectedState && hasData) {
                      // print('Inserted data from InternetConnectedState');
                      // FirebaseServices.offlineDataInserted();
                      // print('Internet connected and has data');
                      BlocProvider.of<TempCrudBloc>(context)
                          .add(RetrievingOfflineDataEvent());
                    } else if (state is TempInternetLostState) {
                      // print('Internet Lost state listened');
                      showDialog(
                          context: context,
                          builder: (context) => Authdialogbox(
                              title: "Lost Connection!",
                              content:
                                  "Data will be stored offline without connection",
                              btnText1: "Yes",
                              btnText2: "No",
                              onBtn1pressed: () {
                                Navigator.of(context).pop();
                              },
                              onBtn2pressed: () {
                                Navigator.of(context).pop();
                              }));
                    }
                  },
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> checkInitialStatus() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      // print('Temp Crud Screen : Initial crudScreen connectivity result: $result');
      _crudConnectivityStatus(result);
    } catch (e) {
      // print('Temp Crud Screen : Error in crud Screen: $e');
    }
  }

  void _crudConnectivityStatus(
    List<ConnectivityResult> result,
  ) {
    // print('Temp Crud Screen : Connectivity Changed');
    if (result.first == ConnectivityResult.none) {
      // firebaseCrudBloc.add(ConnectionLostEvent());
      if (mounted) {
        BlocProvider.of<TempCrudBloc>(context).add(TempConnectionLostEvent());
      }
      // print('Temp Crud Screen :  No Connection');
      streamController.add(false);
    } else {
      if (mounted) {
        // firebaseCrudBloc.add(ConnectionGainedEvent());
        BlocProvider.of<TempCrudBloc>(context).add(TempConnectionGainedEvent());
      }
      // print('Temp Crud Screen :  Connected result  {$result}');
      streamController.add(true);
    }
  }
}
