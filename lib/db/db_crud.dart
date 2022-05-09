import 'package:todo_fschmatz/classes/todo.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/tasks_tags_dao.dart';
import 'package:todo_fschmatz/db/todo_dao.dart';
import '../classes/tag.dart';


//TESTAR MANTENDO O Future<void> nos calls das classes
//TBM POSSO ENCADEIAR OS CHAMADOS AO INVES DE REPETIR
//TODO
void saveTodo(Todo todo) async {
  final todos = TodoDao.instance;
  Map<String, dynamic> row = {
    TodoDao.columnName: todo.name,
  };
  final id = await todos.insert(row);
}

void updateTodo(Todo todo) async {
  final todos = TodoDao.instance;
  Map<String, dynamic> row = {
    TodoDao.columnId: todo.id,
    TodoDao.columnName: todo.name,
  };
  final update = await todos.update(row);
}

void deleteTodo(int idTodo) async {
  final todos = TodoDao.instance;
  final tasks = TaskDao.instance;
  final tasksTags = TasksTagsDao.instance;
  final deleted = await todos.delete(idTodo);
  final del = await tasks.deleteAllTasksFromTodo(idTodo);
  //PRECISO AJEITAR PARA DELETAR DO TASKS_TAGS
  //final deletedTaskTag = await tasksTags.deleteWithTagId(idTag);
}

//TAGS
void saveTag(Tag tag) async {
  final tags = TagDao.instance;
  Map<String, dynamic> row = {
    TagDao.columnName: tag.name,
    TagDao.columnColor: tag.color,
  };
  final id = await tags.insert(row);
}

void updateTag(Tag tag) async {
  final tags = TagDao.instance;
  Map<String, dynamic> row = {
    TagDao.columnId: tag.id,
    TagDao.columnName: tag.name,
    TagDao.columnColor: tag.color,
  };
  final update = await tags.update(row);
}

void deleteTag(int idTag) async {
  final tags = TagDao.instance;
  final tasksTags = TasksTagsDao.instance;
  final deleted = await tags.delete(idTag);
  final deletedTaskTag = await tasksTags.deleteWithTagId(idTag);
}

//TASKS



//TASKS_TAGS