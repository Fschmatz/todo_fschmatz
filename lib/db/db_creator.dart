import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_fschmatz/db/current_todo.dart';

class DbCreator {

  static const _databaseName = "Todo.db";
  static const _databaseVersion = 1;
  static Database? _database;
  Future<Database> get database async =>
      _database ??= await initDatabase();

  DbCreator._privateConstructor();
  static final DbCreator instance = DbCreator._privateConstructor();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {

    CurrentTodo().saveToPrefs(1);

    await db.execute('''    
           CREATE TABLE todos (
             id_todo INTEGER PRIMARY KEY,
             name TEXT NOT NULL           
          )          
          ''');

    await db.execute('''    
           CREATE TABLE tasks (
             id_task INTEGER PRIMARY KEY,
             title TEXT NOT NULL,
             note TEXT,
             state INTEGER NOT NULL,
             id_todo INTEGER NOT NULL
          )          
          ''');

    await db.execute('''       
          CREATE TABLE tags (
            id_tag INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            color TEXT NOT NULL
          )
          ''');

    await db.execute(''' 
          CREATE TABLE tasks_tags (
            id_task INTEGER NOT NULL,
            id_tag INTEGER NOT NULL
          )
          ''');

    //direct inserts for tests
    Batch batch = db.batch();

    batch.insert('todos', {
      'id_todo': 1,
      'name': 'My Todo'
    });

    batch.insert('tasks', {
      'id_task': 1,
      'title': 'Korolev',
      'note': 'Higher! Faster than anyone!!!',
      'state': 0,
      'id_todo': 1
    });

    batch.insert('tags', {
      'id_tag': 1,
      'name': 'Test',
      'color': 'Color(0xFFedd353)'
    });

    batch.insert('tags', {
      'id_tag': 2,
      'name': 'Bug',
      'color': 'Color(0xffe35b5b)'
    });

    batch.insert('tasks_tags', {
      'id_task': 1,
      'id_tag': 2
    });

    batch.insert('tasks_tags', {
      'id_task': 1,
      'id_tag': 1
    });


    await batch.commit(noResult: true);

  }
}

