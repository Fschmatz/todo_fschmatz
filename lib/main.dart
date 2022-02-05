import 'package:flutter/material.dart';
import 'package:todo_fschmatz/util/theme.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'app.dart';
import 'db/db_creator.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final dbCreator = DbCreator.instance;
  dbCreator.initDatabase();

  runApp(
    EasyDynamicThemeWidget(
      child: const StartAppTheme(),
    ),
  );
}

class StartAppTheme extends StatelessWidget {
  const StartAppTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: light,
        darkTheme: dark,
        themeMode: EasyDynamicTheme.of(context).themeMode,
        home: const App(),
    );
  }
}
