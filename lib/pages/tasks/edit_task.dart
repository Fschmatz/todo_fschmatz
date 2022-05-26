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
    String errors = "";
    if (customControllerTitle.text.isEmpty) {
      errors += "Title";
      _validTitle = false;
    }
    return errors.isEmpty ? true : false;
  }

  void _loseFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness tagTextBrightness = Theme.of(context).brightness;

    return GestureDetector(
      onTap: () {
        _loseFocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Edit Task"),
            actions: [
              IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () {
                  if (validateTextFields()) {
                    _updateTask()
                        .then((value) => {
                              widget.getAllTasksByState(),
                              widget.refreshTags(),
                            })
                        .then((value) => Navigator.of(context).pop());
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
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                maxLength: 300,
                textCapitalization: TextCapitalization.sentences,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: customControllerTitle,
                decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    hintText: "Title",
                    counterText: "",
                    errorText: _validTitle ? null : "Title is empty"),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                minLines: 1,
                maxLines: 10,
                maxLength: 600,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                controller: customControllerNote,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  counterText: "",
                  hintText: "Note",
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
              child: Text('Select tags:',
                style:
                    TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: tagsList.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children:
                          List<Widget>.generate(tagsList.length, (int index) {
                        return ChoiceChip(
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
                          avatar: selectedTags
                                  .contains(tagsList[index]['id_tag'])
                              ? Icon(
                                  Icons.check_box_outlined,
                                  color: tagTextBrightness == Brightness.dark
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
                                  color:
                                      parseColorFromDb(tagsList[index]['color'])
                                          .withOpacity(0.2),
                                ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          label: Text(tagsList[index]['name']),
                          labelPadding: const EdgeInsets.fromLTRB(0, 7, 15, 7),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: tagTextBrightness == Brightness.dark
                                ? lightenColor(
                                    parseColorFromDb(tagsList[index]['color']),
                                    40)
                                : darkenColor(
                                    parseColorFromDb(tagsList[index]['color']),
                                    50),
                          ),
                          backgroundColor:
                              selectedTags.contains(tagsList[index]['id_tag'])
                                  ? parseColorFromDb(tagsList[index]['color'])
                                      .withOpacity(0.4)
                                  : parseColorFromDb(tagsList[index]['color'])
                                      .withOpacity(0.10),
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
