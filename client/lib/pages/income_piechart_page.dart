import 'package:expense_tracker/provider/add_income_pie_chart.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Piecgartpage extends StatelessWidget {
  const Piecgartpage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncomePiechart>(context);
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
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: provider.incomelist.map((item) {
                  final parsentage = item.amount / total * 100;
                  return PieChartSectionData(
                    color: item.color,
                    value: item.amount,
                    title: '${parsentage.toStringAsFixed(1)}%',
                    radius: 70,
                    titleStyle: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: provider.incomelist.length,
            itemBuilder: (context, index) {
              final item = provider.incomelist[index];
              return ListTile(
                leading: CircleAvatar(backgroundColor: item.color),
                title: Text(item.purpose),
                subtitle: Text('Amount: ${item.amount}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
