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
  final List<Map<String, dynamic>> _userGames = [];

  void updateFormValue(Map<String, dynamic> user) {
    _user["username"] = user["username"];
    _user["email"] = user["email"];
    _user["credits"] = user["credits"];
    _user["longitude"] = user["longitude"];
    _user["latitude"] = user["latitude"];
    notifyListeners();
  }

  void setLoggin(bool value) {
    _firstLogin = value;
  }

  void changeUsername(String username) {
    _user["username"] = username;
    notifyListeners();
  }

  Map<String, dynamic> get user => _user;
  bool get firstLogin => _firstLogin;
}
