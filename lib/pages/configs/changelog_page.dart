import 'package:flutter/material.dart';
import 'package:todo_fschmatz/util/app_details.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Color? themeColorApp = Theme.of(context).colorScheme.secondary;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Changelog"),
        ),
        body: ListView(children: <Widget>[
          ListTile(

              title: Text("Current Version",
                  style: TextStyle(
                     fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: themeColorApp))),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              AppDetails.changelogCurrent,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          ListTile(

            title: Text("Previous Versions",
                style: TextStyle(
                   fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: themeColorApp)),
          ),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              AppDetails.changelogsOld,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ]));
  }
}
