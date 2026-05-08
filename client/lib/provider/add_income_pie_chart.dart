import 'package:expense_tracker/models/chartdata.dart';
import 'package:flutter/material.dart';

class IncomePiechart extends ChangeNotifier {
  final List<Chartdata> _incomelist = [];
  List<Chartdata> get incomelist => _incomelist;
  void addIncome({
    required String purpose,
    required double amount,
    required Color color,
  }) {
    _incomelist.add(Chartdata(purpose: purpose, amount: amount, color: color));
    notifyListeners();
  }
}
