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

  NewTask(
      {Key? key,
      required this.state,
      required this.getAllTasksByState,
      required this.currentIdTodo})
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

  void _loseFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness _tagTextBrightness = Theme.of(context).brightness;

    return GestureDetector(
      onTap: () {
        _loseFocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("New Task"),
            actions: [
              IconButton(
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
            ],
          ),
          body: ListView(children: [
            ListTile(
              title: Text("Title",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            ListTile(
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
                  prefixIcon: const Icon(Icons.notes_outlined),
                ),
              ),
            ),
            ListTile(
              title: Text("Note",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            ListTile(
              title: TextField(
                minLines: 1,
                maxLines: 10,
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                controller: customControllerNote,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.secondary,
                  prefixIcon: const Icon(
                    Icons.article_outlined,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("Tags",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            ListTile(
              title: tagsList.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children:
                        List<Widget>.generate(tagsList.length, (int index) {
                      return ChoiceChip(
                        key: UniqueKey(),
                        selected: false,
                        onSelected: (bool _selected) {
                          if (selectedTags
                              .contains(tagsList[index]['id_tag'])) {
                            selectedTags.remove(tagsList[index]['id_tag']);
                          } else {
                            selectedTags.add(tagsList[index]['id_tag']);
                          }
                          setState(() {});
                        },
                        avatar: selectedTags
                                .contains(tagsList[index]['id_tag'])
                            ? Icon(
                                Icons.check_box_outlined,
                                color: _tagTextBrightness == Brightness.dark
                                    ? lightenColor(
                                        parseColorFromDb(
                                            tagsList[index]['color']),
                                        40)
                                    : darkenColor(
                                        parseColorFromDb(
                                            tagsList[index]['color']),
                                        50),
                              )
                            : Icon(
                                Icons.check_box_outline_blank_outlined,
                                color: parseColorFromDb(
                                        tagsList[index]['color'])
                                    .withOpacity(0.2),
                              ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                          child: Text(tagsList[index]['name']),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
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
                            selectedTags.contains(tagsList[index]['id_tag'])
                                ? parseColorFromDb(tagsList[index]['color'])
                                    .withOpacity(0.4)
                                : parseColorFromDb(tagsList[index]['color'])
                                    .withOpacity(0.15),
                      );
                    }).toList(),
                  ),
            ),
            const SizedBox(
              height: 50,
            )
          ])),
    );
  }
}
