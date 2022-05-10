import 'package:todo_fschmatz/db/tags/tag_dao.dart';
import '../../classes/tag.dart';
import '../tasks_tags/tasks_tags_dao.dart';

void saveTag(Tag tag) async {
  final tags = TagDao.instance;
  Map<String, dynamic> row = {
    TagDao.columnName: tag.name,
    TagDao.columnColor: tag.color,
  };
  await tags.insert(row);
}

void updateTag(Tag tag) async {
  final tags = TagDao.instance;
  Map<String, dynamic> row = {
    TagDao.columnId: tag.id,
    TagDao.columnName: tag.name,
    TagDao.columnColor: tag.color,
  };
  await tags.update(row);
}

void deleteTag(int idTag) async {
  final tags = TagDao.instance;
  final tasksTags = TasksTagsDao.instance;
  await tags.delete(idTag);
  await tasksTags.deleteWithTagId(idTag);
}