import 'dart:async';

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
    _dataBase = await initDB("");
    return _dataBase!;
  }

  Future<Database?> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute("sql");
  }
}
