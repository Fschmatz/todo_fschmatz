import 'package:flutter/material.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  final List<Widget> _tabs = [
    TaskList(
      key: UniqueKey(),
      state: 0,
    ),
    TaskList(
      key: UniqueKey(),
      state: 1,
    ),
    TaskList(
      key: UniqueKey(),
      state: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
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
