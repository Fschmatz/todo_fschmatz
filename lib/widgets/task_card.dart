import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/pages/tasks/edit_task.dart';

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

  Future<void> getTags() async {
    var resp = await tags.getTags(widget.task.id);
    if (mounted) {
      setState(() {
        tagsList = resp;
        loadingTags = false;
      });
    }
  }

  Future<void> _delete() async {
    final tasks = TaskDao.instance;
    final deleted = await tasks.delete(widget.task.id);
  }

  Future<void> _changeTaskState(int state) async {
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
                      leading: Icon(Icons.list_outlined,
                          color: Theme.of(context).hintColor),
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
                      leading: Icon(Icons.construction_outlined,
                          color: Theme.of(context).hintColor),
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
                      leading: Icon(Icons.checklist_outlined,
                          color: Theme.of(context).hintColor),
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
                    leading: Icon(Icons.edit_outlined,
                        color: Theme.of(context).hintColor),
                    title: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => EditTask(task: widget.task, refreshHome: widget.refreshHome,),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.delete_outline_outlined,
                        color: Theme.of(context).hintColor),
                    title: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
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
    Widget okButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        _delete();
        widget.refreshHome();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: const Text(
        "Confirm", //
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "\nDelete ?",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: openBottomMenu,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
            ),
            Visibility(
              visible: widget.task.note.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                    widget.task.note,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
              ),

            ),
            tagsList.isEmpty
                ? const SizedBox.shrink()
                : Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                      spacing: 0.0,
                      runSpacing: 0.0,
                      alignment:  WrapAlignment.start,
                      children: List<Widget>.generate(
                          tagsList.length,
                          (int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16,right: 10),
                          child: Chip(
                            label: Text(tagsList[index]['name']),
                              labelStyle: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black87),
                            backgroundColor: Color(int.parse(
                                tagsList[index]['color'].substring(6, 16))).withOpacity(0.9),
                          ),
                        );
                      }).toList(),
                    ),
                ),
            SizedBox(height: tagsList.isEmpty ? 8 : 12)
          ],
        ),
      ),
    );
  }
}
