import 'package:flutter/material.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  late int _currentIdTodo;
  List<Widget> _tabs = [];

  Future<void> changeCurrentTodo(int idTodo) async {

    _currentIdTodo = idTodo;
    print(_currentIdTodo.toString());

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
  void initState() {
    super.initState();
    _currentIdTodo = 1;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentTabIndex],
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
