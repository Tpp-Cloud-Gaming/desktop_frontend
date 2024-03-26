import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = const Color(0xFF2E305F);

  static const Color appBarColor = Color(0xFF2E305F);

  static const Color onHoverColor = Color(0xFF558088);

  static const Color registerCollorContainerLetter =
      Color.fromARGB(255, 89, 116, 167);
  static const Color pannelColor = Color(0xFF233043);
  static const Color loginPannelColor = Color(0xFF1B2942);
  static const Color loginButtonColor = Color(0xFF1B2942);
  static const Color loginButtonTextColor = Color.fromARGB(249, 81, 68, 150);

  static const String loginBackgroundPath = 'assets/background/login.jpg';
  static const String appBackgroundPath =
      'assets/background/wallhaven-d6mkv3.jpg';
  static const String logoPath = 'assets/logo.png';
  static const String googleIconPath = 'assets/google_icon.png';

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
