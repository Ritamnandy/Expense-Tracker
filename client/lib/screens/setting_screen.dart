import 'package:expense_tracker/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  final AdvancedDrawerController advancedDrawerController;
  const SettingScreen({super.key, required this.advancedDrawerController});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.advancedDrawerController.showDrawer();
          },
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: widget.advancedDrawerController,
            builder: (_, value, _) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: Semantics(
                  label: 'Menu',
                  onTapHint: 'expand drawer',
                  child: FaIcon(
                    key: ValueKey<bool>(value.visible),
                    value.visible
                        ? FontAwesomeIcons.xmark
                        : FontAwesomeIcons.bars,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27.sp,
                  ),
                ),
              );
            },
          ),
        ),

        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              _showThemeDialog(context);
            },
            title: Text("Theme"),
            subtitle: Text("Select your preferred theme"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(
          context,
          listen: false,
        );
        return AlertDialog(
          title: Text("Select Theme"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Light"),
                trailing: themeProvider.themeMode == ThemeMode.light
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme('light');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Dark"),
                trailing: themeProvider.themeMode == ThemeMode.dark
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme('dark');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("System Default"),
                trailing: themeProvider.themeMode == ThemeMode.system
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme('system');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
