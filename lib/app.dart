import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_fschmatz/pages/home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color bottomOverlayColor =
        Theme.of(context).bottomNavigationBarTheme.backgroundColor!;
    final Color topOverlayColor =
        Theme.of(context).appBarTheme.backgroundColor!;
    final Brightness iconBrightness =
        Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: bottomOverlayColor,
          statusBarColor: topOverlayColor,
          systemNavigationBarIconBrightness: iconBrightness,
        ),
        child: const SafeArea(child: Home()));
  }
}
