import 'package:api_handling/firebaseCRUD/features/Auth/data/datasource/auth_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource{
  List<String> temp = [];
  Future<bool> storeOfflineData(
      String name,
      String email,
      String phone);

  Future<void> offlineDataRetrieval();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource{
  SharedPreferences prefs;
  AuthLocalDataSourceImpl(this.prefs);

  @override
  List<String> temp = [];

  @override
  Future<bool> storeOfflineData(String name, String email, String phone) async {
    temp.add(name);
    temp.add(email);
    temp.add(phone);
    await prefs.setStringList('userData', temp);
    print('Local Data Source Impl : Store Offline Data');
    print('LocalDataImpl Values: {$name,$email, $phone}');
    // print('saveUserData called & pref values are set : FirebaseServices');
    // print('The values are: {$name, $email, $phone}');
    return true;
  }

  @override
  Future<void> offlineDataRetrieval() async {
    List<String> userDataList = prefs.getStringList('userData')!;
    AuthRemoteDataSourceImpl(FirebaseAuth.instance, FirebaseFirestore.instance).offlineDataInserted(userDataList);
  }

}