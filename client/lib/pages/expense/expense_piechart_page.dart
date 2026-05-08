import 'package:expense_tracker/provider/add_expense_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ExpensePiechartPage extends StatelessWidget {
  const ExpensePiechartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpensePiechart>(context);
    final total = provider.incomelist.fold(
      0.0,
      (sum, element) => sum + element.amount,
    );
    if (provider.incomelist.isEmpty) {
      return Center(
        child: Text(
          "No Data entry",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Total Expense: ${provider.incomelist.first.currencySymbol} ${total.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: provider.incomelist.map((item) {
                final parsentage = item.amount / total * 100;
                return PieChartSectionData(
                  titlePositionPercentageOffset: parsentage > 10 ? 0.44 : 0.5,
                  color: item.color,
                  value: item.amount,
                  title: '${parsentage.toStringAsFixed(1)}%',
                  radius: 65,
                  titleStyle: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontSize: 15.sp),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 300,
          width: double.infinity,
          child: ListView.builder(
            itemCount: provider.incomelist.length,
            itemBuilder: (context, index) {
              final item = provider.incomelist[index];
              return ListTile(
                leading: CircleAvatar(backgroundColor: item.color, radius: 10),
                title: Text(item.purpose),
                trailing: Text(
                  'Amount: ${item.currencySymbol} ${item.amount}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 17.sp),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
