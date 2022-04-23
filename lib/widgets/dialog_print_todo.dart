import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/db/task_dao.dart';

class DialogPrintTodo extends StatefulWidget {

  int todoId;
  String todoName;

  DialogPrintTodo({Key? key, required this.todoId, required this.todoName}) : super(key: key);

  @override
  _DialogPrintTodoState createState() => _DialogPrintTodoState();
}

class _DialogPrintTodoState extends State<DialogPrintTodo> {

  final dbTask = TaskDao.instance;
  bool loading = true;
  String formattedList = '';

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  void getTasks() async {
    List<Map<String, dynamic>> _listTasksTodo = await dbTask.queryAllByTodoAndStateDesc(0,widget.todoId);
    List<Map<String, dynamic>> _listTasksDoing = await dbTask.queryAllByTodoAndStateDesc(1,widget.todoId);
    List<Map<String, dynamic>> _listTasksDone = await dbTask.queryAllByTodoAndStateDesc(2,widget.todoId);

    formattedList += widget.todoName + '\n';
    formattedList += '\nTodo\n';
    for (int i = 0; i < _listTasksTodo.length; i++) {
      formattedList += "• " + _listTasksTodo[i]['title'] + "\n";
    }
    formattedList += '\nDoing\n';
    for (int i = 0; i < _listTasksDoing.length; i++) {
      formattedList += "• " + _listTasksDoing[i]['title'] + "\n";
    }
    formattedList += '\nDone\n';
    for (int i = 0; i < _listTasksDone.length; i++) {
      formattedList += "• " + _listTasksDone[i]['title'] + "\n";
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: const Text('Task List'),
      scrollable: true,
      content: SizedBox(
          height: 250.0,
          width: 350.0,
          child: loading
              ? const SizedBox.shrink()
              : SelectableText(formattedList)),
      actions: [
        TextButton(
          child: const Text(
            "Close",
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            "Copy",
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: formattedList));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
