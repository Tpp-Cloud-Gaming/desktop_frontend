import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static final TextStyle loginTextStyle = AppTheme.commonText(Colors.white, 20);
  static final TextStyle loginTextButtonsStyle = GoogleFonts.roboto(
    color: AppTheme.loginButtonTextColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    shadows: <Shadow>[
      Shadow(
        offset: const Offset(0.0, 00.0),
        blurRadius: 0.5,
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
      ),
    ],
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    textTheme: GoogleFonts.bebasNeueTextTheme(),
    primaryColor: primary,
    appBarTheme: const AppBarTheme(color: appBarColor),
    inputDecorationTheme: const InputDecorationTheme(),
  );

  static TextStyle commonText(Color color, int size) {
    return GoogleFonts.roboto(color: color, fontSize: size.toDouble());
  }
}
