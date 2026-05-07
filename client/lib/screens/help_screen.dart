import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Helpandsupport extends StatelessWidget {
  final AdvancedDrawerController advancedDrawerController;
  const Helpandsupport({super.key, required this.advancedDrawerController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            advancedDrawerController.showDrawer();
          },
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: advancedDrawerController,
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

        title: Text("Help & Support"),
        centerTitle: true,
      ),
      body: Center(child: Text("Help & Support Page")),
    );
  }
}
