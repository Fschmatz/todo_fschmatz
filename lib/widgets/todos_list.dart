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

  Future<void> getTodos() async {
    var resp = await todos.queryAllRowsByName();
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
        return ListTile(
          key: UniqueKey(),
          //leading: const SizedBox.shrink(),
          title: Text(_todoList[index]['name'],
               style: _todoList[index]['id_todo'] == widget.currentIdTodo
                   ? TextStyle(fontSize: 14,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w500)
                   : const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          onTap: () async{
            await widget.changeCurrentTodo(_todoList[index]['id_todo']);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
