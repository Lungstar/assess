import 'dart:io';

import 'package:assess/core/model/currency.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  final String tableCurrency = "currencyTable";

  final String columnId = "currency";

  static final DataBaseHelper _instance = DataBaseHelper.internal();

  DataBaseHelper.internal();

  factory DataBaseHelper() => _instance;

  static late Database _db;

  Future<Database> get dbase async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "mydb.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableCurrency($columnId INTEGER PRIMARY KEY , $columnId TEXT,)");
  }

  Future<int> saveUser(Currency user) async {
    var dbClient = await dbase;
    await initDb();
    int result = await dbClient.insert(
      tableCurrency,
      user.toMap(),
    );
    return result;
  }

  Future<List> getAllCurrency() async {
    var dbClient = await dbase;
    var result = await dbClient.rawQuery("SELECT * FROM $tableCurrency");
    return result.toList();
  }

  Future<Currency?> getCurrency(int userId) async {
    var dbClient = await dbase;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableCurrency Where $columnId = $userId ");
    if (result.length == 0) return null;
    return Currency.fromMap(result.first);
  }

  Future<int> deleteUser(int userId) async {
    var dbClient = await dbase;
    return await dbClient
        .delete(tableCurrency, where: "$columnId=?", whereArgs: [userId]);
  }

  Future<int> updateUser(Currency currency) async {
    var dbClient = await dbase;
    return dbClient.update(tableCurrency, currency.toMap(),
        where: "$columnId=?", whereArgs: [currency.currency]);
  }

  Future close() async {
    var dbClient = await dbase;
    return dbClient.close();
  }
}
