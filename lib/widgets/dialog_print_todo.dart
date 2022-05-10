import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/db/tasks/task_dao.dart';

class DialogPrintTodo extends StatefulWidget {
  int todoId;
  String todoName;

  DialogPrintTodo({Key? key, required this.todoId, required this.todoName})
      : super(key: key);

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
    List<Map<String, dynamic>> _listTasksTodo =
        await dbTask.queryAllByTodoAndStateDesc(0, widget.todoId);
    List<Map<String, dynamic>> _listTasksDoing =
        await dbTask.queryAllByTodoAndStateDesc(1, widget.todoId);
    List<Map<String, dynamic>> _listTasksDone =
        await dbTask.queryAllByTodoAndStateDesc(2, widget.todoId);

    formattedList += widget.todoName + '\n';

    formattedList += '\nTODO - '+_listTasksTodo.length.toString()+' tasks\n';
    for (int i = 0; i < _listTasksTodo.length; i++) {
      if(_listTasksTodo[i]['note'].toString().isNotEmpty) {
        formattedList += "\n• " + _listTasksTodo[i]['title']+"\n";
        formattedList += _listTasksTodo[i]['note'];
      } else {
        formattedList += "\n• " + _listTasksTodo[i]['title'];
      }
    }

    formattedList += '\n\nDOING - '+_listTasksDoing.length.toString()+' tasks\n';
    for (int i = 0; i < _listTasksDoing.length; i++) {
      if(_listTasksDoing[i]['note'].toString().isNotEmpty) {
        formattedList += "\n• " + _listTasksDoing[i]['title']+"\n";
        formattedList += _listTasksDoing[i]['note'];
      } else {
        formattedList += "\n• " + _listTasksDoing[i]['title'];
      }
    }

    formattedList += '\n\nDONE - '+_listTasksDone.length.toString()+' tasks\n';
    for (int i = 0; i < _listTasksDone.length; i++) {
      if(_listTasksDone[i]['note'].toString().isNotEmpty) {
        formattedList += "\n• " + _listTasksDone[i]['title']+"\n";
        formattedList += _listTasksDone[i]['note'];
      } else {
        formattedList += "\n• " + _listTasksDone[i]['title'];
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Todo'),
        actions: [
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
        children: [
          loading
              ? const SizedBox.shrink()
              : SelectableText(
                  formattedList,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
