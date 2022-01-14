import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/db/todo_dao.dart';
import 'package:todo_fschmatz/pages/configs/settings_page.dart';
import 'package:todo_fschmatz/pages/todos/new_todo.dart';
import 'package:todo_fschmatz/widgets/dialog_manage_todos.dart';
import 'package:todo_fschmatz/widgets/dialog_tags_list.dart';
import 'package:todo_fschmatz/widgets/todos_list.dart';
import 'package:todo_fschmatz/widgets/task_card.dart';
import 'new_task.dart';

class TaskList extends StatefulWidget {
  int state;
  int currentIdTodo;
  Function(int) changeCurrentTodo;

  TaskList(
      {Key? key,
      required this.state,
      required this.currentIdTodo,
      required this.changeCurrentTodo})
      : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList>
    with TickerProviderStateMixin<TaskList> {
  List<Map<String, dynamic>> tasksList = [];
  bool loadingName = true;
  bool loadingBody = true;
  late AnimationController _hideFabAnimation;
  String todoName = "";

  @override
  void initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
    getTodoName().then((value) => getAllTasksByTodoAndState());
  }

  Future<void> getTodoName() async {
    final tasks = TodoDao.instance;
    var resp = await tasks.getTodoName(widget.currentIdTodo);
    setState(() {
      todoName = resp[0]['name'];
      loadingName = false;
    });
  }

  Future<void> getAllTasksByTodoAndState() async {
    final tasks = TaskDao.instance;
    var resp = await tasks.queryAllByTodoAndStateDesc(
        widget.state, widget.currentIdTodo);
    setState(() {
      tasksList = resp;
      loadingBody = false;
    });
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  //Hide FAB
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const ListTile(
              title: Text(
                'Todo Fschmatz',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Divider(),

            TodosList(
              changeCurrentTodo: widget.changeCurrentTodo,
              currentIdTodo: widget.currentIdTodo,
            ),
           /* const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text('New Todo'),
              leading: const Icon(
                Icons.add_outlined,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const NewTodo(),
                      fullscreenDialog: true,
                    ));
              },
            ),*/
            const Divider(),
            ListTile(
                leading: const Icon(
                  Icons.done_all_outlined,
                ),
                title: const Text(
                  'Manage Todos',
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogManageTodos();
                      });
                }),
            ListTile(
              leading: const Icon(
                Icons.label_outline_rounded,
              ),
              title: const Text('Manage Tags'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DialogTagsList();
                    });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SettingsPage(),
                      fullscreenDialog: true,
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
              title: loadingName ? const Text(" ") : Text(todoName),
              pinned: false,
              floating: true,
              snap: true,
            ),
          ];
        },
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 650),
            child: loadingBody
                ? const Center(child: SizedBox.shrink())
                : tasksList.isEmpty
                    ? const Center(
                        child: Text(
                        "Nothing in here...\nit's good?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                            ListTile(
                              onTap: () {},
                              leading: const Icon(Icons.filter_list_outlined),
                              title: const Text("Last Added"),
                              trailing: Text(tasksList.length != 1
                                  ? tasksList.length.toString() + " Tasks"
                                  : tasksList.length.toString() + " Task"),
                            ),
                            ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      //const Divider(height: 0,),
                                      const SizedBox(
                                height: 5,
                              ),
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tasksList.length,
                              itemBuilder: (context, index) {
                                return TaskCard(
                                  key: UniqueKey(),
                                  task: Task(
                                    tasksList[index]['id_task'],
                                    tasksList[index]['title'],
                                    tasksList[index]['note'],
                                    tasksList[index]['state'],
                                    tasksList[index]['id_todo'],
                                  ),
                                  refreshHome: getAllTasksByTodoAndState,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ]),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _hideFabAnimation,
        child: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NewTask(
                    state: widget.state,
                    getAllTasksByState: getAllTasksByTodoAndState,
                    currentIdTodo: widget.currentIdTodo,
                  ),
                  fullscreenDialog: true,
                ));
          },
          child: const Icon(
            Icons.add,
            color: Colors.black87,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
