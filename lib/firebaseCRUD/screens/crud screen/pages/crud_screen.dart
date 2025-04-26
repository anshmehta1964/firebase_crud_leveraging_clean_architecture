import 'dart:async';

import 'package:api_handling/firebaseCRUD/components/MyCupertinoButton.dart';
import 'package:api_handling/firebaseCRUD/components/MyTextFormField.dart';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:api_handling/firebaseCRUD/screens/crud%20screen/bloc/firebase_crud_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../components/MyDialogBox.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../services/firebase services/firebase_services.dart';
import '../../../services/internet services/internet_services.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});
  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isConnected = false;
  late StreamSubscription<bool> subscription;
  bool hasData = false;
  InternetServices intS = InternetServices();

  @override
  void initState() {
    subscription = InternetServices.streamController.stream.listen((value) {
      print('Stream listened : $value');
      isConnected = value;
      print('Value of isConnected variable is: $isConnected');
    });
    //Checking initial connectivity
    intS.checkInitialStatus();
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
                BlocBuilder<FirebaseCrudBloc, FirebaseCrudState>(
                    builder: (context, state) {
                  if (state is DataValidState && isConnected) {
                    // print('Insert data called from blocBuilder');
                    FirebaseServices.insertData(nameController.text,
                        emailController.text, phoneController.text);
                    return SizedBox();
                  } else if (state is FetchingDataState ||
                      state is FirebaseCrudInitialState ||
                      state is InternetConnectedState ||
                      state is InternetLostState) {
                    return SizedBox();
                  } else {
                    return Text(
                      'Data is not Valid',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                }),
                MyTextFormField(
                    controller: nameController,
                    hintText: "Name",
                    onTextChanged: (val) {
                      BlocProvider.of<FirebaseCrudBloc>(context).add(
                          TextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                MyTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    onTextChanged: (val) {
                      BlocProvider.of<FirebaseCrudBloc>(context).add(
                          TextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                MyTextFormField(
                    type: TextInputType.number,
                    controller: phoneController,
                    hintText: "Phone",
                    formatter: FilteringTextInputFormatter.digitsOnly,
                    onTextChanged: (val) {
                      BlocProvider.of<FirebaseCrudBloc>(context).add(
                          TextChangedEvent(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text));
                    }),
                // CREATE BUTTON
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyCupertinoButton(
                        onPress: () async {
                          if (isConnected) {
                            BlocProvider.of<FirebaseCrudBloc>(context).add(
                                InsertDataEvent(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text));
                          } else {
                            // print('calling saveUserData');
                            hasData = await FirebaseServices.saveUserData(
                                nameController.text,
                                emailController.text,
                                phoneController.text);
                          }
                        },
                        title: 'Create'),
                    MyCupertinoButton(
                        onPress: () {
                          BlocProvider.of<FirebaseCrudBloc>(context)
                              .add(DataFetchEvent());
                        },
                        title: 'Read'),
                    BlocBuilder<FirebaseCrudBloc, FirebaseCrudState>(
                      builder: (context, state) {
                        return MyCupertinoButton(
                            color: state is ValidTextState
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            onPress: () {
                              if (state is ValidTextState) {
                                // updateData();
                                FirebaseServices.updateData(nameController.text,
                                    emailController.text, phoneController.text);
                              } else {}
                            },
                            title: 'Update');
                      },
                    ),
                  ],
                ),
                BlocBuilder<FirebaseCrudBloc, FirebaseCrudState>(
                    builder: (context, state) {
                  if (state is FetchingDataState) {
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
                                          builder: (context) => Mydialogbox(
                                              title: "Confirm Delete",
                                              content:
                                                  "Are you sure to delete the data?",
                                              btnText1: "Yes",
                                              btnText2: "No",
                                              onBtn1pressed: () {
                                                FirebaseServices.deleteData(
                                                    state.nameList[index]);
                                                // print('Data deleted fired from alert');
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
                                  BlocProvider.of<FirebaseCrudBloc>(context)
                                      .add(TextChangedEvent(
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
                BlocListener<FirebaseCrudBloc, FirebaseCrudState>(
                  listener: (context, state) {
                    if (state is InternetConnectedState && hasData) {
                      // print('Inserted data from InternetConnectedState');
                      FirebaseServices.offlineDataInserted();
                    } else if (state is InternetLostState) {
                      // print('Internet Lost state listened');
                      showDialog(
                          context: context,
                          builder: (context) => Mydialogbox(
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
}
