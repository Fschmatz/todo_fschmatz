import 'package:todo_fschmatz/db/todos/todo_dao.dart';
import '../../classes/todo.dart';
import '../tasks/task_dao.dart';
import '../tasks_tags/tasks_tags_dao.dart';

void saveTodo(Todo todo) async {
  final todos = TodoDao.instance;
  Map<String, dynamic> row = {
    TodoDao.columnName: todo.name,
  };
  await todos.insert(row);
}

void updateTodo(Todo todo) async {
  final todos = TodoDao.instance;
  Map<String, dynamic> row = {
    TodoDao.columnId: todo.id,
    TodoDao.columnName: todo.name,
  };
  await todos.update(row);
}

void deleteTodo(int idTodo) async {
  final todos = TodoDao.instance;
  final tasks = TaskDao.instance;
  final tasksTags = TasksTagsDao.instance;

  await todos.delete(idTodo);
  List<Map<String, dynamic>> tasksList = await tasks.queryAllByTodo(idTodo);
  for (int i = 0; i < tasksList.length; i++) {
    tasksTags.deleteWithTaskId(tasksList[i]['id_task']);
  }
  await tasks.deleteAllTasksFromTodo(idTodo);
}
