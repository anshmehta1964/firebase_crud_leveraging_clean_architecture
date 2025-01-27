import 'dart:async';

import 'package:api_handling/firebaseCRUD/components/MyCupertinoButton.dart';
import 'package:api_handling/firebaseCRUD/components/MyTextFormField.dart';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/data/datasource/auth_remote_data_source.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/data/repository/crud_repository_impl.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/domain/usecase/domain_usercase.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/presentation/bloc/crud/crud_bloc.dart';
import 'package:api_handling/firebaseCRUD/screens/crud%20screen/bloc/firebase_crud_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../services/firebase services/firebase_services.dart';
import '../../../../services/internet services/internet_services.dart';
import '../widgets/auth_cupertino_button.dart';
import '../widgets/auth_dialogbox.dart';

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
  InternetServices intS = InternetServices();

  @override
  void initState() {
    subscription = InternetServices.streamController.stream.listen((value){
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
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              )
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title:
          MyTitle(title: 'Firebase Crud',size: 20),
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
                        BlocProvider.of<TempCrudBloc>(context).add(TempDataValidAndConnectedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                        return SizedBox();
                      } else if (state is TempFetchingDataState || state is TempCrudInitialState || state is TempInternetConnectedState || state is TempInternetLostState) {
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
                    onTextChanged: (val){
                      BlocProvider.of<TempCrudBloc>(context).add(TempTextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                    }),
                MyTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    onTextChanged: (val){
                      BlocProvider.of<TempCrudBloc>(context).add(TempTextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                    }),
                MyTextFormField(
                    type: TextInputType.number,
                    controller: phoneController,
                    hintText: "Phone",
                    formatter: FilteringTextInputFormatter.digitsOnly,
                    onTextChanged: (val){
                      BlocProvider.of<TempCrudBloc>(context).add(TempTextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                    }),
                // CREATE BUTTON
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthCupertinoButton(
                        onPress: () async {
                          if (isConnected) {
                            BlocProvider.of<TempCrudBloc>(context).add(TempInsertDataEvent(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text));
                          } else {
                            // print('calling saveUserData');'
                            BlocProvider.of<TempCrudBloc>(context).add(StoreOfflineDataEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                            hasData = true;
                            // hasData = await TempServices.saveUserData(nameController.text, emailController.text, phoneController.text);
                          }
                        }, title: 'Create' ),
                    MyCupertinoButton(
                        onPress: (){
                          BlocProvider.of<TempCrudBloc>(context)
                              .add(TempDataFetchEvent());
                        },
                        title: 'Read'),
                    BlocBuilder<TempCrudBloc, TempCrudState>(
                      builder: (context, state) {
                        return MyCupertinoButton(
                            color: state is TempValidTextState
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            onPress: (){ if (state is TempValidTextState) {
                              // updateData();
                              // FirebaseServices.updateData(nameController.text, emailController.text, phoneController.text);
                            } else { }
                            },
                            title: 'Update'
                        );
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
                                              builder: (context) => Authdialogbox(
                                                  title: "Confirm Delete",
                                                  content: "Are you sure to delete the data?",
                                                  btnText1: "Yes",
                                                  btnText2: "No",
                                                  onBtn1pressed: () {
                                                    BlocProvider.of<TempCrudBloc>(context).add(TempDeleteDataEvent(name: state.nameList[index]));
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
                                      BlocProvider.of<TempCrudBloc>(context).add(TempTextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
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
                    } else if (state is TempInternetLostState) {
                      // print('Internet Lost state listened');
                      showDialog(
                          context: context,
                          builder: (context) => Authdialogbox(
                              title: "Lost Connection!",
                              content: "Data will be stored offline without connection",
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
