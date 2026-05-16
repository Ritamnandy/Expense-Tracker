import 'dart:async';

import 'package:expense_tracker/models/chartdata.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._init();
  static DBHelper get instance => _instance;
  static Database? _dataBase;

  DBHelper._init();

  Future<Database> get database async {
    if (_dataBase != null) {
      return _dataBase!;
    }
    _dataBase = await _initDB("Expense_tracker");
    return _dataBase!;
  }

  Future<Database?> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purpose TEXT,
        amount REAL,
        currencySymbol TEXT,
        isExpense INTEGER,
        date TEXT
      )
    ''');
  }

  // INSERT
  Future<int> insertData(Chartdata data) async {
    final db = await instance.database;

    return await db.insert('transactions', data.toMap());
  }

  // READ
  Future<List<Chartdata>> getAllData() async {
    final db = await instance.database;

    final result = await db.query('transactions');

    return result.map((e) => Chartdata.fromMap(e)).toList();
  }

  ///Read data by date
  Future<List<Chartdata>> searchByDate(String date) async {
    final db = await instance.database;

    final result = await db.query(
      'transactions',
      where: 'date = ?',
      whereArgs: [date],
    );

    return result.map((e) => Chartdata.fromMap(e)).toList();
  }

  ///Read data by Month
  Future<List<Chartdata>> searchByMonth(String month) async {
    final db = await instance.database;

    final result = await db.query(
      'transactions',
      where: 'date LIKE ?',
      whereArgs: ['$month%'],
    );

    return result.map((e) => Chartdata.fromMap(e)).toList();
  }

=======
>>>>>>> upstream/main
  // UPDATE
  Future<int> updateData(Chartdata data) async {
    final db = await instance.database;

    return await db.update(
      'transactions',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // DELETE
  Future<int> deleteData(int id) async {
    final db = await instance.database;

    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
