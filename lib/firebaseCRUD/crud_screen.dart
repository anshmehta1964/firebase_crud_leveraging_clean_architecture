import 'package:api_handling/firebaseCRUD/components/MyCupertinoButton.dart';
import 'package:api_handling/firebaseCRUD/components/MyTextFormField.dart';
import 'package:api_handling/firebaseCRUD/components/MyTitles.dart';
import 'package:api_handling/firebaseCRUD/firebase%20crud%20bloc/firebase_crud_bloc.dart';
import 'package:api_handling/firebaseCRUD/firebase%20services/firebase_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/MyDialogBox.dart';
import 'components/theme_provider.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  // final CollectionReference _collectionReference = FirebaseFirestore.instance.collection("anshDatabase");

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final Connectivity _connectivity = Connectivity();
  bool isConnected  = false;
  bool hasData = false;
  bool updateButtonEnabled = false;

  List<String> temp = [];

  @override
  void initState() {
    //Checking initial connectivity
    checkInitialStatus();
    _connectivity.onConnectivityChanged.listen(_crudConnectivityStatus);
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
          title:
          MyTitle(title: 'Firebase Crud',size: 20),
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
                    print('Insert data called from blocBuilder');
                    FirebaseServices.insertData(nameController.text, emailController.text, phoneController.text);
                    return Container();
                  } else if (state is FetchingDataState || state is FirebaseCrudInitialState || state is InternetConnectedState) {
                    return Container();
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
                      BlocProvider.of<FirebaseCrudBloc>(context).add(TextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                    }),
                MyTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    onTextChanged: (val){
                      BlocProvider.of<FirebaseCrudBloc>(context).add(TextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                    }),
                MyTextFormField(
                    type: TextInputType.number,
                    controller: phoneController,
                    hintText: "Phone",
                    formatter: FilteringTextInputFormatter.digitsOnly,
                    onTextChanged: (val){
                      BlocProvider.of<FirebaseCrudBloc>(context).add(TextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                    }),
                // CREATE BUTTON
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyCupertinoButton(
                        onPress: () async {
                      if (isConnected) {
                        BlocProvider.of<FirebaseCrudBloc>(context).add(InsertDataEvent(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text));
                      } else {
                        print('calling saveUserData');
                        hasData = await FirebaseServices.saveUserData(nameController.text, emailController.text, phoneController.text);
                        if(hasData){
                          print('hasData is true');// -- For Offline Connectivity
                          } else {
                          print('hasData is false');
                        }
                        }
                      }, title: 'Create' ),
                    MyCupertinoButton(
                        onPress: (){
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
                              onPress: (){ if (state is ValidTextState) {
                          updateData();
                              } else { }
                            },
                              title: 'Update'
                          );
                      },
                    ),
                  ],
                ),
                BlocBuilder<FirebaseCrudBloc, FirebaseCrudState>(
                    builder: (context, state) {
                  if (state is FetchingDataState) {
                    print("Name List : ${state.nameList}");
                    print("Email List : ${state.emailList}");
                    print("Phone List : ${state.phoneList}");
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
                                              content: "Are you sure to delete the data?",
                                              btnText1: "Yes",
                                              btnText2: "No",
                                              onBtn1pressed: () {
                                                deleteData(state.nameList[index]);
                                                print('Data deleted fired from alert');
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
                                  BlocProvider.of<FirebaseCrudBloc>(context).add(TextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
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
                    return Container();
                  }
                }),
                BlocListener<FirebaseCrudBloc, FirebaseCrudState>(
                  listener: (context, state) {
                    if(nameController.text.toString() == "" || emailController.text.toString() == "" || phoneController.text.toString() == ""){
                      // BlocProvider.of<FirebaseCrudBloc>(context).add()
                    }
                    if (state is InternetConnectedState && hasData) {
                      print('Inserted data from InternetConnectedState');
                      FirebaseServices.offlineDataInserted();
                      // offlineDataInserted();
                    } else if (state is InternetLostState) {
                      // print('Internet Lost state listened');
                      showDialog(
                          context: context,
                          builder: (context) => Mydialogbox(
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
                  child: Container(),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> checkInitialStatus() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      print('Initial crudScreen connectivity result: $result');
      _crudConnectivityStatus(result);
    } catch (e) {
      print('Error in crud Screen: $e');
    }
  }

  void _crudConnectivityStatus(List<ConnectivityResult> result) {
    print('crudScreen: Connectivity Changed');
    if (result.first == ConnectivityResult.none) {
      BlocProvider.of<FirebaseCrudBloc>(context).add(ConnectionLostEvent());
      print('crudScreen: No Connection');
      isConnected = false;
    } else {
      BlocProvider.of<FirebaseCrudBloc>(context).add(ConnectionGainedEvent());
      isConnected = true;
      print('crudScreen Connected result : {$result}');
    }
  }

  updateData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("anshDatabase")
        .doc(nameController.text);
    Map<String, dynamic> data = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text
    };
    documentReference.update(data);
    nameController.clear();
    emailController.clear();
    phoneController.clear();
  }

  bool validateData({
    required String name,
    required String email,
    required String phone,
  }) {
    if (name == "" ||
        email == "" ||
        phone == "" ||
        !(EmailValidator.validate(email)) ||
        phone.length < 10) {
      return false;
    } else {
      return true;
    }
  }

  deleteData(String docName) {
    CollectionReference df =
        FirebaseFirestore.instance.collection('anshDatabase');
    df.doc(docName).delete();
  }

}
