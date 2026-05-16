import 'package:shared_preferences/shared_preferences.dart';

class InitSheredPref {
  static final InitSheredPref _instance = InitSheredPref._init();
  static InitSheredPref get instance => _instance;
  SharedPreferences? _prefs;
  InitSheredPref._init();
  Future<void> get getSharedPref async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// set and get theme
  Future<void> setTheme(String theme) async {
    await _prefs?.remove("theme");
    await _prefs?.setString("theme", theme);
  }

  Future<String?> getTheme() async {
    String? value = _prefs?.getString("theme");
    return value;
  }

  /// set and get auth token

  Future<void> setToken(String token) async {
    await _prefs?.remove("token");
    await _prefs?.setString("token", token);
  }

  Future<String?> getToken() async {
    await Future.delayed(Duration(seconds: 3));
    String? value = _prefs?.getString("token");
    return value;
  }

  Future<void> logOut() async {
    await _prefs?.remove("token");
  }
}
