import 'package:shared_preferences/shared_preferences.dart';

class CurrentTodo  {
  final String key = 'currentIdTodo';
  late SharedPreferences prefs;
  //late int _currentIdTodo;

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<int> loadFromPrefs() async {
    await _initPrefs();
    return prefs.getInt(key) ?? 0;
  }

  saveToPrefs(int idTodo) async {

    print(idTodo.toString());

    await _initPrefs();
    prefs.setInt(key, idTodo);
  }
}
