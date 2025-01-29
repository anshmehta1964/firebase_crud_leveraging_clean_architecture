import 'dart:async';

import 'package:api_handling/firebaseCRUD/components/MyCupertinoButton.dart';
import 'package:api_handling/firebaseCRUD/components/MyTextFormField.dart';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:api_handling/firebaseCRUD/features/crud/presentation/bloc/crud_bloc.dart';
import 'package:api_handling/firebaseCRUD/features/crud/presentation/widgets/crud_cupertinobutton.dart';
import 'package:api_handling/firebaseCRUD/features/crud/presentation/widgets/crud_textformfield.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../services/internet services/internet_services.dart';
import '../../../Auth/presentation/widgets/auth_cupertino_button.dart';
import '../../../Auth/presentation/widgets/auth_dialogbox.dart';
import '../widgets/crud_dialogbox.dart';

final Connectivity _connectivity = Connectivity();
StreamController<bool> streamController = StreamController();

class TempCrudScreen extends StatefulWidget {
  const TempCrudScreen({super.key});
  @override
  State<TempCrudScreen> createState() => _TempCrudScreenState();
}

class _TempCrudScreenState extends State<TempCrudScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isConnected = false;
  late StreamSubscription<bool> subscription;
  bool hasData = false;
  @override
  void initState() {
    subscription = streamController.stream.listen((value) {
      print('Stream listened : $value');
      isConnected = value;
      _connectivity.onConnectivityChanged.listen(_crudConnectivityStatus);
      print('Value of isConnected variable is: $isConnected');
    });
    checkInitialStatus();
    super.initState();
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
                  'Change Theme',
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: MyTitle(title: 'Firebase Crud', size: 20),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                      'Data is not Valid',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                }),
                CrudTextFormField(
                    controller: nameController,
                    hintText: "Name",
                    onTextChanged: (val) {
                      BlocProvider.of<TempCrudBloc>(context).add(
                          TempTextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                CrudTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    onTextChanged: (val) {
                      BlocProvider.of<TempCrudBloc>(context).add(
                          TempTextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                CrudTextFormField(
                    type: TextInputType.number,
                    controller: phoneController,
                    hintText: "Phone",
                    formatter: FilteringTextInputFormatter.digitsOnly,
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
                            print('Storing offline data');
                            BlocProvider.of<TempCrudBloc>(context).add(
                                StoreOfflineDataEvent(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text));
                            hasData = true;
                            print('Value of has data is : $hasData');
                            // hasData = await TempServices.saveUserData(nameController.text, emailController.text, phoneController.text);
                          }
                        },
                        title: 'Create'),
                    CrudCupertinoButton(
                        onPress: () {
                          BlocProvider.of<TempCrudBloc>(context)
                              .add(TempDataFetchEvent());
                        },
                        title: 'Read'),
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
                              } else {}
                            },
                            title: 'Update');
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
                          itemCount: state.nameList.length,
                          itemBuilder: (context, index) {
                            return Slidable(
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
                                                        name: state
                                                            .nameList[index]));
                                                Navigator.pop(context);
                                              },
                                              onBtn2pressed: () {
                                                Navigator.pop(context);
                                              }));
                                    },
                                    backgroundColor: Colors.red,
                                    icon: CupertinoIcons.delete_solid,
                                  )
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  nameController.text = state.nameList[index];
                                  emailController.text = state.emailList[index];
                                  phoneController.text = state.phoneList[index];
                                  BlocProvider.of<TempCrudBloc>(context).add(
                                      TempTextChangedEvent(
                                          name: nameController.text,
                                          email: emailController.text,
                                          phone: phoneController.text));
                                },
                                child: Card(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Text(state.nameList[index]),
                                        Text(state.emailList[index]),
                                        Text(state.phoneList[index]),
                                      ],
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
                    if (state is TempInternetConnectedState && hasData) {
                      // print('Inserted data from InternetConnectedState');
                      // FirebaseServices.offlineDataInserted();
                      print('Internet connected and has data');
                      BlocProvider.of<TempCrudBloc>(context)
                          .add(RetrievingOfflineDataEvent());
                    } else if (state is TempInternetLostState) {
                      print('Internet Lost state listened');
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
      print(
          'Temp Crud Screen : Initial crudScreen connectivity result: $result');
      _crudConnectivityStatus(result);
    } catch (e) {
      print('Temp Crud Screen : Error in crud Screen: $e');
    }
  }

  void _crudConnectivityStatus(
    List<ConnectivityResult> result,
  ) {
    print('Temp Crud Screen : Connectivity Changed');
    if (result.first == ConnectivityResult.none) {
      // firebaseCrudBloc.add(ConnectionLostEvent());
      BlocProvider.of<TempCrudBloc>(context).add(TempConnectionLostEvent());
      print('Temp Crud Screen :  No Connection');
      streamController.add(false);
    } else {
      // firebaseCrudBloc.add(ConnectionGainedEvent());
      BlocProvider.of<TempCrudBloc>(context).add(TempConnectionGainedEvent());
      print('Temp Crud Screen :  Connected result  {$result}');
      streamController.add(true);
    }
  }
}
