import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_fschmatz/classes/filter.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/widgets/task_card.dart';
import 'new_task.dart';

class TaskList extends StatefulWidget {
  int state;
  int currentIdTodo;

  TaskList({Key? key, required this.state, required this.currentIdTodo})
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
    getAllTasksByTodoStateFilter(false);
  }

  Future<void> getAllTasksByTodoStateFilter([bool refresh = true]) async {
    if (refresh) {
      setState(() {
        loadingBody = true;
      });
    }
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
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: AnimatedSwitcher(
          //switchInCurve: Curves.easeIn,
          //switchOutCurve: Curves.easeOut,
          duration: const Duration(milliseconds: 600),
          child: loadingBody
              ? const Center(child: SizedBox.shrink())
              : tasksList.isEmpty
                  ? const Center(
                      child: Text(
                      "Nothing in here...\nit's good?",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      floatingActionButton: ScaleTransition(
        scale: _hideFabAnimation,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NewTask(
                    state: widget.state,
                    getAllTasksByState: getAllTasksByTodoStateFilter,
                    currentIdTodo: widget.currentIdTodo,
                  ),
                ));
          },
          child: Icon(
            Icons.add_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
