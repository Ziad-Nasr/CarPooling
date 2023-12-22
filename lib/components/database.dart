import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "ProfileDatabase.db";
  static final _databaseVersion = 2;
  static final table = 'profile';

  static final columnEmail = 'email';
  static final columnName = 'name';
  static final columnLevel = 'level';
  static final columnPhoneNumber = 'phoneNumber';
  DatabaseHelper() {}
  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed.
    _database = await _initializeDatabase();
    return _database!;
  }

  // Open the database and create the table.
  _initializeDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory + _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnEmail TEXT PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnLevel TEXT NOT NULL,
            $columnPhoneNumber TEXT NOT NULL
          )
          ''');
  }
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryRows(String email) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnEmail = ?', whereArgs: [email]);
  }

  reading(sql) async {
    Database db = await instance.database;
    return await db.rawQuery(sql);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String email = row[DatabaseHelper.columnEmail];
    return await db.update(DatabaseHelper.table, row,
        where: '${DatabaseHelper.columnEmail} = ?', whereArgs: [email]);
  }

  // Delete a profile row.
  Future<int> delete(String email) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$columnEmail = ?', whereArgs: [email]);
  }
}
