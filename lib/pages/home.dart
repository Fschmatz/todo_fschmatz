import 'package:flutter/material.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  late int _currentTodoId;
  List<Widget> _tabs = [];

  Future<void> changeCurrentTodo() async {
    print("oi");

    if (_currentTodoId == 1) {
      setState(() {
        _currentTodoId = 2;
        print(_currentTodoId.toString());
        _tabs;
      });
    } else {
      setState(() {
        _currentTodoId = 1;
        print(_currentTodoId.toString());
        _tabs;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currentTodoId = 1;
    _tabs = [
      TaskList(
        key: UniqueKey(),
        state: 0,
        currentTodoId: _currentTodoId,
        changeCurrentTodo: changeCurrentTodo,
      ),
      TaskList(
        key: UniqueKey(),
        state: 1,
        currentTodoId: _currentTodoId,
        changeCurrentTodo: changeCurrentTodo,
      ),
      TaskList(
        key: UniqueKey(),
        state: 2,
        currentTodoId: _currentTodoId,
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
