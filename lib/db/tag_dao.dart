import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TagDao {

  static const _databaseName = 'Todo.db';
  static const _databaseVersion = 1;

  static const table = 'tags';
  static const columnId = 'id_tag';
  static const columnName = 'name';
  static const columnColor = 'color';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await initDatabase();

  TagDao._privateConstructor();
  static final TagDao instance = TagDao._privateConstructor();

  Future<Database> initDatabase() async {
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

  Future<List<Map<String, dynamic>>> queryAllRowsByName() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY $columnName');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDesc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY id DESC');
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

  Future<List<Map<String, dynamic>>> getTags(int idTask) async {
    Database db = await instance.database;
    return await db.rawQuery('''    
          SELECT tg.id_tag, tg.name, tg.color FROM tags tg,tasks_tags tt 
          WHERE tt.id_task = $idTask AND tg.id_tag=tt.id_tag 
          GROUP BY tg.id_tag     
        ''');
  }

  Future<List<Map<String, dynamic>>> getTagsByName(int idTask) async {
    Database db = await instance.database;
    return await db.rawQuery('''    
          SELECT tg.id_tag, tg.name, tg.color FROM tags tg,tasks_tags tt 
          WHERE tt.id_task = $idTask AND tg.id_tag=tt.id_tag 
          GROUP BY tg.id_tag    
          ORDER BY tg.name 
        ''');
  }


}