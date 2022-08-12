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
    List<Map<String, dynamic>> listTasksTodo =
        await dbTask.queryAllByTodoAndStateDesc(0, widget.todoId);
    List<Map<String, dynamic>> listTasksDoing =
        await dbTask.queryAllByTodoAndStateDesc(1, widget.todoId);
    List<Map<String, dynamic>> listTasksDone =
        await dbTask.queryAllByTodoAndStateDesc(2, widget.todoId);

    formattedList += widget.todoName + '\n';

    formattedList += '\nTO DO - '+listTasksTodo.length.toString()+' tasks\n';
    for (int i = 0; i < listTasksTodo.length; i++) {
      if(listTasksTodo[i]['note'].toString().isNotEmpty) {
        formattedList += "\n• " + listTasksTodo[i]['title']+"\n";
        formattedList += listTasksTodo[i]['note'];
      } else {
        formattedList += "\n• " + listTasksTodo[i]['title'];
      }
      formattedList += '\n\n****************************\n';
    }

    formattedList += '\n\nIN PROGRESS - '+listTasksDoing.length.toString()+' tasks\n';
    for (int i = 0; i < listTasksDoing.length; i++) {
      if(listTasksDoing[i]['note'].toString().isNotEmpty) {
        formattedList += "\n• " + listTasksDoing[i]['title']+"\n";
        formattedList += listTasksDoing[i]['note'];
      } else {
        formattedList += "\n• " + listTasksDoing[i]['title'];
      }
      formattedList += '\n\n****************************\n';
    }

    formattedList += '\n\nDONE - '+listTasksDone.length.toString()+' tasks\n';
    for (int i = 0; i < listTasksDone.length; i++) {
      if(listTasksDone[i]['note'].toString().isNotEmpty) {
        formattedList += "\n• " + listTasksDone[i]['title']+"\n";
        formattedList += listTasksDone[i]['note'];
      } else {
        formattedList += "\n• " + listTasksDone[i]['title'];
      }
      formattedList += '\n\n****************************\n';
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
