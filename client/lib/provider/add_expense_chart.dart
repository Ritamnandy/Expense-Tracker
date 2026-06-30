import 'package:expense_tracker/db/db_helper.dart';
import 'package:expense_tracker/models/chartdata.dart';
import 'package:expense_tracker/models/init_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ExpenseAndIncomeChart extends ChangeNotifier {
  List<Chartdata> _list = [];
  List<Chartdata> get list => _list;
  List<Chartdata> _previousMonthList = [];
  List<Chartdata> get previousMonthList => _previousMonthList;

  /// Tracks the last month filter so addIncome knows whether to append.
  String? _currentMonth;
  String? get currentMonth => _currentMonth;

  Future<String?> _userId() async {
    return await InitSheredPref.instance.getUserId();
  }

  String _now() {
    final n = DateTime.now();
    return '${n.year}-${_pad(n.month)}-${_pad(n.day)} ${_pad(n.hour)}:${_pad(n.minute)}:${_pad(n.second)}';
  }

  String _pad(int v) => v.toString().padLeft(2, '0');

  // READ ALL
  Future<void> loadData() async {
    final userId = await _userId();
    _list = await DBHelper.instance.getAllData(userId: userId);
    notifyListeners();
  }

  /// Insert a new income or expense.
  /// Only appends to [_list] if the new item belongs to the active month filter,
  /// so viewing a past month doesn't get polluted with today's new entries.
  Future<void> addIncome({
    required String purpose,
    required double amount,
    required String currencySymbol,
    required bool isExpense,
    required DateTime date,
  }) async {
    final now = _now();
    final nowDate = date; // Use the provided date instead of DateTime.now()
    final dateStr = nowDate.toIso8601String().split('T')[0]; // 'yyyy-MM-dd'

    Chartdata data = Chartdata(
      id: const Uuid().v4(),
      purpose: purpose,
      amount: amount,
      currencySymbol: currencySymbol,
      isExpense: isExpense,
      date: dateStr,
      userId: await _userId(),
      updatedAt: now,
    );

    await DBHelper.instance.insertData(data);

    // Only add to the live list if it matches the current month filter
    final itemMonth = dateStr.substring(0, 7); // 'yyyy-MM'
    if (_currentMonth == null || itemMonth == _currentMonth) {
      _list.add(data);
    }
    notifyListeners();
  }

  // SEARCH BY DATE
  Future<void> searchByDate(String date) async {
    final userId = await _userId();
    final data = await DBHelper.instance.searchByDate(date, userId: userId);
    _list = data;
    notifyListeners();
  }

  Future<void> searchByMonth(String month) async {
    _currentMonth = month;
    final userId = await _userId();
    final data = await DBHelper.instance.searchByMonth(month, userId: userId);
    final previousMonth = _previousMonth(month);
    final previousData = await DBHelper.instance.searchByMonth(
      previousMonth,
      userId: userId,
    );
    _list = data;
    _previousMonthList = previousData;
    notifyListeners();
  }

  // DELETE DATA
  Future<void> deleteItem(String id) async {
    await DBHelper.instance.deleteData(id);
    _list.removeWhere((e) => e.id == id);
    _previousMonthList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  String _previousMonth(String month) {
    final parts = month.split('-');
    if (parts.length != 2) return month;

    final year = int.tryParse(parts[0]);
    final monthNumber = int.tryParse(parts[1]);
    if (year == null || monthNumber == null) return month;

    final previous = DateTime(year, monthNumber - 1);
    return '${previous.year}-${_pad(previous.month)}';
  }
}
