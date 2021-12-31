import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    primaryColor: const Color(0xFFF2F4F4),
    canvasColor: const Color(0xFFF2F4F4),
    scaffoldBackgroundColor: const Color(0xFFF2F4F4),
    colorScheme: ColorScheme.light(
      background: const Color(0xFFF2F4F4),
      primary: Colors.green.shade600,
      secondary: Colors.green.shade600,
      secondaryVariant: Colors.green.shade600,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: Color(0xFFF5F7F7),
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFF2F4F4),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFF050505)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),    
    cardTheme: const CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 0,
      color: Color(0xFFFDFFFF),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFFDFFFF),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green.shade500,
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFFFEFFFF),
        focusColor: Colors.green.shade600,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green.shade600,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
            ),
            borderRadius: BorderRadius.circular(12.0))),
    bottomAppBarColor: const Color(0xFFF2F4F4),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Colors.green.shade600),
      selectedLabelStyle: TextStyle(color: Colors.green.shade600),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      backgroundColor: const Color(0xFFF2F4F4),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFF2F4F4),
        indicatorColor:  Colors.green.shade600,
        iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Color(0xFF050505),)
        ),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFF050505), fontWeight: FontWeight.w500))),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFFF2F4F4)));


ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColorBrightness: Brightness.light,
    primaryColor: const Color(0xFF171718),
    scaffoldBackgroundColor: const Color(0xFF171718),
    canvasColor: const Color(0xFF171718),
    colorScheme: const ColorScheme.dark(
        background: Color(0xFF171718),
        primary:  Color(0xFF66BF72),
        secondary: Color(0xFF66BF72),
        secondaryVariant: Color(0xFF66BF72)
    ),
    popupMenuTheme: const PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: Color(0xFF2A2A2C),
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF171718),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFCACACA)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    cardTheme: const CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 0,
      color: Color(0xFF282829),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF282829),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFF353537),
        focusColor: const Color(0xFF66BF72),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF66BF72),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
            ),
            borderRadius: BorderRadius.circular(12.0))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Color(0xFF66BF72)),
      selectedLabelStyle: TextStyle(color: Color(0xFF66BF72)),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFF171718),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF66BF72),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF171718),
        indicatorColor: const Color(0xFF66BF72),
        iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Color(0xFFCACACA),)
        ),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFFCACACA), fontWeight: FontWeight.w500))),
    dividerColor: const Color(0x2FFFFFFF),
    bottomAppBarColor: const Color(0xFF171718),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFF171718)));

class ThemeNotifier extends ChangeNotifier {
  final String key = 'valorTema';
  late SharedPreferences prefs;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _darkTheme);
  }
}

