import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTask extends StatefulWidget {


  const EditTask(
      {Key? key})
      : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  //final dbNotes = NoteDao.instance;
  TextEditingController customControllerTitle = TextEditingController();
  TextEditingController customControllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _updateNote() async {
    Map<String, dynamic> row = {
     /* NoteDao.columnId: widget.noteEdit.id,
      NoteDao.columnTitle: customControllerTitle.text,
      NoteDao.columnText: customControllerText.text,
      NoteDao.columnPinned: widget.noteEdit.pinned*/
    };
    //final update = await dbNotes.update(row);
  }

  String checkProblems() {
    String errors = "";
    if (customControllerTitle.text.isEmpty) {
      errors += "Note is empty\n";
    }
    return errors;
  }

  showAlertDialogErrors(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text(
        "Ok",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "Error",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(
        checkProblems(),
        style: const TextStyle(
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Task"),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () {
                  if (checkProblems().isEmpty) {
                    _updateNote();
                    Navigator.of(context).pop();
                  } else {
                    showAlertDialogErrors(context);
                  }
                },
              ),
            ),
          ],
        ),
        body: ListView(children: [
          ListTile(
            leading: const SizedBox(
              height: 0.1,
            ),
            title: Text("Title".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          ListTile(
            leading: const Icon(Icons.notes_outlined),
            title: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerTitle,
              decoration: InputDecoration(
                focusColor: Theme.of(context).colorScheme.secondary,
                helperText: "* Required",
              ),
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          ListTile(
            leading: const SizedBox(
              height: 0.1,
            ),
            title: Text("Note".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: TextField(
              minLines: 1,
              maxLines: 12,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerNote,
              decoration: InputDecoration(
                focusColor: Theme.of(context).colorScheme.secondary,
              ),
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ]));
  }
}
