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
    print('Local Data Source Impl : Store Offline Data');
    print('LocalDataImpl Values: {$name,$email, $phone}');
    print('saveUserData called & pref values are set : FirebaseServices');
    print('The values are: {$name, $email, $phone}');
    return true;
  }

  @override
  Future<List<String>?> offlineDataRetrieval() async {
    if (prefs == null) {
      print('prefs is null');
    }
    print('Local Data Impl : Offline Data Retrieval()');
    List<String>? userDataList = prefs?.getStringList('userData')!;
    print('Local Data Impl: User data list contains this data = $userDataList');
    return userDataList;

    // AuthRemoteDataSourceImpl(FirebaseAuth.instance, FirebaseFirestore.instance).offlineDataInserted(userDataList);
  }
}
