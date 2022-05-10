import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF0F2F2),
    canvasColor: const Color(0xFFF0F2F2),
    scaffoldBackgroundColor: const Color(0xFFF0F2F2),
    colorScheme: ColorScheme.light(
        background: const Color(0xFFF0F2F2),
        primary: Colors.green.shade600,
        onPrimary: const Color(0xFFFFFFFF),
        primaryContainer: const Color(0xFFB2F2B4),
        onPrimaryContainer: const Color(0xFF002106),
        secondaryContainer: const Color(0xFFD4E8D0),
        onSecondaryContainer: const Color(0xFF101F11),
        secondary: Colors.green.shade600),
    popupMenuTheme: const PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: Color(0xFFF5F7F7),
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFF0F2F2),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF000000)),
        titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000))),
    cardTheme: const CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: Color(0xFFFDFFFF),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFFDFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green.shade500,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFFFEFFFF),
        focusColor: Colors.green.shade600,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green.shade600,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12.0))),
    bottomAppBarColor: const Color(0xFFF0F2F2),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Colors.green),
      selectedLabelStyle: TextStyle(color: Colors.green),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFFF0F2F2),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFF0F2F2),
        indicatorColor: Colors.green,
        iconTheme: MaterialStateProperty.all(const IconThemeData(
          color: Color(0xFF050505),
        )),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFF050505), fontWeight: FontWeight.w500))),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFF0F2F2)));

ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1C1C1D),
    scaffoldBackgroundColor: const Color(0xFF1C1C1D),
    canvasColor: const Color(0xFF1C1C1D),
    colorScheme: const ColorScheme.dark(
        background: Color(0xFF1C1C1D),
        primary: Color(0xFF66BF72),
        onPrimary: Color(0xFF003910),
        primaryContainer: Color(0xFF235232),
        onPrimaryContainer: Color(0xFFB2F2B4),
        secondaryContainer: Color(0xFF3A4B3A),
        onSecondaryContainer: Color(0xFFD4E8D0),
        secondary: Color(0xFF66BF72)),
    popupMenuTheme: const PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: Color(0xFF343435),
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF1C1C1D),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFFFF))),
    cardTheme: const CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: Color(0xFF2C2C2D),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF2C2C2D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFF353537),
        focusColor: const Color(0xFF66BF72),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
      backgroundColor: Color(0xFF1C1C1D),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF66BF72),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1C1C1D),
        indicatorColor: const Color(0xFF6BBD76),
        iconTheme: MaterialStateProperty.all(const IconThemeData(
          color: Color(0xFFEAEAEA),
        )),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFFEAEAEA), fontWeight: FontWeight.w500))),
    //dividerColor: const Color(0x2FFFFFFF),
    bottomAppBarColor: const Color(0xFF1C1C1D),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFF1C1C1D)));
