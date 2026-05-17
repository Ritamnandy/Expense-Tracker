import 'package:expense_tracker/db/db_helper.dart';
import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:expense_tracker/provider/add_expense_chart.dart';

import 'package:expense_tracker/provider/theme_provider.dart';
import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:expense_tracker/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitSheredPref.instance.getSharedPref();
  await DBHelper.instance.database;
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseAndIncomeChart()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeAnimationCurve: Curves.easeIn,
        title: 'Expense Tracker',

        themeMode: themeProvider.themeMode,
        darkTheme: AppTheme.darkTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(AppTheme.darkTheme.textTheme),
        ),
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(
            AppTheme.lightTheme.textTheme,
          ),
        ),
        home: SafeArea(top: false, child: const Splashscreen()),
      ),
    );
  }
}
