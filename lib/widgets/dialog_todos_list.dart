import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/tag.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';
import 'package:todo_fschmatz/pages/tags/edit_tag.dart';
import 'package:todo_fschmatz/pages/tags/new_tag.dart';

class DialogTodosList extends StatefulWidget {
  const DialogTodosList({Key? key}) : super(key: key);

  @override
  _DialogTodosListState createState() => _DialogTodosListState();
}

class _DialogTodosListState extends State<DialogTodosList> {
  bool loadingTags = true;
  final tags = TagDao.instance;
  List<Map<String, dynamic>> tagsList = [];

  @override
  void initState() {
    super.initState();
    //getTags();
  }

  /*Future<void> _delete(int id_tag) async {
    final deleted = await tags.delete(id_tag);
  }

  Future<void> getTags() async {
    var resp = await tags.queryAllRows();
    setState(() {
      tagsList = resp;
      loadingTags = false;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 25, 0, 24),
      title: const Text('Todos'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: const Text(
            "New Todo",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: () {},
        ),
        TextButton(
          child: const Text(
            "Close",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      content: SizedBox(
        height: 330.0,
        width: 350.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
              title: Text('Todo Fschmatz'),
            );

            // const Icon(Icons.edit_outlined));
          },
        ),
      ),
    );
  }
}
