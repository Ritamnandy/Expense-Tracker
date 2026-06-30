import 'package:expense_tracker/models/chartdata.dart';
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
  bool showIncomeSummary = false;

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
    if (selected != null) {
      final month = DateFormat('yyyy-MM').format(selected);
      setState(() {
        currentMonth = month;
        formattedDate = DateFormat('MMMM yyyy').format(selected);
      });
      context.read<ExpenseAndIncomeChart>().searchByMonth(month);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chartProvider = Provider.of<ExpenseAndIncomeChart>(context);
    final previousMonthIncome = _totalIncome(chartProvider.previousMonthList);
    final previousMonthExpense = _totalExpense(chartProvider.previousMonthList);
    final previousMonth = _previousMonthLabel(currentMonth);

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

                _MonthlySummary(
                  currencySymbol: widget.currencySymbol,
                  previousMonthLabel: previousMonth,
                  previousMonthIncome: previousMonthIncome,
                  previousMonthExpense: previousMonthExpense,
                  isExpanded: showIncomeSummary,
                  onToggle: () {
                    setState(() {
                      showIncomeSummary = !showIncomeSummary;
                    });
                  },
                ),

                const SizedBox(height: 5),

                chartProvider.list.isEmpty
                    ? Center(
                        child: Text(
                          "No data found",
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      )
                    : _TransactionList(
                        list: chartProvider.list,
                        currencySymbol: widget.currencySymbol,
                        onDelete: (id) => context
                            .read<ExpenseAndIncomeChart>()
                            .deleteItem(id),
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

  double _totalIncome(List<Chartdata> list) {
    return list
        .where((element) => element.isExpense == false)
        .fold(0.0, (previousValue, element) => previousValue + element.amount);
  }

  double _totalExpense(List<Chartdata> list) {
    return list
        .where((element) => element.isExpense == true)
        .fold(0.0, (previousValue, element) => previousValue + element.amount);
  }

  String _previousMonthLabel(String month) {
    final selected = DateFormat('yyyy-MM').parse(month);
    return DateFormat(
      'MMMM yyyy',
    ).format(DateTime(selected.year, selected.month - 1));
  }
}

class _MonthlySummary extends StatelessWidget {
  final String currencySymbol;
  final String previousMonthLabel;
  final double previousMonthIncome;
  final double previousMonthExpense;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _MonthlySummary({
    required this.currencySymbol,
    required this.previousMonthLabel,
    required this.previousMonthIncome,
    required this.previousMonthExpense,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Previous Month Summary',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            previousMonthLabel,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _SummaryAmountRow(
                          icon: Icons.arrow_upward,
                          color: Theme.of(context).colorScheme.primary,
                          label: 'Income',
                          amount:
                              '$currencySymbol ${previousMonthIncome.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 10),
                        _SummaryAmountRow(
                          icon: Icons.arrow_downward,
                          color: Theme.of(context).colorScheme.secondary,
                          label: 'Expense',
                          amount:
                              '$currencySymbol ${previousMonthExpense.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryAmountRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String amount;

  const _SummaryAmountRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          amount,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<Chartdata> list;
  final String currencySymbol;
  final void Function(String id) onDelete;

  const _TransactionList({
    required this.list,
    required this.currencySymbol,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final sortedList = [...list]..sort(_sortNewestFirst);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedList.length,
      itemBuilder: (context, index) {
        final item = sortedList[index];
        final date = DateTime.parse(item.date);
        final formattedDate = DateFormat('MMM dd, yyyy').format(date);
        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Transaction'),
                content: const Text(
                  'Are you sure you want to delete this transaction?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) {
            if (item.id != null) onDelete(item.id!);
          },
          child: ListTile(
            subtitle: Text(formattedDate),
            leading: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: item.isExpense
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(
              item.purpose,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '$currencySymbol ${item.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  int _sortNewestFirst(Chartdata a, Chartdata b) {
    final dateCompare = b.date.compareTo(a.date);
    if (dateCompare != 0) return dateCompare;

    final aTime = DateTime.tryParse(a.updatedAt ?? '');
    final bTime = DateTime.tryParse(b.updatedAt ?? '');
    if (aTime == null && bTime == null) return 0;
    if (aTime == null) return 1;
    if (bTime == null) return -1;

    return bTime.compareTo(aTime);
  }
}
