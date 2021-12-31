import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/task.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/widgets/task_card.dart';
import 'new_task.dart';

class TaskList extends StatefulWidget {

  int state;

  TaskList({Key? key, required this.state}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {

  List<Map<String, dynamic>> tasksList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getAllTasksByState();
  }

  void getAllTasksByState() async {
    tasksList = [];
    final tasks = TaskDao.instance;
    var resp = await tasks.queryAllByStateDesc(widget.state);
    setState(() {
      tasksList = resp;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: loading
            ? const Center(child: SizedBox.shrink())
            : tasksList.isEmpty
                ? const Center(
                    child: Text(
                    "Nothing in here...\nit's good?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                        ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              //const Divider(height: 0,),
                              const SizedBox(height: 5,),
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
                              ),
                              refreshHome: getAllTasksByState,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ]),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => NewTask(
                  state: widget.state,
                  getAllTasksByState: getAllTasksByState,
                ),
                fullscreenDialog: true,
              ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
