import 'package:expense_tracker/pages/expense_page.dart';
import 'package:expense_tracker/pages/income_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 340,
                    width: double.infinity,
                    // color: Colors.red,
                    child: TabBarView(children: [Incomepage(), Expensepage()]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 320),
                    padding: const EdgeInsets.all(15),
                    height: 420,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      spacing: 80,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 180.w,
                              child: Center(
                                child: ListTile(
                                  leading: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.arrow_upward,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  title: Text(
                                    "Income",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "12,000",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 190.w,
                              child: Center(
                                child: ListTile(
                                  leading: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.arrow_downward,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  title: Text(
                                    "Expense",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "10,000",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        CircularPercentIndicator(
                          radius: 160.0,
                          lineWidth: 40.0,
                          animation: true,
                          animationDuration: 1200,
                          circularStrokeCap: CircularStrokeCap.round,
                          percent: 0.7,

                          center: Text(
                            "Safe to Spend",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).inputDecorationTheme.fillColor!,
                          progressColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
