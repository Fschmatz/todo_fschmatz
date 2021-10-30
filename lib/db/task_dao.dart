import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TaskDao {

  static const _databaseName = 'Todo.db';
  static const _databaseVersion = 1;

  static const table = 'tasks';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnNote = 'note';
  static const columnState = 'state';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  TaskDao._privateConstructor();
  static final TaskDao instance = TaskDao._privateConstructor();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL create DB
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
           $columnId INTEGER PRIMARY KEY,
           $columnTitle TEXT NOT NULL,
           $columnNote TEXT,
           $columnState INTEGER NOT NULL
          )
          ''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDesc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY id DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllState(int state) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnState = $state');
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

}