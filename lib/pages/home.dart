import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';
import 'package:todo_fschmatz/widgets/dialog_tags_list.dart';
import 'package:todo_fschmatz/widgets/dialog_todos_list.dart';
import 'configs/settings_page.dart';

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
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: const Text('Todo Fschmatz'),
                pinned: false,
                floating: true,
                snap: true,
                //forceElevated: innerBoxIsScrolled,
                actions: [
                  PopupMenuButton<int>(
                      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                        const PopupMenuItem<int>(
                            value: 0, child: Text('Todos')),
                        const PopupMenuItem<int>(
                            value: 1, child: Text('Tags')),
                        const PopupMenuItem<int>(
                            value: 2, child: Text('Settings')),
                      ],
                      onSelected: (int value) {
                        //setState(() { value = value; });
                        if(value == 0){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DialogTodosList();
                              });
                        }
                        if(value == 1){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DialogTagsList();
                              });
                        }
                        if(value == 2){
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => const SettingsPage(),
                                fullscreenDialog: true,
                              ));
                        }
                      })
                ],
              ),
            ];
          },
          body: _tabs[_currentIndex]
      ),
      bottomNavigationBar: NavigationBar(
        //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
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
