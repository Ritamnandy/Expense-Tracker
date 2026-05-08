import 'package:expense_tracker/pages/expense/expense_page.dart';
import 'package:expense_tracker/pages/income/income_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  final AdvancedDrawerController advancedDrawerController;
  const Homescreen({super.key, required this.advancedDrawerController});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final now = DateTime.now();
  String time = '';

  @override
  void initState() {
    time = DateFormat('dd MMM yyyy').format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.00),
                child: CircleAvatar(
                  radius: 23.r,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: const NetworkImage(
                    'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
              ),
            ],
            title: InkWell(
              onTap: () => _selectTime(context),
              child: Text(time),
            ),
            centerTitle: true,
            bottom: TabBar(
              dividerColor: Colors.transparent,

              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  child: Text(
                    'Income',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 20.sp,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Expense',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            top: false,
            child: TabBarView(children: [Incomepage(), Expensepage()]),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    DateTime? datetime = await showDatePicker(
      barrierColor: Colors.black45,
      context: context,
      firstDate: DateTime(1980),
      lastDate: DateTime(2200),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).colorScheme.primary,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerForegroundColor: Theme.of(context).colorScheme.primary,
              dayForegroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
              yearForegroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (datetime != null) {
      setState(() {
        time = DateFormat('dd MMM yyyy').format(datetime);
      });
    }
  }
}
