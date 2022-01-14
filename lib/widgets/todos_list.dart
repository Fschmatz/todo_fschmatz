import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/todo.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/todo_dao.dart';
import 'package:todo_fschmatz/pages/todos/edit_todo.dart';

class TodosList extends StatefulWidget {
  Function(int) changeCurrentTodo;
  int currentIdTodo;

  TodosList(
      {Key? key, required this.changeCurrentTodo, required this.currentIdTodo})
      : super(key: key);

  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  bool loadingTodos = true;
  final todos = TodoDao.instance;
  final tasks = TaskDao.instance;
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> _delete(int idTodo) async {
    final deleted = await todos.delete(idTodo);
    final del = await tasks.deleteAllTasksFromTodo(idTodo);
  }

  Future<void> getTodos() async {
    var resp = await todos.queryAllRows();
    setState(() {
      _todoList = resp;
      loadingTodos = false;
    });

    _todoList.toString();
  }

  showAlertDialogOkDelete(BuildContext context, idTodo) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        _delete(idTodo).then((value) => getTodos());
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: const Text(
        "Confirm", //
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "\nDelete ?",
        style: TextStyle(
          fontSize: 16,
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          key: UniqueKey(),
          //leading: const SizedBox.shrink(),
          title: Text(_todoList[index]['name'],
               style: _todoList[index]['id_todo'] == widget.currentIdTodo
                   ? TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w600)
                   : null
          ),
          onTap: () {
            widget.changeCurrentTodo(_todoList[index]['id_todo']);
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.of(context).pop();
            });
          },
        );
      },
    );
  }
}
