import 'package:flutter/material.dart';
import 'package:todo_fschmatz/db/current_todo.dart';
import 'package:todo_fschmatz/db/todo_dao.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  int _currentIdTodo = 0;
  List<Widget> _tabs = [const SizedBox()];
  String todoName = ' ';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    appStartFunctions();
  }

  void appStartFunctions() async {
    await loadCurrentTodo();
    await getTodoName();
    _tabs = [
      TaskList(
        key: UniqueKey(),
        state: 0,
        currentIdTodo: _currentIdTodo,
        changeCurrentTodo: changeCurrentTodo,
        todoName: todoName,
        reloadHome: appStartFunctions,
      ),
      TaskList(
        key: UniqueKey(),
        state: 1,
        currentIdTodo: _currentIdTodo,
        changeCurrentTodo: changeCurrentTodo,
        todoName: todoName,
        reloadHome: appStartFunctions,
      ),
      TaskList(
        key: UniqueKey(),
        state: 2,
        currentIdTodo: _currentIdTodo,
        changeCurrentTodo: changeCurrentTodo,
        todoName: todoName,
        reloadHome: appStartFunctions,
      ),
    ];
  }

  Future<void> getTodoName() async {
    final tasks = TodoDao.instance;
    var resp = await tasks.getTodoName(_currentIdTodo);
    setState(() {
      todoName = resp[0]['name'];
    });
  }

  Future<void> loadCurrentTodo() async {
    int v = await CurrentTodo().loadFromPrefs();
    setState(() {
      _currentIdTodo = v;
    });
  }

  Future<void> changeCurrentTodo(int idTodo) async {
    CurrentTodo().saveToPrefs(idTodo);
    _currentIdTodo = idTodo;
    await getTodoName();

    setState(() {
      _tabs = [
        TaskList(
          key: UniqueKey(),
          state: 0,
          currentIdTodo: _currentIdTodo,
          changeCurrentTodo: changeCurrentTodo,
          todoName: todoName,
          reloadHome: appStartFunctions,
        ),
        TaskList(
          key: UniqueKey(),
          state: 1,
          currentIdTodo: _currentIdTodo,
          changeCurrentTodo: changeCurrentTodo,
          todoName: todoName,
          reloadHome: appStartFunctions,
        ),
        TaskList(
          key: UniqueKey(),
          state: 2,
          currentIdTodo: _currentIdTodo,
          changeCurrentTodo: changeCurrentTodo,
          todoName: todoName,
          reloadHome: appStartFunctions,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIdTodo != 0
          ? _tabs[_currentTabIndex]
          : const SizedBox.shrink(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(
              Icons.list,
              color: Colors.black87,
            ),
            label: 'Todo',
          ),
          NavigationDestination(
            icon: Icon(Icons.construction_outlined),
            selectedIcon: Icon(
              Icons.construction,
              color: Colors.black87,
            ),
            label: 'Doing',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(
              Icons.checklist,
              color: Colors.black87,
            ),
            label: 'Done',
          ),
        ],
      ),
    );
  }
}
