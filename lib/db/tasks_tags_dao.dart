import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TasksTagsDao {

  static const _databaseName = 'Todo.db';
  static const _databaseVersion = 1;

  static const table = 'tasks';
  static const columnId = 'id_task';
  static const columnTitle = 'title';
  static const columnNote = 'note';
  static const columnState = 'state';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  TasksTagsDao._privateConstructor();
  static final TasksTagsDao instance = TasksTagsDao._privateConstructor();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
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