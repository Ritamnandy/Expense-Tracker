import 'package:flutter/material.dart';

class AppTheme {
  // LIGHT COLORS

  static const Color lightPrimary = Color(0xFF00D09E);

  static const Color lightExpense = Color(0xFFFF6B35);

  static const Color lightBackground = Color(0xFFF5F6FA);

  static const Color lightCard = Colors.white;

  static const Color lightText = Color(0xFF1B1D33);

  // DARK COLORS

  static const Color darkPrimary = Color(0xFF00D09E);

  static const Color darkExpense = Color(0xFFFF7A59);

  static const Color darkBackground = Color(0xFF121212);

  static const Color darkCard = Color(0xFF1E1E1E);

  static const Color darkText = Colors.white;

  // LIGHT THEME

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor: lightBackground,

    primaryColor: lightPrimary,

    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightExpense,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      centerTitle: true,
      foregroundColor: lightText,
      titleTextStyle: TextStyle(
        color: lightText,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: darkText),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),

      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),

      bodyLarge: TextStyle(fontSize: 18, color: lightText),

      bodyMedium: TextStyle(fontSize: 16, color: Colors.grey),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,

        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: lightPrimary, width: 2),
      ),

      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );

  // DARK THEME

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: darkBackground,

    primaryColor: darkPrimary,

    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkExpense,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      foregroundColor: darkText,
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: darkText),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),

      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),

      bodyLarge: TextStyle(fontSize: 18, color: darkText),

      bodyMedium: TextStyle(fontSize: 16, color: Colors.grey),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,

        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),

      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}
