import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/tag.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';

import 'edit_tag.dart';

class SelectTagPage extends StatefulWidget {
  const SelectTagPage({Key? key}) : super(key: key);

  @override
  _SelectTagPageState createState() => _SelectTagPageState();
}

class _SelectTagPageState extends State<SelectTagPage> {

  bool loadingTags = true;
  final tags = TagDao.instance;
  List<Map<String, dynamic>> tagsList = [];

  @override
  void initState() {
    super.initState();
    getTags();
  }

  Future<void> _delete(int id_tag) async {
    final deleted = await tags.delete(id_tag);
  }

  Future<void> getTags() async {
    var resp = await tags.queryAllRows();
    setState(() {
      tagsList = resp;
      loadingTags = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Tag"),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save',
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: tagsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
            leading: Icon(Icons.circle,
                color: Color(
                    int.parse(tagsList[index]['color'].substring(6, 16)))),
            title: Text(tagsList[index]['name']),
            trailing:
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.delete_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .headline6!
                          .color!
                          .withOpacity(0.8),
                    ),
                    onPressed: () {
                      _delete(tagsList[index]['id_tag']).then((value) => getTags());
                    }),
                const SizedBox(width: 5,),
                IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
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
                            builder: (BuildContext context) => EditTag(
                              tag: Tag(
                                tagsList[index]['id_tag'],
                                tagsList[index]['name'],
                                tagsList[index]['color'],
                              ),
                            ),
                            fullscreenDialog: true,
                          )).then((value) => getTags());
                    }),
              ],
            ),
          );


          // const Icon(Icons.edit_outlined));
        },
      ),
    );
  }
}
