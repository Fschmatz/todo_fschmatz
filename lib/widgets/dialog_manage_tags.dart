import 'package:flutter/material.dart';
import 'package:todo_fschmatz/classes/tag.dart';
import 'package:todo_fschmatz/db/tag_dao.dart';
import 'package:todo_fschmatz/pages/tags/edit_tag.dart';
import 'package:todo_fschmatz/pages/tags/new_tag.dart';

import '../util/utils_functions.dart';

class DialogTagsList extends StatefulWidget {
  const DialogTagsList({Key? key}) : super(key: key);

  @override
  _DialogTagsListState createState() => _DialogTagsListState();
}

class _DialogTagsListState extends State<DialogTagsList> {
  bool loadingTags = true;
  final tags = TagDao.instance;
  List<Map<String, dynamic>> _tagsList = [];

  @override
  void initState() {
    super.initState();
    getTags();
  }

  Future<void> _delete(int idTag) async {
    final deleted = await tags.delete(idTag);
  }

  Future<void> getTags() async {
    var resp = await tags.queryAllRowsByName();
    setState(() {
      _tagsList = resp;
      loadingTags = false;
    });
  }

  showAlertDialogOkDelete(BuildContext context, idTag) {
    Widget okButton = TextButton(
      child: const Text(
        "Yes",
      ),
      onPressed: () {
        _delete(idTag).then((value) => getTags());
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: const Text(
        "Confirm",
      ),
      content: const Text(
        "Delete ?",
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 25, 0, 24),
      title: const Text('Tags'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: const Text(
            "New Tag",
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const NewTag(),
                  fullscreenDialog: true,
                )).then((value) => getTags());
          },
        ),
        TextButton(
          child: const Text(
            "Close",
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
          itemCount: _tagsList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
              leading: Icon(Icons.circle,
                  color: parseColorFromDb(_tagsList[index]['color'])),
              title: Text(_tagsList[index]['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _tagsList.length > 1
                      ? IconButton(
                          icon: Icon(
                            Icons.delete_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .headline6!
                                .color!
                                .withOpacity(0.8),
                          ),
                          onPressed: () {
                            showAlertDialogOkDelete(
                                context, _tagsList[index]['id_tag']);
                          })
                      : const SizedBox.shrink(),
                  const SizedBox(
                    width: 5,
                  ),
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
                                  _tagsList[index]['id_tag'],
                                  _tagsList[index]['name'],
                                  _tagsList[index]['color'],
                                ),
                              ),
                              fullscreenDialog: true,
                            )).then((value) => getTags());
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}