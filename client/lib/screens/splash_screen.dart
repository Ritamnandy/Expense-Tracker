import 'package:expense_tracker/screens/hidden_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    _nextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/images.png", fit: BoxFit.cover)
            .animate()
            .blur(begin: Offset(0, 0.1), end: Offset(0, 0.5))
            .fadeIn(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 600),
            ),
      ),
    );
  }

  Future<void> _nextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Hiddendrawer();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false,
    );
  }
}
