import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_fschmatz/classes/filter.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/pages/configs/settings_page.dart';
import 'package:todo_fschmatz/pages/manager/tags_manager.dart';
import 'package:todo_fschmatz/pages/manager/todos_manager.dart';
import 'package:todo_fschmatz/widgets/todos_list.dart';
import 'package:todo_fschmatz/widgets/task_card.dart';
import 'new_task.dart';

class TaskList extends StatefulWidget {
  int state;
  int currentIdTodo;
  Function(int) changeCurrentTodo;
  String todoName;
  Function() reloadHome;

  TaskList(
      {Key? key,
      required this.state,
      required this.todoName,
      required this.currentIdTodo,
      required this.changeCurrentTodo,
      required this.reloadHome})
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

  final List<Filter> _filtersList = [
    Filter('Newest', 'id_task DESC'),
    Filter('Oldest', 'id_task ASC'),
    Filter('Title', 'title ASC'),
  ];
  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
    getAllTasksByTodoStateFilter();
  }

  Future<void> getAllTasksByTodoStateFilter() async {
    final tasks = TaskDao.instance;
    var resp = await tasks.queryAllByTodoStateFilter(widget.state,
        widget.currentIdTodo, _filtersList[selectedFilter].dbName);
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

  void openFilterMenu() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.filter_list_outlined),
                    title: Text(
                      "Order By",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const SizedBox.shrink(),
                    title: Text(
                      _filtersList[0].name,
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedFilter == 0
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    onTap: () {
                      selectedFilter = 0;
                      getAllTasksByTodoStateFilter();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const SizedBox.shrink(),
                    title: Text(
                      _filtersList[1].name,
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedFilter == 1
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    onTap: () {
                      selectedFilter = 1;
                      getAllTasksByTodoStateFilter();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const SizedBox.shrink(),
                    title: Text(
                      _filtersList[2].name,
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedFilter == 2
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    onTap: () {
                      selectedFilter = 2;
                      getAllTasksByTodoStateFilter();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
            ),
            const Divider(),
            TodosList(
              changeCurrentTodo: widget.changeCurrentTodo,
              currentIdTodo: widget.currentIdTodo,
            ),
            const Divider(),
            ListTile(
                leading: const Icon(
                  Icons.checklist_outlined,
                ),
                title: const Text(
                  'Manage Todos',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            TodosManager(currentIdTodo: widget.currentIdTodo),
                        fullscreenDialog: true,
                      )).then((value) => widget.reloadHome());
                }),
            ListTile(
              leading: const Icon(
                Icons.label_outline_rounded,
              ),
              title: const Text(
                'Manage Tags',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => TagsManager(),
                      fullscreenDialog: true,
                    )).then((value) => widget.reloadHome());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
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
              title: Text(widget.todoName),
              pinned: false,
              floating: true,
              snap: true,
            ),
          ];
        },
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
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
                              onTap: openFilterMenu,
                              leading: const Icon(Icons.filter_list_outlined),
                              title: Text(_filtersList[selectedFilter].name),
                              trailing: Text(tasksList.length != 1
                                  ? tasksList.length.toString() + " Tasks"
                                  : tasksList.length.toString() + " Task"),
                            ),
                            ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
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
                                  refreshHome: getAllTasksByTodoStateFilter,
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
                    getAllTasksByState: getAllTasksByTodoStateFilter,
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
