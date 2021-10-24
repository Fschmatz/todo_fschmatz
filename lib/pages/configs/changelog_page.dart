import 'package:flutter/material.dart';
import 'package:todo_fschmatz/util/changelog.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Color? themeColorApp = Theme.of(context).accentColor;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Changelog"),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              leading: const SizedBox(
                height: 0.1,
              ),
              title: Text("Current Version".toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: themeColorApp))),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              Changelog.changelogCurrent,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: 0.1,
            ),
            title: Text("Previous Versions".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: themeColorApp)),
          ),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              Changelog.changelogsOld,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ]));
  }
}
