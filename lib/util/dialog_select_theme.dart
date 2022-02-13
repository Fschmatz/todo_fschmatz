import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

class DialogSelectTheme extends StatefulWidget {
  const DialogSelectTheme({Key? key}) : super(key: key);

  @override
  _DialogSelectThemeState createState() => _DialogSelectThemeState();
}

class _DialogSelectThemeState extends State<DialogSelectTheme> {

  final List<String> _themes = [
    'ThemeMode.light', 'ThemeMode.dark', 'ThemeMode.system'
  ];

  @override
  Widget build(BuildContext context) {

    ThemeMode? currentTheme = EasyDynamicTheme.of(context).themeMode;
    Color appAccent = Theme.of(context).colorScheme.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 25, 0, 24),
      title: const Text('Select Theme'),
      content: SizedBox(
        height: 180.0,
        width: 350.0,
        child: Column(
          children: [
            RadioListTile(
              activeColor: appAccent,
              key: UniqueKey(),
              value: 0,
              groupValue: currentTheme.toString() == _themes[0] ? 0 : null,
              title: const Text('Light'),
              onChanged : (v) => {
                EasyDynamicTheme.of(context).changeTheme(dark: false)
              },
            ),
            RadioListTile(
              activeColor: appAccent,
              key: UniqueKey(),
              value: 1,
              groupValue: currentTheme.toString() == _themes[1] ? 1 : null,
               title: const Text('Dark'),
              onChanged : (v) => {
                EasyDynamicTheme.of(context).changeTheme(dark: true)
              },
            ),
            RadioListTile(
              activeColor: appAccent,
              key: UniqueKey(),
              value: 2,
              groupValue: currentTheme.toString() == _themes[2] ? 2 : null,
              title: const Text('System default'),
              onChanged : (v) => {
                EasyDynamicTheme.of(context).changeTheme(dynamic: true)
              },
            ),
          ],
        )
      ),
    );
  }
}
