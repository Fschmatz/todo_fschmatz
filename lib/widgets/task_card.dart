import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/pages/edit_task.dart';

class TaskCard extends StatefulWidget {
  @override
  _TaskCardState createState() => _TaskCardState();

  Task task;
  /*Function() refreshHome;
  Function(int, String, String) createNotification;
  Function(int) dismissNotification;*/

  TaskCard(
      {Key? key,required this.task})
      : super(key: key);
}

class _TaskCardState extends State<TaskCard> {

  Future<void> _delete() async {
  /*  final dbDayNotes = NoteDao.instance;
    final deleted = await dbDayNotes.delete(widget.note.id!);*/
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
                      "Edit note",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => EditTask(

                            ),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.delete_outline_outlined,
                        color: Theme.of(context).hintColor),
                    title: const Text(
                      "Delete note",
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
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        _delete();

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: openBottomMenu,
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
                title: Text(widget.task.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: SizedBox(
                    width: 55,
                    child: TextButton(
                      onPressed: () {

                      },
                      child: const Icon(
                        Icons.push_pin_outlined,

                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,

                        onPrimary: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.task.note!.isNotEmpty,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
