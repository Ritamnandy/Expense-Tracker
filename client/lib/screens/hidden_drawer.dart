import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:expense_tracker/provider/image_provider.dart';
import 'package:expense_tracker/screens/help_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/notifications.dart';
import 'package:expense_tracker/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
    Provider.of<ImageController>(context, listen: false).pickImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final imageProvider = Provider.of<ImageController>(context, listen: false);
    final image = imageProvider.imageFile;
    // print("images $image");
    ;
    return AdvancedDrawer(
      backdrop: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).inputDecorationTheme.fillColor!,
              Theme.of(context).inputDecorationTheme.fillColor!,
            ],
          ),
        ),
      ),
      childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      animateChildDecoration: false,
      rtlOpening: false,
      openRatio: 0.60,
      disabledGestures: false,
      drawer: SafeArea(
        top: false,
        child: Stack(
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(60.w),
              padding: EdgeInsets.only(bottom: 40.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: image != null
                  ? Image.file(image, fit: BoxFit.cover)
                  : Center(child: Icon(Icons.person, size: 50.sp)),
            ),
            Align(
              alignment: AlignmentGeometry.xy(0, -0.29),
              child: ListTile(
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
            ),
            Align(
              alignment: AlignmentGeometry.xy(0, -0.15),
              child: ListTile(
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
            ),
            Align(
              alignment: AlignmentGeometry.xy(0, -0.0),
              child: ListTile(
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
            ),
            Align(
              alignment: AlignmentGeometry.xy(0, 0.16),
              child: ListTile(
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
            ),
            // Spacer(),
            Align(
              alignment: AlignmentGeometry.xy(0, 0.6),
              child: ElevatedButton(
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
            ),
            // Spacer(flex: 1),
            Align(
              alignment: AlignmentGeometry.xy(0, 1.0),
              child: Text(
                "Version 1.0.0",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.xy(0.29, -0.55),
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () {
                              imageProvider.pickFromCamera();
                            },
                            leading: Icon(Icons.camera_alt),
                            title: Text('Camera'),
                          ),
                          ListTile(
                            onTap: () {
                              imageProvider.pickFromGallery();
                            },
                            leading: Icon(Icons.photo),
                            title: Text('Gallery'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: FaIcon(FontAwesomeIcons.cameraRetro, size: 20.sp),
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
