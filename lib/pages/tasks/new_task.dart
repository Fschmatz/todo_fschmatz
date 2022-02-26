import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/tasks_tags_dao.dart';
import 'package:todo_fschmatz/widgets/dialog_alert_error.dart';

import '../../util/utils_functions.dart';

class NewTask extends StatefulWidget {

  int state;
  int currentIdTodo;
  Function() getAllTasksByState;

  NewTask({Key? key, required this.state, required this.getAllTasksByState, required this.currentIdTodo})
      : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
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
    getAllTags();
  }

  Future<void> getAllTags() async {
    var resp = await tags.queryAllRowsByName();
    setState(() {
      tagsList = resp;
      loadingTags = false;
    });
  }

  Future<void> _saveTask() async {
    Map<String, dynamic> row = {
      TaskDao.columnTitle: customControllerTitle.text,
      TaskDao.columnNote: customControllerNote.text,
      TaskDao.columnState: widget.state,
      TaskDao.columnIdTodo: widget.currentIdTodo
    };
    final idTask = await tasks.insert(row);

    if (selectedTags.isNotEmpty) {
      for (int i = 0; i < selectedTags.length; i++) {
        Map<String, dynamic> rowsTaskTags = {
          TasksTagsDao.columnIdTask: idTask,
          TasksTagsDao.columnIdTag: selectedTags[i],
        };
        final idsTaskTags = await tasksTags.insert(rowsTaskTags);
      }
    }
  }

  String checkForErrors() {
    String errors = "";
    if (customControllerTitle.text.isEmpty) {
      errors += "Task title is empty\n";
    }
    return errors;
  }

  @override
  Widget build(BuildContext context) {

    final Brightness _tagTextBrightness = Theme.of(context).brightness;

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Task"),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () {
                  String errors = checkForErrors();
                  if (errors.isEmpty) {
                    _saveTask()
                        .then((value) => widget.getAllTasksByState())
                        .then((value) => Navigator.of(context).pop());
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return dialogAlertErrors(errors, context);
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
              maxLines: 5,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
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
              maxLines: 10,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
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
          ListTile(
            leading: const Icon(
              Icons.label_outline_rounded,
            ),
            title: tagsList.isEmpty
                ? const SizedBox.shrink()
                : Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 16.0,
                      alignment: WrapAlignment.start,
                      children:
                          List<Widget>.generate(tagsList.length, (int index) {
                        return ChoiceChip(
                          key: UniqueKey(),
                          selected: false,
                          avatar:
                              selectedTags.contains(tagsList[index]['id_tag'])
                                  ? Icon(
                                      Icons.done,
                                color: _tagTextBrightness == Brightness.dark ?
                                lightenColor(parseColorFromDb(
                                    tagsList[index]['color']),40)
                                    : darkenColor(parseColorFromDb(
                                    tagsList[index]['color']),50),
                                      size: 18,
                                    )
                                  : null,
                          onSelected: (bool _selected) {
                            if (selectedTags
                                .contains(tagsList[index]['id_tag'])) {
                              selectedTags.remove(tagsList[index]['id_tag']);
                            } else {
                              selectedTags.add(tagsList[index]['id_tag']);
                            }
                            setState(() {});
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          label: Text(tagsList[index]['name']),
                          labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _tagTextBrightness == Brightness.dark ?
                              lightenColor(parseColorFromDb(
                                  tagsList[index]['color']),40)
                                  : darkenColor(parseColorFromDb(
                                  tagsList[index]['color']),50),
                             ),
                          backgroundColor: selectedTags
                                  .contains(tagsList[index]['id_tag'])
                              ? parseColorFromDb(
                              tagsList[index]['color']).withOpacity(0.4)
                              : parseColorFromDb(
                              tagsList[index]['color'])
                                  .withOpacity(0.2),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ]));
  }
}
