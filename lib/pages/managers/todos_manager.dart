import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/todo.dart';
import 'package:todo_fschmatz/db/todos/todo_dao.dart';
import 'package:todo_fschmatz/pages/todos/edit_todo.dart';
import 'package:todo_fschmatz/pages/todos/new_todo.dart';
import '../../db/todos/todo_controller.dart';
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
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> _delete(int idTodo) async {
    deleteTodo(idTodo);
  }

  Future<void> getTodos() async {
    var resp = await todos.queryAllByName();
    setState(() {
      _todoList = resp;
      loadingTodos = false;
    });
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
      ),
      body:ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todoList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                key: UniqueKey(),
                title: Text(
                  _todoList[index]['name'],
                  style: TextStyle(
                      color: _todoList[index]['id_todo'] == widget.currentIdTodo
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight:
                          _todoList[index]['id_todo'] == widget.currentIdTodo
                              ? FontWeight.w600
                              : null),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _todoList.length > 1 &&
                            _todoList[index]['id_todo'] != widget.currentIdTodo
                        ? IconButton(
                            icon: const Icon(
                              Icons.delete_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              showAlertDialogOkDelete(
                                  context, _todoList[index]['id_todo']);
                            })
                        : const SizedBox.shrink(),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.print_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => DialogPrintTodo(
                                    todoName: _todoList[index]['name'],
                                    todoId: _todoList[index]['id_todo']),
                              ));
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => EditTodo(
                                  todo: Todo(
                                    _todoList[index]['id_todo'],
                                    _todoList[index]['name'],
                                  ),
                                ),
                              )).then((value) => getTodos());
                        }),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const NewTodo(),
              )).then((value) => getTodos());
        },
        child: Icon(
          Icons.add_outlined,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
