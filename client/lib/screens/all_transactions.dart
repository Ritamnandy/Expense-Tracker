import 'package:expense_tracker/provider/add_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllTransaction extends StatefulWidget {
  final String currencySymbol;
  const AllTransaction({super.key, required this.currencySymbol});

  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
  @override
  void initState() {
    Future.microtask(() {
      context.read<ExpenseAndIncomeChart>().searchByMonth(currentMonth);
    });
    super.initState();
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: chartProvider.list.length,
                  itemBuilder: (context, index) {
                    final sortedList = [...chartProvider.list];

                    sortedList.sort((a, b) => b.id!.compareTo(a.id!));
                    DateTime date = DateTime.parse(sortedList[index].date);
                    String formattedDate = DateFormat(
                      'MMM dd, yyyy',
                    ).format(date);
                    if (sortedList.isEmpty) {
                      return Center(child: Text("Data not entry"));
                    }
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
