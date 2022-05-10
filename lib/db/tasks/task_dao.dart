import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TaskDao {

  static const _databaseName = 'Todo.db';
  static const _databaseVersion = 1;

  static const table = 'tasks';
  static const columnId = 'id_task';
  static const columnTitle = 'title';
  static const columnNote = 'note';
  static const columnState = 'state';
  static const columnIdTodo = 'id_todo';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  TaskDao._privateConstructor();
  static final TaskDao instance = TaskDao._privateConstructor();

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

  Future<List<Map<String, dynamic>>> queryAllRowsDesc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY id DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllByState(int state) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnState = $state');
  }

  Future<List<Map<String, dynamic>>> queryAllByStateDesc(int state) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnState = $state ORDER BY id_task DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllByTodoAndStateDesc(int state, int todoId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnState = $state AND $columnIdTodo = $todoId ORDER BY id_task DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllByTodo(int todoId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnIdTodo = $todoId ORDER BY id_task DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllByTodoStateFilter(int state, int todoId, String order) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnState = $state AND $columnIdTodo = $todoId ORDER BY $order');
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

  Future<int> deleteAllTasksFromTodo(int idTodo) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnIdTodo = ?', whereArgs: [idTodo]);
  }
}