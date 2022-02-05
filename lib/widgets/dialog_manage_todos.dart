import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/todo.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/todo_dao.dart';
import 'package:todo_fschmatz/pages/todos/edit_todo.dart';
import 'package:todo_fschmatz/pages/todos/new_todo.dart';

class DialogManageTodos extends StatefulWidget {
  int currentIdTodo;

  DialogManageTodos({Key? key,required this.currentIdTodo}) : super(key: key);

  @override
  _DialogManageTodosState createState() => _DialogManageTodosState();
}

class _DialogManageTodosState extends State<DialogManageTodos> {

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

  showAlertDialogOkDelete(BuildContext context,idTodo) {
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 25, 0, 24),
      title: const Text('Manage Todos'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: const Text(
            "New Todo",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const NewTodo(),
                  fullscreenDialog: true,
                )).then((value) => getTodos());
          },
        ),
        TextButton(
          child: const Text(
            "Close",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      content: SizedBox(
        height: 330.0,
        width: 350.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              key: UniqueKey(),
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
              title: Text(_todoList[index]['name']),
              onTap: ()  { },
              trailing:
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _todoList.length > 1 && _todoList[index]['id_todo'] != widget.currentIdTodo ? IconButton(
                      icon: Icon(
                        Icons.delete_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .headline6!
                            .color!
                            .withOpacity(0.8),
                      ),
                      onPressed: () {
                        showAlertDialogOkDelete(context,_todoList[index]['id_todo']);
                      }) : const SizedBox.shrink(),
                  const SizedBox(width: 5,),
                  IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .headline6!
                            .color!
                            .withOpacity(0.8),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => EditTodo(
                                todo: Todo(
                                  _todoList[index]['id_todo'],
                                  _todoList[index]['name'],
                                ),
                              ),
                              fullscreenDialog: true,
                            )).then((value) => getTodos());
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
