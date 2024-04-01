import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'settings': (BuildContext context) => const SettingsScreen(),
    'email_verification': (BuildContext context) =>
        const EmailVerificationScreen(),
    'google_auth': (BuildContext context) => const GoogleAuthScreen(),
    'location': (BuildContext context) => const LocationScreen(),
    'game': (BuildContext context) => const GameScreen(),
  };
}
