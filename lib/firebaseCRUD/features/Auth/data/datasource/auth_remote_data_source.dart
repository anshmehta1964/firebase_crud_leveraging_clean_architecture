import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDatasource{
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password
  });
  Future<bool> logInWithEmailPassword({
    required String email,
    required String password
  });

  void insertData({
    required String name,
    required String email,
    required String phone,
  });

  Future<Map<String,List<String>>> readData();

  void deleteData(String name);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource{
  final FirebaseAuth firebaseAuthInstance;
  final FirebaseFirestore firebaseFirestore;
  AuthRemoteDataSourceImpl(this.firebaseAuthInstance, this.firebaseFirestore);

  @override
  Future<bool> logInWithEmailPassword({required String email, required String password}) async {
    try{
      final loginCredentials = await firebaseAuthInstance.signInWithEmailAndPassword(email: email, password: password);
      if(loginCredentials.user != null) {
        print('Remote DataSource : user logged in successfully');
        return true;
      }
    } catch (e) {
      log("Error Occurred in auth_service.dart file loginUserMethod");
    }
    return false;
  }

  @override
  Future<User?> signInWithEmailPassword({required String email, required String password}) async {
      try{
        final createCredentials = await firebaseAuthInstance.createUserWithEmailAndPassword(email: email, password: password);
        if(createCredentials.user != null){
          print('Remote Datasource : User Created Successfully');
        }
        return createCredentials.user;
      } catch (e){
        log("Remote Datasource : Error Occurred in auth_service.dart file createUserMethod");
      }
      return null;
  }

  @override
  void insertData({required String name, required String email,required String phone}) {
    DocumentReference documentReference = firebaseFirestore.collection("anshDatabase").doc(name);
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "phone": phone
    };
    documentReference.set(data);
    print("Remote Data Source Impl : Insert Data()");
    print("Inserted Data is : {$name, $email, $phone}");
  }

  void offlineDataInserted(List<String> userDataList)  {
    for (int i = 0; i < userDataList.length; i += 3) {
      DocumentReference documentReference =  firebaseFirestore.collection("anshDatabase").doc(userDataList[i]);
      Map<String, dynamic> data = {
        "name": userDataList[i],
        "email": userDataList[i + 1],
        "phone": userDataList[i + 2]
      };
      documentReference.set(data);
    }
    print('Remote Data Source Impl : OfflineDataInserted()');
  }

  @override
  Future<Map<String,List<String>>> readData()async{
    print('Remote Data Source Impl : readData()');
    CollectionReference colReference = firebaseFirestore.collection(
        "anshDatabase");
    QuerySnapshot querySnapshot = await colReference.get();
    List<String> nameList = [];
    List<String>emailList = [];
    List<String>phoneList = [];
    for (var docSnapshot in querySnapshot.docs) {
      nameList.add(docSnapshot.get("name"));
      emailList.add(docSnapshot.get("email"));
      phoneList.add(docSnapshot.get("phone"));
    }
    return{
      "name" : nameList,
      "email" : emailList,
      "phone" : phoneList,
    };
  }

  @override
  void deleteData(String docName) {
    print('Remote Data impl : DeleteData()');
    CollectionReference df =
    FirebaseFirestore.instance.collection('anshDatabase');
    df.doc(docName).delete();
    // print('Delete Data called : FirebaseServices');
  }
}