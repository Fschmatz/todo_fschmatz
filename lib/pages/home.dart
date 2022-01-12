import 'package:flutter/material.dart';
import 'package:todo_fschmatz/db/current_todo.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  int _currentIdTodo = 0;
  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    loadCurrentTodo().then((value) => _tabs = [
          TaskList(
            key: UniqueKey(),
            state: 0,
            currentIdTodo: _currentIdTodo,
            changeCurrentTodo: changeCurrentTodo,
          ),
          TaskList(
            key: UniqueKey(),
            state: 1,
            currentIdTodo: _currentIdTodo,
            changeCurrentTodo: changeCurrentTodo,
          ),
          TaskList(
            key: UniqueKey(),
            state: 2,
            currentIdTodo: _currentIdTodo,
            changeCurrentTodo: changeCurrentTodo,
          ),
        ]);
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

    setState(() {
      _tabs = [
        TaskList(
          key: UniqueKey(),
          state: 0,
          currentIdTodo: _currentIdTodo,
          changeCurrentTodo: changeCurrentTodo,
        ),
        TaskList(
          key: UniqueKey(),
          state: 1,
          currentIdTodo: _currentIdTodo,
          changeCurrentTodo: changeCurrentTodo,
        ),
        TaskList(
          key: UniqueKey(),
          state: 2,
          currentIdTodo: _currentIdTodo,
          changeCurrentTodo: changeCurrentTodo,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIdTodo != 0
          ? _tabs[_currentTabIndex]
          : const Center(
              child: Text(
              "Please Create a Todo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
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
