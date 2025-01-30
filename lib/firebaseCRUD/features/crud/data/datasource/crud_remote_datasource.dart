import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class CrudRemoteDataSource {
  void insertData({
    required String name,
    required String email,
    required String phone,
  });

  Future<Map<String, List<String>>> readData();

  void deleteData(String name);

  void offlineDataInserted(List<String> data);

  void updateData(
      {required String name, required String email, required String phone});
}

class CrudRemoteDataSourceImpl implements CrudRemoteDataSource {
  FirebaseFirestore firebaseFirestore;
  CrudRemoteDataSourceImpl(this.firebaseFirestore);
  @override
  void insertData(
      {required String name, required String email, required String phone}) {
    DocumentReference documentReference =
        firebaseFirestore.collection("anshDatabase").doc(name);
    Map<String, dynamic> data = {"name": name, "email": email, "phone": phone};
    documentReference.set(data);
    // log("Remote Data Source Impl : Insert Data()");
    // log("Inserted Data is : {$name, $email, $phone}");
  }

  @override
  void offlineDataInserted(List<String> userDataList) {
    for (int i = 0; i < userDataList.length; i += 3) {
      DocumentReference documentReference =
          firebaseFirestore.collection("anshDatabase").doc(userDataList[i]);
      Map<String, dynamic> data = {
        "name": userDataList[i],
        "email": userDataList[i + 1],
        "phone": userDataList[i + 2]
      };
      documentReference.set(data);
    }
    // log('Remote Data Source Impl : OfflineDataInserted()');
  }

  @override
  Future<Map<String, List<String>>> readData() async {
    // log('Remote Data Source Impl : readData()');
    CollectionReference colReference =
        firebaseFirestore.collection("anshDatabase");
    QuerySnapshot querySnapshot = await colReference.get();
    List<String> nameList = [];
    List<String> emailList = [];
    List<String> phoneList = [];
    for (var docSnapshot in querySnapshot.docs) {
      nameList.add(docSnapshot.get("name"));
      emailList.add(docSnapshot.get("email"));
      phoneList.add(docSnapshot.get("phone"));
    }
    return {
      "name": nameList,
      "email": emailList,
      "phone": phoneList,
    };
  }

  @override
  void deleteData(String docName) {
    // log('Remote Data impl : DeleteData()');
    CollectionReference df = firebaseFirestore.collection('anshDatabase');
    df.doc(docName).delete();
    // log('Delete Data called : FirebaseServices');
  }

  @override
  void updateData(
      {required String name, required String email, required String phone}) {
    DocumentReference documentReference =
        firebaseFirestore.collection("anshDatabase").doc(name);
    Map<String, dynamic> data = {"name": name, "email": email, "phone": phone};
    documentReference.update(data);
    // log('Remote Data Source Impl : UpdateData()');
  }
}
