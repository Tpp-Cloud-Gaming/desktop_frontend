import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _firstLogin = true;
  final Map<String, dynamic> _user = {
    'username': '',
    'email': '',
    'credits': 0,
    'longitude': 0.0,
    'latitude': 0.0,
  };

  final List<Map<String, dynamic>> _games = [];

  final List<Map<String, dynamic>> _userGames = [];

  void updateFormValue(Map<String, dynamic> user) {
    _user.updateAll((key, value) => user[key] ?? value);
    notifyListeners();
  }

  void setGames(List<Map<String, dynamic>> games) {
    _games.clear();
    _games.addAll(games);

    notifyListeners();
  }

  void setLoggin(bool value) {
    _firstLogin = value;
  }

  Map<String, dynamic> get user => _user;
  List<Map<String, dynamic>> get games => _games;
  bool get firstLogin => _firstLogin;
}
