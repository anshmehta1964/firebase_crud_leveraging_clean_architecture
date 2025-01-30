import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class CrudLocalDataSource {
  List<String> temp = [];
  Future<bool> storeOfflineData(String name, String email, String phone);

  Future<List<String>?> offlineDataRetrieval();
}

class CrudLocalDatasourceImpl implements CrudLocalDataSource {
  SharedPreferences? prefs;
  CrudLocalDatasourceImpl(this.prefs);

  @override
  List<String> temp = [];

  @override
  Future<bool> storeOfflineData(String name, String email, String phone) async {
    if (prefs == null) {
      print('prefs is null');
    }
    temp.add(name);
    temp.add(email);
    temp.add(phone);
    await prefs?.setStringList('userData', temp);
    // log('Local Data Source Impl : Store Offline Data');
    // log('LocalDataImpl Values: {$name,$email, $phone}');
    // log('saveUserData called & pref values are set : FirebaseServices');
    // log('The values are: {$name, $email, $phone}');
    return true;
  }

  @override
  Future<List<String>?> offlineDataRetrieval() async {
    if (prefs == null) {
      // log('prefs is null');
    }
    // log('Local Data Impl : Offline Data Retrieval()');
    List<String>? userDataList = prefs?.getStringList('userData')!;
    // log('Local Data Impl: User data list contains this data = $userDataList');
    return userDataList;

    // AuthRemoteDataSourceImpl(FirebaseAuth.instance, FirebaseFirestore.instance).offlineDataInserted(userDataList);
  }
}
