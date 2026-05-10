import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final InitSheredPref _initSheredPref = InitSheredPref.instance;

  static ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> toggleTheme(String theme) async {
    switch (theme) {
      case 'light':
        await _initSheredPref.setTheme("light");
        break;

      case 'dark':
        await _initSheredPref.setTheme("dark");
        break;

      default:
        await _initSheredPref.setTheme("system");
    }

    await loadTheme();
    // notifyListeners();
  }

  Future<void> loadTheme() async {
    String? theme = await _initSheredPref.getTheme();
    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;

      case 'dark':
        _themeMode = ThemeMode.dark;
        break;

      case 'system':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
