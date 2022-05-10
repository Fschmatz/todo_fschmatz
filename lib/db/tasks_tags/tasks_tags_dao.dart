import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TasksTagsDao {

  static const _databaseName = 'Todo.db';
  static const _databaseVersion = 1;

  static const table = 'tasks_tags';
  static const columnIdTask = 'id_task';
  static const columnIdTag = 'id_tag';

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

  Future<List<Map<String, dynamic>>> queryTagsFromTaskId(int task) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnIdTask = $task');
  }

  Future<int> deleteWithTaskId(int idTask) async {
    Database db = await instance.database;
    return await db.delete('$table WHERE $columnIdTask = $idTask');
  }

  Future<int> deleteWithTagId(int idTag) async {
    Database db = await instance.database;
    return await db.delete('$table WHERE $columnIdTag = $idTag');
  }

}