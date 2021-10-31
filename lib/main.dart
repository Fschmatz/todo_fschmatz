import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_fschmatz/util/theme.dart';

import 'app.dart';
import 'db/db_creator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbCreator = DbCreator.instance;
  dbCreator.initDatabase();

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          theme: notifier.darkTheme ? dark : light,
          home: const App(),
        );
      },
    ),
  ));
}
