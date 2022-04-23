import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/todo.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/todo_dao.dart';
import 'package:todo_fschmatz/pages/todos/edit_todo.dart';
import 'package:todo_fschmatz/pages/todos/new_todo.dart';

import '../../widgets/dialog_print_todo.dart';

class TodosManager extends StatefulWidget {
  int currentIdTodo;

  TodosManager({Key? key, required this.currentIdTodo}) : super(key: key);

  @override
  _TodosManagerState createState() => _TodosManagerState();
}

class _TodosManagerState extends State<TodosManager> {
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
    var resp = await todos.queryAllRowsByName();
    setState(() {
      _todoList = resp;
      loadingTodos = false;
    });
    _todoList.toString();
  }

  showAlertDialogOkDelete(BuildContext context, idTodo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm",
          ),
          content: const Text(
            "Delete ?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () {
                _delete(idTodo).then((value) => getTodos());
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Todos"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_outlined,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const NewTodo(),
                    fullscreenDialog: true,
                  )).then((value) => getTodos());
            },
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder:
            (BuildContext context, int index) =>
        const SizedBox(
          height: 5,
        ),
        shrinkWrap: true,
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 3, 10, 3),
              key: UniqueKey(),
              title: Text(_todoList[index]['name'],
                style: TextStyle(
                  color: _todoList[index]['id_todo'] == widget.currentIdTodo
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  fontWeight: _todoList[index]['id_todo'] == widget.currentIdTodo
                      ? FontWeight.w600
                      : null
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _todoList.length > 1 &&
                          _todoList[index]['id_todo'] != widget.currentIdTodo
                      ? IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                          ),
                          onPressed: () {
                            showAlertDialogOkDelete(
                                context, _todoList[index]['id_todo']);
                          })
                      : const SizedBox.shrink(),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.print_outlined,
                      ),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogPrintTodo(
                              todoName: _todoList[index]['name'],
                                todoId: _todoList[index]['id_todo']
                            );
                          }),
                  )
                     ,
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
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
            ),
          );
        },
      ),
    );
  }
}
