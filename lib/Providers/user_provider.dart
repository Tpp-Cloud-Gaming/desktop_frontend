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

  String newGame = '';

  void updateFormValue(Map<String, dynamic> user) {
    _user.updateAll((key, value) => user[key] ?? value);
    notifyListeners();
  }

  void setGames(List<Map<String, dynamic>> games) {
    _games.clear();
    _games.addAll(games);

    notifyListeners();
  }

  void setUserGames(List<Map<String, dynamic>> userGames) {
    _userGames.clear();
    _userGames.addAll(userGames);

    notifyListeners();
  }

  void setLoggin(bool value) {
    _firstLogin = value;
  }

  void addNewUserGame(Map<String, dynamic> game) {
    _userGames.add(game);
    notifyListeners();
  }

  void removeLastUserGame() {
    _userGames.removeLast();
    notifyListeners();
  }

  void removeAtIndexUserGame(int index) {
    _userGames.removeAt(index);
    notifyListeners();
  }

  void loadCredits(int credits) {
    if (_user['credits'] + credits < 0) {
      return;
    }
    _user['credits'] += credits;
    notifyListeners();
  }

  Map<String, dynamic> get user => _user;
  List<Map<String, dynamic>> get games => _games;
  List<Map<String, dynamic>> get userGames => _userGames;
  bool get firstLogin => _firstLogin;
  int get credits => _user['credits'];
}
