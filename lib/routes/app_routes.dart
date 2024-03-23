import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'settings': (BuildContext context) => const SettingsScreen(),
  };
}
