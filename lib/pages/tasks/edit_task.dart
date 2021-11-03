import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/tasks_tags_dao.dart';
import 'package:todo_fschmatz/widgets/dialog_alert_error.dart';

class EditTask extends StatefulWidget {

  Task task;
  Function() refreshHome;
  EditTask({Key? key, required this.task,required this.refreshHome}) : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  TextEditingController customControllerTitle = TextEditingController();
  TextEditingController customControllerNote = TextEditingController();
  final tasks = TaskDao.instance;
  final tags = TagDao.instance;
  final tasksTags = TasksTagsDao.instance;
  bool loadingTags = true;
  List<Map<String, dynamic>> tagsList = [];
  List<int> selectedTags = [];

  @override
  void initState() {
    super.initState();
    customControllerTitle.text = widget.task.title;
    customControllerNote.text = widget.task.note;
    getTags();
  }

  Future<void> getTags() async {
    var resp = await tags.queryAllRows();
    setState(() {
      tagsList = resp;
      loadingTags = false;
    });
  }

  void _updateTask() async {
    Map<String, dynamic> row = {
      TaskDao.columnId: widget.task.id,
      TaskDao.columnTitle: customControllerTitle.text,
      TaskDao.columnNote: customControllerNote.text,
    };
    final update = await tasks.update(row);

    if (selectedTags.isNotEmpty) {
      for (int i = 0; i < selectedTags.length; i++){
        Map<String, dynamic> rowsTaskTags = {
          TasksTagsDao.columnIdTask: update,
          TasksTagsDao.columnIdTag: selectedTags[i],
        };
        final idsTaskTags = await tasksTags.insert(rowsTaskTags);
      }
    }
  }

  String checkForErrors() {
    String errors = "";
    if (customControllerTitle.text.isEmpty) {
      errors += "Note is empty\n";
    }
    return errors;
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
                  String errors = checkForErrors();
                  if (errors.isEmpty) {
                    _updateTask();
                    widget.refreshHome();
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  dialogAlertErrors(errors,context);
                      },
                    );
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
              autofocus: true,
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
            leading:const Icon(Icons.article_outlined),
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
          ListTile(
            leading: const SizedBox(
              height: 0.1,
            ),
            title: Text("Tags".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 55),
            child: tagsList.isEmpty
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
                        child: ChoiceChip(
                          key: UniqueKey(),
                          selected: false,
                          onSelected: (bool selected) {
                            if(selectedTags.contains(tagsList[index]['id_tag'])){
                              selectedTags.remove(tagsList[index]['id_tag']);
                            }
                            else {
                              selectedTags.add(tagsList[index]['id_tag']);
                            }
                            print(tagsList[index]['id_tag'].toString());
                            print(selectedTags.toString());
                          },
                          label: Text(tagsList[index]['name']),
                          labelStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                          backgroundColor: Color(int.parse(
                              tagsList[index]['color'].substring(6, 16))),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ]));
  }
}
