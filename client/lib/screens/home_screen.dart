import 'package:expense_tracker/pages/expense_page.dart';
import 'package:expense_tracker/pages/income_page.dart';
import 'package:expense_tracker/provider/add_expense_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ExpenseAndIncomeChart>().loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chartProvider = Provider.of<ExpenseAndIncomeChart>(context);
    // if (chartProvider.list.isEmpty) {
    //   debugPrint("list is empty");
    //   return Text("Empty");
    // }
    final list = chartProvider.list;
    final totalIncome = list.isEmpty
        ? 0.00
        : list
              .where((element) => element.isExpense == false)
              .fold(
                0.0,
                (previousValue, element) => previousValue + element.amount,
              );
    final totalExpense = list.isEmpty
        ? 0.00
        : list
              .where((element) => element.isExpense == true)
              .fold(
                0.0,
                (previousValue, element) => previousValue + element.amount,
              );

    final currencySymbol = chartProvider.list.isNotEmpty
        ? chartProvider.list.first.currencySymbol
        : '₹'; // Default to '₹' if the list is empty
    final safeToSpend = totalIncome - totalExpense;
    final safeToSpendPercentage = totalIncome > 0
        ? (safeToSpend / totalIncome).clamp(0.0, 1.0)
        : 0.0;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysPassed = daysInMonth - now.day;

    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        length: 2,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontSize: 20.sp,

                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Expense',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,

              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 340,
                    width: double.infinity,
                    // color: Colors.red,
                    child: TabBarView(children: [Incomepage(), Expensepage()]),
                  ),
                  Container(
                    // margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(15),
                    height: 480,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      spacing: 70,
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
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '$currencySymbol ${totalIncome.toStringAsFixed(2)}',
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
                              width: 180.w,
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
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '$currencySymbol ${totalExpense.toStringAsFixed(2)}',
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
                          percent: safeToSpendPercentage,

                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Safe to Spend",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),

                              SizedBox(height: 10),

                              Text(
                                "$currencySymbol ${safeToSpend.toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                "$daysPassed days left",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).inputDecorationTheme.fillColor!,
                          progressColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(15),
                    height: 80,
                    width: double.infinity,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Transactions",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.refresh,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: chartProvider.list.length,
                    itemBuilder: (context, index) {
                      if (chartProvider.list.isEmpty) {
                        return Text("Data not entry");
                      }
                      return ListTile(
                        leading: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: chartProvider.list[index].isExpense
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            chartProvider.list[index].isExpense
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: Text(
                          chartProvider.list[index].purpose,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          '$currencySymbol ${chartProvider.list[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),

                  Container(
                    // margin: const EdgeInsets.only(top: 60),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Center(
                      child: Text(
                        "Place for add..",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
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
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Colors.black,
              onSurface: Theme.of(context).colorScheme.secondary,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerForegroundColor: Theme.of(context).colorScheme.primary,
              dayForegroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primaryContainer,
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
      _searchbydate(datetime.toString().split(' ')[0]);
      setState(() {
        time = DateFormat('dd MMM yyyy').format(datetime);
      });
    }
  }

  void _searchbydate(String date) async {
    // ignore: use_build_context_synchronously
    await context.read<ExpenseAndIncomeChart>().searchByDate(date);
  }
}
