import 'package:todo_fschmatz/db/tasks_tags/tasks_tags_dao.dart';

void saveTaskTag(int idTask,int selectedTag) async{
  final tasksTags = TasksTagsDao.instance;
  Map<String, dynamic> rowsTaskTags = {
    TasksTagsDao.columnIdTask: idTask,
    TasksTagsDao.columnIdTag: selectedTag,
  };
  await tasksTags.insert(rowsTaskTags);
}
