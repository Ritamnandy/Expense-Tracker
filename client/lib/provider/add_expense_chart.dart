import 'package:expense_tracker/db/db_helper.dart';
import 'package:expense_tracker/models/chartdata.dart';
import 'package:flutter/material.dart';

class ExpenseAndIncomeChart extends ChangeNotifier {
  List<Chartdata> _list = [];
  List<Chartdata> get list => _list;

  //ReadData
  Future<void> loadData() async {
    _list = await DBHelper.instance.getAllData();
    notifyListeners();
  }

  void addIncome({
    required String purpose,
    required double amount,
    required String currencySymbol,
    required bool isExpense,
  }) async {
    Chartdata data = Chartdata(
      purpose: purpose,
      amount: amount,
      currencySymbol: currencySymbol,
      isExpense: isExpense,
      date: DateTime.now().toString().split(' ')[0],
    );

    int id = await DBHelper.instance.insertData(data);

    Chartdata newData = Chartdata(
      id: id,
      purpose: purpose,
      amount: amount,
      currencySymbol: currencySymbol,
      isExpense: isExpense,
      date: DateTime.now().toString().split(' ')[0],
    );

    _list.add(newData);

    notifyListeners();
  }

  // SEARCH BY DATE
  Future<void> searchByDate(String date) async {
    final data = await DBHelper.instance.searchByDate(date);
    if (data.isNotEmpty) {
      _list = data;
    } else {
      _list = [];
    }
    notifyListeners();
  }

  Future<void> searchByMonth(String month) async {
    final data = await DBHelper.instance.searchByMonth(month);
    if (data.isNotEmpty) {
      _list = data;
    } else {
      _list = [];
    }
    notifyListeners();
  }

  // DELETE DATA
  Future<void> deleteItem(int id) async {
    await DBHelper.instance.deleteData(id);

    _list.removeWhere((e) => e.id == id);

    notifyListeners();
  }
}
