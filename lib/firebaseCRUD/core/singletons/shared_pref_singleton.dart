import 'package:shared_preferences/shared_preferences.dart';

class SingletonSharedPreference {
  static SingletonSharedPreference? _preference;

  SingletonSharedPreference._();

  static SingletonSharedPreference get instance {
    if (SingletonSharedPreference._preference == null) {
      _preference = SingletonSharedPreference._();
    }
    return _preference!;
  }

  SharedPreferences? prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}
