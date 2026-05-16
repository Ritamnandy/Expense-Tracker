import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:expense_tracker/screens/help_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/notifications.dart';
import 'package:expense_tracker/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Hiddendrawer extends StatefulWidget {
  const Hiddendrawer({super.key});

  @override
  State<Hiddendrawer> createState() => _HiddendrawerState();
}

class _HiddendrawerState extends State<Hiddendrawer> {
  final _advancedDrawerController = AdvancedDrawerController();
  List<Widget> pages = [];
  int currentIndex = 0;

  @override
  void initState() {
    pages = [
      Homescreen(advancedDrawerController: _advancedDrawerController),
      Notificationscreen(advancedDrawerController: _advancedDrawerController),
      Helpandsupport(advancedDrawerController: _advancedDrawerController),
      SettingScreen(advancedDrawerController: _advancedDrawerController),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AdvancedDrawer(
      backdrop: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      animateChildDecoration: true,
      rtlOpening: false,
      openRatio: 0.60,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        top: false,
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo.png", fit: BoxFit.cover),
            ),
            ListTile(
              onTap: () async {
                setState(() {
                  currentIndex = 0;
                });
                await Future.delayed(Duration(milliseconds: 250));
                _advancedDrawerController.hideDrawer();
              },
              leading: FaIcon(FontAwesomeIcons.solidHouse),
              title: Text('Home'),
            ),
            ListTile(
              onTap: () async {
                setState(() {
                  currentIndex = 1;
                });
                await Future.delayed(Duration(milliseconds: 250));
                _advancedDrawerController.hideDrawer();
              },
              leading: FaIcon(FontAwesomeIcons.solidBell),
              title: Text('Notifications'),
            ),
            ListTile(
              onTap: () async {
                setState(() {
                  currentIndex = 2;
                });
                await Future.delayed(Duration(milliseconds: 250));
                _advancedDrawerController.hideDrawer();
              },
              leading: FaIcon(FontAwesomeIcons.solidCircleQuestion),
              title: Text('Help & Support'),
            ),
            ListTile(
              onTap: () async {
                setState(() {
                  currentIndex = 3;
                });
                await Future.delayed(Duration(milliseconds: 250));
                _advancedDrawerController.hideDrawer();
              },
              leading: Icon(Icons.settings, size: 27.sp),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                await InitSheredPref.instance.logOut();
                _nextpage();
              },
              child: Text(
                "Logout",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(flex: 1),
            Text(
              "Version 1.0.0",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      child: pages[currentIndex],
    );
  }

  void _nextpage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Loginscreen();
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
}
