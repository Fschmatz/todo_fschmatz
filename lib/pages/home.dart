import 'package:flutter/material.dart';
import 'package:todo_fschmatz/db/todos/current_todo.dart';
import 'package:todo_fschmatz/db/todos/todo_dao.dart';
import 'package:todo_fschmatz/pages/managers/todos_manager.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';
import '../widgets/drawer_todo_list.dart';
import 'configs/settings_page.dart';
import 'managers/tags_manager.dart';

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
      ),
      TaskList(
        key: UniqueKey(),
        state: 1,
        currentIdTodo: _currentIdTodo,
      ),
      TaskList(
        key: UniqueKey(),
        state: 2,
        currentIdTodo: _currentIdTodo,
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
        ),
        TaskList(
          key: UniqueKey(),
          state: 1,
          currentIdTodo: _currentIdTodo,
        ),
        TaskList(
          key: UniqueKey(),
          state: 2,
          currentIdTodo: _currentIdTodo,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.80,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const ListTile(
              title: Text(
                'Todo Fschmatz',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
            ),
            const Divider(),
            DrawerTodoList(
              changeCurrentTodo: changeCurrentTodo,
              currentIdTodo: _currentIdTodo,
            ),
            const Divider(),
            ListTile(
                leading: const Icon(
                  Icons.checklist_outlined,
                ),
                title: const Text(
                  'Manage Todos',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TodosManager(currentIdTodo: _currentIdTodo),
                      )).then((value) => appStartFunctions());
                }),
            ListTile(
              leading: const Icon(
                Icons.label_outline_rounded,
              ),
              title: const Text(
                'Manage Tags',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TagsManager(),
                    )).then((value) => appStartFunctions());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const SettingsPage(),
                    ));
              },
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(todoName),
              pinned: false,
              floating: true,
              snap: true,
            ),
          ];
        },
        body: (_currentIdTodo != 0)
            ? _tabs[_currentTabIndex]
            : const SizedBox.shrink(),
      ),
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
            ),
            label: 'Todo',
          ),
          NavigationDestination(
            icon: Icon(Icons.construction_outlined),
            selectedIcon: Icon(
              Icons.construction,
            ),
            label: 'Doing',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(
              Icons.checklist,
            ),
            label: 'Done',
          ),
        ],
      ),
    );
  }
}
