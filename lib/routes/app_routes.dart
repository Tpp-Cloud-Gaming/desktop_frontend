import 'package:cloud_gaming/screens/my_games_screen.dart';
import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'settings': (BuildContext context) => const SettingsScreen(),
    'email_verification': (BuildContext context) => const EmailVerificationScreen(),
    'location': (BuildContext context) => const LocationScreen(),
    'my_games': (BuildContext context) => const MyGamesScreen(),
    'login': (BuildContext context) => const LoginScreen(),
    'forgot_password': (BuildContext context) => const ForgotPasswordScreen(),
    'play_game': (BuildContext context) => const PlayGameScreen(),
    'fav': (BuildContext context) => const FavScreen(),
    'coins': (BuildContext context) => const MyCoinsScreen(),
    'waitAccredit': (BuildContext context) => const WaitAccreditScreen(),
  };
}
