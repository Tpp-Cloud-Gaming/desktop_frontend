import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = const Color(0xff2E305F);

  static const Color letterColor = Colors.white;
  static const Color letterColorDark = Colors.black;
  static const Color backgroundContainerDark = Colors.black;
  static const Color backgroundContainer = Color.fromARGB(255, 20, 3, 42);
  static Color letterColorRegistration = Colors.deepPurple[300]!;
  static const Color appBarColor = Color(0xff2E305F);
  static const Color secondaryBackgroundContainer =
      Color.fromARGB(255, 40, 17, 89);

  static const Color registerCollorContainerLetter =
      Color.fromARGB(255, 89, 116, 167);

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(color: appBarColor),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.indigo,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5))),
  );
}
