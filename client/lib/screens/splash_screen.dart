import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Pure visual splash screen.
/// Navigation is handled entirely by main.dart's FutureBuilder on getToken().
class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/logo.png", fit: BoxFit.cover)
            .animate()
            .blur(begin: const Offset(0, 0.1), end: const Offset(0, 0.5))
            .fadeIn(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 600),
            ),
      ),
    );
  }
}
