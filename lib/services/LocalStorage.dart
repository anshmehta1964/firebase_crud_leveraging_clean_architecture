import 'package:shared_preferences/shared_preferences.dart';
class LocalStorage{
    late String name;
    late String email;
    late String phone;
    static Future<void> saveUserData(String name,String email,String phone)async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setString('phone', phone);
    }

    static Future<void>UploadUserData() async {

    }
}