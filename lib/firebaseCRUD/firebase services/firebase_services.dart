import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices{
  static FirebaseServices instance = FirebaseServices();

  static List<String> temp = [];

  static Future<bool> saveUserData(String name, String email, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance() ;
    // Storing multiple user data
    temp.add(name);
    temp.add(email);
    temp.add(phone);

    await prefs.setStringList('userData', temp);
    print('saveUserData called & pref values are set : FirebaseServices');
    print('The values are: {$name, $email, $phone}');
    return true;
  }

  static void insertData(String name,String email, String phone) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection("anshDatabase").doc(name);
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "phone": phone
    };
    documentReference.set(data);
    print("Data inserted successfully: FirebaseServices");
    print("Inserted Data is : {$name, $email, $phone}");
  }
  static Future<void> offlineDataInserted() async {
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
    print('offlineDataInserted is called : FirebaseServices');
  }
  static void updateData(String name, String email, String phone) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("anshDatabase")
        .doc(name);
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "phone": phone
    };
    documentReference.update(data);
    print('UpdateData is called : FirebaseServices');
  }
  static void deleteData(String docName) {
    CollectionReference df =
    FirebaseFirestore.instance.collection('anshDatabase');
    df.doc(docName).delete();
    print('Delete Data called : FirebaseServices');
  }
}