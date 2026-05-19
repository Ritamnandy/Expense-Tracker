import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final InitSheredPref _initSheredPref = InitSheredPref.instance;

  // Instance field (not static) — each provider instance has its own state.
  ThemeMode _themeMode = ThemeMode.system;
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
    await loadTheme(); // loadTheme calls notifyListeners()
  }

  Future<void> loadTheme() async {
    final theme = await _initSheredPref.getTheme();
    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
