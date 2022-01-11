import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/todo.dart';
import 'package:todo_fschmatz/db/todo_dao.dart';
import 'package:todo_fschmatz/pages/todos/edit_todo.dart';
import 'package:todo_fschmatz/pages/todos/new_todo.dart';

class DialogTodosList extends StatefulWidget {

  Function() changeCurrentTodo;

  DialogTodosList({Key? key, required this.changeCurrentTodo}) : super(key: key);

  @override
  _DialogTodosListState createState() => _DialogTodosListState();
}

class _DialogTodosListState extends State<DialogTodosList> {

  bool loadingTodos = true;
  final todos = TodoDao.instance;
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> _delete(int idTodo) async {
    final deleted = await todos.delete(idTodo);
  }

  Future<void> getTodos() async {
    var resp = await todos.queryAllRows();
    setState(() {
      _todoList = resp;
      loadingTodos = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 25, 0, 24),
      title: const Text('Todos'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: const Text(
            "New Todo",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
              title: Text(_todoList[index]['name']),
              onTap: ()  {
                widget.changeCurrentTodo();
              },
              trailing:
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.delete_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .headline6!
                            .color!
                            .withOpacity(0.8),
                      ),
                      onPressed: () {
                        _delete(_todoList[index]['id_todo']).then((value) => getTodos());
                      }),
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
            // const Icon(Icons.edit_outlined));
          },
        ),
      ),
    );
  }
}
