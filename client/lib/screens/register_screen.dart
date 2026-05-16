<<<<<<< Updated upstream
=======
<<<<<<< HEAD
import 'package:expense_tracker/apis/auth_services.dart';
import 'package:expense_tracker/core/validators/validator.dart';
=======
>>>>>>> upstream/main
>>>>>>> Stashed changes
import 'package:expense_tracker/screens/hidden_drawer.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final formKey = GlobalKey<FormState>();
  bool isVisible = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
              Column(
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(right: 145),
                    child: Text(
                      'Create Account',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                          ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(right: 178),
                    child: Text(
                      'Sign up to get started',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 590,

                    width: double.infinity,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 18),

                          ///first name
                          TextFormField(
                            controller: firstNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              hint: Text('Enter first name'),
                            ),
                          ),
                          const SizedBox(height: 20),

                          ///last name
                          TextFormField(
                            controller: lastNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              hint: Text('Enter last name'),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ///email
                          TextFormField(
                            controller: emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
                            validator: (value) =>
                                Validator.emailValidator(value),
                            keyboardType: TextInputType.emailAddress,
=======
>>>>>>> Stashed changes
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              String pattern =
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                              RegExp regex = RegExp(pattern);

                              if (!regex.hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
<<<<<<< Updated upstream
=======
>>>>>>> upstream/main
>>>>>>> Stashed changes
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              hint: Text('Enter email'),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ///password
                          TextFormField(
                            obscureText: isVisible,
                            controller: passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.visiblePassword,
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
                            validator: (value) =>
                                Validator.passwordValidator(value),
=======
>>>>>>> Stashed changes
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
<<<<<<< Updated upstream
=======
>>>>>>> upstream/main
>>>>>>> Stashed changes
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hint: Text('Enter password'),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: Icon(
                                    isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 60),

                          ElevatedButton(
<<<<<<< Updated upstream
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                _nextScreen();
=======
<<<<<<< HEAD
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                String email = emailController.text.trim();
                                String password = passwordController.text
                                    .trim();
                                String first_name = firstNameController.text
                                    .trim();
                                String last_name = lastNameController.text
                                    .trim();
                                _showLoadingDialog(context);
                                final success = await AuthServices.register(
                                  email: email,
                                  password: password,
                                  first_name: first_name,
                                  last_name: last_name,
                                );
                                print("register sucess:- $success");
                                Navigator.pop(context);
                                if (success['success']) {
                                  _nextScreen();
                                } else {
                                  _showerror(success['message']);
                                }
=======
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                _nextScreen();
>>>>>>> upstream/main
>>>>>>> Stashed changes
                                formKey.currentState!.reset();
                                FocusScope.of(context).unfocus();
                              }
                            },
                            child: Text(
                              "Create Account",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19.sp,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Loginscreen(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 800),
              ),
        ),
      ),
    );
  }

  void _nextScreen() async {
<<<<<<< Updated upstream
    _showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 3), () {});

=======
<<<<<<< HEAD
=======
    _showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 3), () {});

>>>>>>> upstream/main
>>>>>>> Stashed changes
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Hiddendrawer();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
      barrierDismissible: false,
=======
>>>>>>> upstream/main
>>>>>>> Stashed changes
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(
                'Sign Up...',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
<<<<<<< Updated upstream
=======
<<<<<<< HEAD

  void _showerror(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        padding: EdgeInsets.all(10),
        backgroundColor: Colors.redAccent,
        content: Center(
          child: Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 18.sp),
          ),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
=======
>>>>>>> upstream/main
>>>>>>> Stashed changes
}
