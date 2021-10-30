import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_fschmatz/util/changelog.dart';
import 'package:todo_fschmatz/util/theme.dart';
import 'app_info_page.dart';
import 'changelog_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

  const SettingsPage({Key? key}) : super(key: key);
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Color? themeColorApp = Theme.of(context).colorScheme.secondary;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
      children: <Widget>[
        Card(
          elevation: 1,
          margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
          color: Theme.of(context).colorScheme.secondary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: ListTile(
            title: Text(
              Changelog.appName + " " + Changelog.appVersion,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17.5),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const SizedBox(
            height: 0.1,
          ),
          title: Text("About".toUpperCase(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: themeColorApp)),
        ),
        ListTile(
          leading: const Icon(
            Icons.info_outline,
          ),
          title: const Text(
            "App Info",
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AppInfoPage(),
                  fullscreenDialog: true,
                ));
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        ListTile(
          leading: const Icon(
            Icons.article_outlined,
          ),
          title: const Text(
            "Changelog",
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ChangelogPage(),
                  fullscreenDialog: true,
                ));
          },
        ),
        const Divider(),
        ListTile(
          leading: const SizedBox(
            height: 0.1,
          ),
          title: Text("General".toUpperCase(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: themeColorApp)),
        ),
        Consumer<ThemeNotifier>(
          builder: (context, notifier, child) => SwitchListTile(
              title: const Text(
                "Dark Theme",
                style: TextStyle(fontSize: 16),
              ),
              secondary: const Icon(Icons.brightness_6_outlined),
              activeColor: Colors.blue,
              value: notifier.darkTheme,
              onChanged: (value) {
                notifier.toggleTheme();
              }),
        ),
      ],
    ));
  }
}
