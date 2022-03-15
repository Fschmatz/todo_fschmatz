import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/tasks_tags_dao.dart';
import 'package:todo_fschmatz/pages/tasks/edit_task.dart';

import '../util/utils_functions.dart';

class TaskCard extends StatefulWidget {
  @override
  _TaskCardState createState() => _TaskCardState();

  Task task;
  Function() refreshHome;

  TaskCard({Key? key, required this.task, required this.refreshHome})
      : super(key: key);
}

class _TaskCardState extends State<TaskCard> {
  List<Map<String, dynamic>> tagsList = [];
  final tags = TagDao.instance;
  bool loadingTags = true;

  @override
  void initState() {
    super.initState();
    getTags();
  }

  void getTags() async {
    var resp = await tags.getTagsByName(widget.task.id);
    if (mounted) {
      setState(() {
        tagsList = resp;
        loadingTags = false;
      });
    }
  }

  void _delete() async {
    final tasks = TaskDao.instance;
    final tasksTags = TasksTagsDao.instance;
    final deleted = await tasks.delete(widget.task.id);
    final deletedTaskTag = await tasksTags.delete(widget.task.id);
  }

  void _changeTaskState(int state) async {
    final tasks = TaskDao.instance;
    Map<String, dynamic> row = {
      TaskDao.columnId: widget.task.id,
      TaskDao.columnState: state,
    };
    final update = await tasks.update(row);
  }

  void openBottomMenu() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  Visibility(
                    visible: widget.task.state != 0,
                    child: ListTile(
                      leading: const Icon(Icons.list_outlined),
                      title: const Text(
                        "Mark as todo",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        _changeTaskState(0);
                        widget.refreshHome();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.task.state != 0,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.task.state != 1,
                    child: ListTile(
                      leading: const Icon(Icons.construction_outlined),
                      title: const Text(
                        "Mark as doing",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        _changeTaskState(1);
                        widget.refreshHome();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.task.state != 1,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.task.state != 2,
                    child: ListTile(
                      leading: const Icon(Icons.checklist_outlined),
                      title: const Text(
                        "Mark as done",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        _changeTaskState(2);
                        widget.refreshHome();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.task.state != 2,
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => EditTask(
                              task: widget.task,
                              getAllTasksByState: widget.refreshHome,
                              refreshTags: getTags,
                            ),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_outlined),
                    title: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showAlertDialogOkDelete(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialogOkDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm",
          ),
          content: const Text(
            "Delete ?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () {
                _delete();
                widget.refreshHome();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness _tagTextBrightness = Theme.of(context).brightness;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: openBottomMenu,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                child: Text(widget.task.title,
                    style: const TextStyle(fontSize: 16)),
              ),
              Visibility(
                visible: widget.task.note.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    widget.task.note,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              tagsList.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                    spacing: 16.0,
                    children:
                        List<Widget>.generate(tagsList.length, (int index) {
                      return Chip(
                        key: UniqueKey(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(tagsList[index]['name']),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _tagTextBrightness == Brightness.dark
                              ? lightenColor(
                                  parseColorFromDb(
                                      tagsList[index]['color']),
                                  40)
                              : darkenColor(
                                  parseColorFromDb(
                                      tagsList[index]['color']),
                                  50),
                        ),
                        backgroundColor:
                            parseColorFromDb(tagsList[index]['color'])
                                .withOpacity(0.35),
                      );
                    }).toList(),
                  ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }
}
