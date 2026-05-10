import 'package:shared_preferences/shared_preferences.dart';

class InitSheredPref {
  static final InitSheredPref _instance = InitSheredPref._init();
  static InitSheredPref get instance => _instance;
  SharedPreferences? _prefs;
  InitSheredPref._init();
  Future<void> getSharedPref() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setTheme(String theme) async {
    await _prefs?.clear();
    await _prefs?.setString("theme", theme);
  }

  Future<String?> getTheme() async {
    String? value = _prefs?.getString("theme");
    return value;
  }
}
