import 'package:expense_tracker/provider/add_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:year_month_picker/year_month_picker.dart';

class AllTransaction extends StatefulWidget {
  final String currencySymbol;
  const AllTransaction({super.key, required this.currencySymbol});

  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
  String formattedDate = DateFormat('MMMM yyyy').format(DateTime.now());

  @override
  void initState() {
    Future.microtask(() {
      context.read<ExpenseAndIncomeChart>().searchByMonth(currentMonth);
    });
    super.initState();
  }

  Future<void> pickMonth(BuildContext context) async {
    final selected = await showYearMonthPickerDialog(
      context: context,
      firstYear: 2020,
      lastYear: 2070,
      initialYearMonth: DateTime.now(),
    );
    late String month;
    if (selected != null) {
      month = DateFormat('yyyy-MM').format(selected);
      setState(() {
        currentMonth = month;
        formattedDate = DateFormat('MMMM yyyy').format(selected);
      });
    }
    context.read<ExpenseAndIncomeChart>().searchByMonth(month);
  }

  @override
  Widget build(BuildContext context) {
    final chartProvider = Provider.of<ExpenseAndIncomeChart>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text("See all Transactions", style: TextStyle(fontSize: 19.sp)),
      ),
      body: SingleChildScrollView(
        child:
            Column(
              children: [
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(fontSize: 21.sp),
                      ),
                      IconButton(
                        onPressed: () {
                          pickMonth(context);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.filter,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                chartProvider.list.isEmpty
                    ? Center(child: Text("data not entry"))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: chartProvider.list.length,
                        itemBuilder: (context, index) {
                          final sortedList = [...chartProvider.list];

                          sortedList.sort((a, b) => b.id!.compareTo(a.id!));
                          DateTime date = DateTime.parse(
                            sortedList[index].date,
                          );
                          String formattedDate = DateFormat(
                            'MMM dd, yyyy',
                          ).format(date);

                          return ListTile(
                            subtitle: Text(formattedDate),
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: sortedList[index].isExpense
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                sortedList[index].isExpense
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              sortedList[index].purpose,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '${widget.currencySymbol} ${sortedList[index].amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ).animate().fadeIn(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 1000),
                      ),
              ],
            ).animate().fadeIn(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 1000),
            ),
      ),
    );
  }
}
