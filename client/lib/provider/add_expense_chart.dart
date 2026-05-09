import 'package:expense_tracker/models/chartdata.dart';
import 'package:flutter/material.dart';

class ExpenseAndIncomeChart extends ChangeNotifier {
  final List<Chartdata> _list = [];
  List<Chartdata> get list => _list;
  void addIncome({
    required String purpose,
    required double amount,
    required String currencySymbol,
    required bool isExpense,
  }) {
    _list.add(
      Chartdata(
        purpose: purpose,
        amount: amount,
        isExpense: isExpense,
        currencySymbol: currencySymbol,
      ),
    );
    notifyListeners();
  }
}
