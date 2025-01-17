import 'package:api_handling/components/MyDialogBox.dart';
import 'package:api_handling/components/theme_provider.dart';
import 'package:api_handling/firebaseCRUD/firebase%20crud%20bloc/firebase_crud_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

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
  bool isConnected = false;
  bool hasData = false;
  bool updateButtonEnabled = false;

  // List<List<String>> userData = [];

  // String name = "";
  // String email = "";
  // String phone = "";
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
          title: Text(
            'Firebase Crud',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
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
                    insertData();
                    return Container();
                  } else if (state is FetchingDataState) {
                    return Container();
                  } else {
                    return Text(
                      'Data is not Valid',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                }),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      )
                  ),
                  onChanged: (val){
                    BlocProvider.of<FirebaseCrudBloc>(context).add(TextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      )
                  ),
                  onChanged: (val){
                    BlocProvider.of<FirebaseCrudBloc>(context).add(TextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: "Phone",
                    fillColor: Theme.of(context).colorScheme.tertiary,
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                  controller: phoneController,
                  onChanged: (val){
                    BlocProvider.of<FirebaseCrudBloc>(context).add(TextChangedEvent(name: nameController.text, email: emailController.text, phone: phoneController.text));
                  },
                ),
                // CREATE BUTTON
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        if (isConnected) {
                          BlocProvider.of<FirebaseCrudBloc>(context)
                              .add(InsertDataEvent(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          ));
                        } else {
                          saveUserData(); // -- For Offline Connectivity
                        }
                      },
                      child: Text('Create',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    CupertinoButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        BlocProvider.of<FirebaseCrudBloc>(context)
                            .add(DataFetchEvent());
                      },
                      child: Text('Read',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    BlocBuilder<FirebaseCrudBloc, FirebaseCrudState>(
                      builder: (context, state) {
                        return CupertinoButton(
                          color: state is ValidTextState
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          onPressed: () {
                            if (state is ValidTextState) {
                              updateData();
                            } else { }
                          },
                          child: Text('Update',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold)),
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
                                              content:
                                                  "Are you sure to delete the data?",
                                              btnText1: "Yes",
                                              btnText2: "No",
                                              onBtn1pressed: () {
                                                deleteData(
                                                    state.nameList[index]);
                                                print(
                                                    'Data deleted fired from alert');
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
                    if (state is InternetConnectedState) {
                      print('Inserted data from InternetConnectedState');
                      offlineDataInserted();
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
                  child: Container(),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('name', nameController.text);
    // await prefs.setString('email', emailController.text);
    // await prefs.setString('phone', phoneController.text);
    // Storing multiple user data
    temp.add(nameController.text);
    temp.add(emailController.text);
    temp.add(phoneController.text);
    // userData.add(temp);
    await prefs.setStringList('userData', temp);
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    hasData = true;
    print('uploadData called & pref values are set');
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

  insertData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("anshDatabase")
        .doc(nameController.text);
    Map<String, dynamic> data = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text
    };
    documentReference.set(data);
    print("data inserted successfully");
  }

  Future<void> offlineDataInserted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userDataList = prefs.getStringList('userData')!;
    for (int i = 0; i < userDataList.length; i += 3) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("anshDatabase")
          .doc(userDataList[i]);
      Map<String, dynamic> data = {
        "name": userDataList[i],
        "email": userDataList[i + 1],
        "phone": userDataList[i + 2]
      };
      documentReference.set(data);
    }
    // name = prefs.getString('name')!;
    // email = prefs.getString('email')!;
    // phone = prefs.getString('phone')!;
    // DocumentReference documentReference = FirebaseFirestore.instance
    //     .collection("anshDatabase")
    //     .doc(name);
    // Map<String, dynamic> data = {
    //   "name": name,
    //   "email": email,
    //   "phone": phone
    // };
    // documentReference.set(data);

    print('offlineDataInserted is called');
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
  // void a(int index){
  // print('Yes Button clicked with index $index');
  // }

  // void b() {
  //   print('No Button clicked');
  // }
}
