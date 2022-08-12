import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/tags/tag_dao.dart';
import 'package:todo_fschmatz/db/tasks_tags/tasks_tags_dao.dart';
import '../../db/tasks/task_controller.dart';
import '../../db/tasks_tags/tasks_tags_controller.dart';
import '../../util/utils_functions.dart';

class EditTask extends StatefulWidget {
  Task task;
  Function() getAllTasksByState;
  Function() refreshTags;

  EditTask(
      {Key? key,
      required this.task,
      required this.getAllTasksByState,
      required this.refreshTags})
      : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController customControllerTitle = TextEditingController();
  TextEditingController customControllerNote = TextEditingController();
  final tags = TagDao.instance;
  final tasksTags = TasksTagsDao.instance;
  bool loadingTags = true;
  List<Map<String, dynamic>> tagsList = [];
  List<int> selectedTags = [];
  List<int> tagsFromDbTask = [];
  bool _validTitle = true;

  @override
  void initState() {
    super.initState();
    customControllerTitle.text = widget.task.title;
    customControllerNote.text = widget.task.note;
    getAllTags().then((value) => getTagsFromTask());
  }

  Future<void> getAllTags() async {
    var resp = await tags.queryAllRowsByName();
    setState(() {
      tagsList = resp;
    });
  }

  void getTagsFromTask() async {
    var resp = await tasksTags.queryTagsFromTaskId(widget.task.id);
    for (int i = 0; i < resp.length; i++) {
      tagsFromDbTask.add(resp[i]['id_tag']);
    }
    setState(() {
      selectedTags = tagsFromDbTask;
      loadingTags = false;
    });
  }

  Future<void> _updateTask() async {
    await tasksTags.deleteWithTaskId(widget.task.id);

    updateTask(Task(widget.task.id, customControllerTitle.text,
        customControllerNote.text, 0, 0));

    if (selectedTags.isNotEmpty) {
      for (int i = 0; i < selectedTags.length; i++) {
        saveTaskTag(widget.task.id, selectedTags[i]);
      }
    }
  }

  bool validateTextFields() {
    if (customControllerTitle.text.isEmpty) {
      _validTitle = false;
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Brightness tagTextBrightness = Theme.of(context).brightness;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Task"),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save',
              onPressed: () {
                if (validateTextFields()) {
                  _updateTask()
                      .then((v) => {
                            widget.getAllTasksByState(),
                            widget.refreshTags(),
                          })
                      .then((v) => Navigator.of(context).pop());
                } else {
                  setState(() {
                    _validTitle;
                  });
                }
              },
            ),
          ],
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              minLines: 1,
              maxLines: null,
              maxLength: 250,
              textCapitalization: TextCapitalization.sentences,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerTitle,
              decoration: InputDecoration(
                  labelText: "Title",
                  //counterText: "",
                  errorText: _validTitle ? null : "Title is empty"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              minLines: 1,
              maxLines: null,
              maxLength: 600,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              controller: customControllerNote,
              decoration: const InputDecoration(
                labelText: "Note",
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 16, 12),
            child: Text(
              'Add tags',
              style:
                  TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: tagsList.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 5.0,
                    children:
                        List<Widget>.generate(tagsList.length, (int index) {
                      return FilterChip(
                        key: UniqueKey(),
                        selected: false,
                        onSelected: (bool selected) {
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
                            side: BorderSide(
                                width: 2,
                                color: selectedTags
                                    .contains(tagsList[index]['id_tag'])
                                    ? parseColorFromDb(tagsList[index]['color'])
                                    .withOpacity(0.1)
                                    : parseColorFromDb(tagsList[index]['color'])
                                    .withOpacity(0.1))),
                        label: Text(tagsList[index]['name']),
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              selectedTags.contains(tagsList[index]['id_tag'])
                                  ? tagTextBrightness == Brightness.dark
                                      ? lightenColor(
                                          parseColorFromDb(
                                              tagsList[index]['color']),
                                          40)
                                      : darkenColor(
                                          parseColorFromDb(
                                              tagsList[index]['color']),
                                          50)
                                  : parseColorFromDb(tagsList[index]['color'])
                                      .withOpacity(0.8),
                        ),
                        backgroundColor:
                            selectedTags.contains(tagsList[index]['id_tag'])
                                ? parseColorFromDb(tagsList[index]['color'])
                                    .withOpacity(0.4)
                                : Theme.of(context)
                                    .cardTheme
                                    .color!
                                    .withOpacity(0.5),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(
            height: 50,
          )
        ]));
  }
}
