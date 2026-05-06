import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeAnimationCurve: Curves.easeIn,
        title: 'Expense Tracker',

        themeMode: ThemeMode.system,
        // darkTheme: ThemeData(
        //   brightness: Brightness.dark,
        //   primaryColor: Colors.blue,
        //   scaffoldBackgroundColor: Colors.black,
        //   appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        // ),
        theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(),

          useMaterial3: true,
          colorScheme: .fromSeed(
            seedColor: const Color.fromARGB(255, 40, 156, 131),
          ),
        ),
        home: const Splashscreen(),
      ),
    );
  }
}
