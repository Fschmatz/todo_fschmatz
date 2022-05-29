import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/todo.dart';
import 'package:todo_fschmatz/db/tasks/task_dao.dart';
import 'package:todo_fschmatz/db/todos/todo_dao.dart';
import 'package:todo_fschmatz/pages/todos/edit_todo.dart';

class DrawerTodoList extends StatefulWidget {
  Function(int) changeCurrentTodo;
  int currentIdTodo;

  DrawerTodoList(
      {Key? key, required this.changeCurrentTodo, required this.currentIdTodo})
      : super(key: key);

  @override
  _DrawerTodoListState createState() => _DrawerTodoListState();
}

class _DrawerTodoListState extends State<DrawerTodoList> {
  bool loadingTodos = true;
  final todos = TodoDao.instance;
  final tasks = TaskDao.instance;
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> getTodos() async {
    var resp = await todos.queryAllByName();
    setState(() {
      _todoList = resp;
      loadingTodos = false;
    });
    _todoList.toString();
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.only(right: 12),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
          ),
          color: _todoList[index]['id_todo'] == widget.currentIdTodo
              ? Theme.of(context).colorScheme.secondaryContainer
              : Colors.transparent,
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
            ),
            leading: Icon(
              Icons.done_all_outlined,
              color: _todoList[index]['id_todo'] == widget.currentIdTodo
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : null,
            ),
            key: UniqueKey(),
            title: Text(_todoList[index]['name'],
                 style: _todoList[index]['id_todo'] == widget.currentIdTodo
                     ? TextStyle(fontSize: 14,color: Theme.of(context).colorScheme.onSecondaryContainer)
                     : const TextStyle(fontSize: 14),
            ),
            onTap: () async{
              await widget.changeCurrentTodo(_todoList[index]['id_todo']);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
