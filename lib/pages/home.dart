import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_fschmatz/pages/tasks/task_list.dart';
import 'package:todo_fschmatz/widgets/dialog_tags_list.dart';
import 'configs/settings_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  int _currentIndex = 0;
  final List<Widget> _tabs = [
    TaskList(key: UniqueKey(),state: 0,),
    TaskList(key: UniqueKey(),state: 1,),
    TaskList(key: UniqueKey(),state: 2,),
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo Fschmatz',
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.label_outline_rounded,
                size: 28,
                color: Theme.of(context)
                    .textTheme
                    .headline6!
                    .color!
                    .withOpacity(0.8),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DialogTagsList();
                    });
              }),
          const SizedBox(width: 10,),
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
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
                    builder: (BuildContext context) => const SettingsPage(),
                    fullscreenDialog: true,
                  ));
            }),
        ],
      ),

      body: _tabs[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade800,))
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.list_outlined),
                activeIcon: Icon(Icons.list),
                label: "Todo",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.construction_outlined),
                activeIcon: Icon(Icons.construction),
                label: "Doing"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist_outlined),
                activeIcon: Icon(Icons.checklist),
                label: "Done"
            ),
          ],
        ),
      ),
    );
  }
}
