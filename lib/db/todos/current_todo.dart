import 'package:shared_preferences/shared_preferences.dart';

class CurrentTodo  {
  final String key = 'currentIdTodo';
  late SharedPreferences prefs;

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<int> loadFromPrefs() async {
    await _initPrefs();
    return prefs.getInt(key) ?? 1;
  }

  saveToPrefs(int idTodo) async {
    await _initPrefs();
    prefs.setInt(key, idTodo);
  }
}
