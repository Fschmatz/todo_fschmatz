import 'package:todo_fschmatz/db/tasks/task_dao.dart';
import '../../classes/task.dart';
import '../tasks_tags/tasks_tags_dao.dart';

Future<int> saveTask(Task task) async {
  final tasks = TaskDao.instance;
  Map<String, dynamic> row = {
    TaskDao.columnTitle: task.title,
    TaskDao.columnNote: task.note,
    TaskDao.columnState: task.state,
    TaskDao.columnIdTodo: task.idTodo
  };
  int idNewTask = await tasks.insert(row);
  return idNewTask;
}

void updateTask(Task task) async {
  final tasks = TaskDao.instance;
  Map<String, dynamic> row = {
    TaskDao.columnId: task.id,
    TaskDao.columnTitle: task.title,
    TaskDao.columnNote: task.note,
  };
  await tasks.update(row);
}

void deleteTask(int taskId) async {
  final tasks = TaskDao.instance;
  final tasksTags = TasksTagsDao.instance;
  await tasks.delete(taskId);
  await tasksTags.deleteWithTaskId(taskId);
}

void changeTaskState(int taskId, int state) async {
  final tasks = TaskDao.instance;
  Map<String, dynamic> row = {
    TaskDao.columnId: taskId,
    TaskDao.columnState: state,
  };
  await tasks.update(row);
}