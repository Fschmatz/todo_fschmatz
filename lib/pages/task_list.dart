import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_fschmatz/db/task_dao.dart';
import 'package:todo_fschmatz/widgets/task_card.dart';
import 'new_note.dart';

class TaskList extends StatefulWidget {

  int state;

  TaskList({Key? key,required this.state}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Map<String, dynamic>> tasksList = [];
  final tasks = TaskDao.instance;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getAll();
  }

  Future<void> getAll() async {
    var resp = await tasks.queryAllRowsDesc();
    setState(() {
      tasksList = resp;
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: loading
            ? const Center(child: SizedBox.shrink())
            : ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: tasksList.length,
                itemBuilder: (context, index) {
                  return const Card(
                    child: Text('Hey Hey People!'),
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
                builder: (BuildContext context) => NewTask(state: widget.state,),
                fullscreenDialog: true,
              )).then((value) => getAll());
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
