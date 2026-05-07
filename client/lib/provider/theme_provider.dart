import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void toggleTheme(bool isdark) {
    if (isdark) {
      _themeMode == ThemeMode.dark;
    } else {
      _themeMode == ThemeMode.light;
    }
  }
}
