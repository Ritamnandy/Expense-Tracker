import 'package:shared_preferences/shared_preferences.dart';

class InitSheredPref {
  static final InitSheredPref _instance = InitSheredPref._init();
  static InitSheredPref get instance => _instance;
  SharedPreferences? _prefs;
  InitSheredPref._init();
<<<<<<< Updated upstream
  Future<void> getSharedPref() async {
=======
<<<<<<< HEAD
  Future<void> get getSharedPref async {
>>>>>>> Stashed changes
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setTheme(String theme) async {
<<<<<<< Updated upstream
    await _prefs?.clear();
=======
    await _prefs?.remove("theme");
=======
  Future<void> getSharedPref() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setTheme(String theme) async {
    await _prefs?.clear();
>>>>>>> upstream/main
>>>>>>> Stashed changes
    await _prefs?.setString("theme", theme);
  }

  Future<String?> getTheme() async {
    String? value = _prefs?.getString("theme");
    return value;
  }
<<<<<<< Updated upstream
=======
<<<<<<< HEAD

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
=======
>>>>>>> upstream/main
>>>>>>> Stashed changes
}
