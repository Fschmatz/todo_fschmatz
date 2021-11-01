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

  TaskCard({Key? key, required this.task, required this.refreshHome}) : super(key: key);
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
    setState(() {
      tagsList = resp;
      loadingTags = false;
    });
  }

  Future<void> _delete() async {
    final tasks = TaskDao.instance;
    final deleted = await tasks.delete(widget.task.id);
  }

  Future<void> _changeState() async {
    /* final dbNotes = NoteDao.instance;
    Map<String, dynamic> row = {
      NoteDao.columnId: widget.note.id,
      NoteDao.columnPinned: widget.note.pinned == 0 ? 1 : 0,
    };
    final update = await dbNotes.update(row);*/
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
                            builder: (BuildContext context) => const EditTask(),
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
          children: <Widget>[
            ListTile(
              title: Text(widget.task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            Visibility(
              visible: widget.task.note.isNotEmpty,
              child: ListTile(
                title: Text(
                  widget.task.note,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .textTheme
                        .headline6!
                        .color!
                        .withOpacity(0.8),
                  ),
                ),
              ),
            ),
            tagsList.isEmpty ? const SizedBox.shrink() : Align(
              alignment: FractionalOffset.topCenter,
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(10, 0, 16, 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tagsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 30,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Chip(
                      label: Text(tagsList[index]['name']),
                      backgroundColor: Color(int.parse(tagsList[index]['color'].substring(6, 16))),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
