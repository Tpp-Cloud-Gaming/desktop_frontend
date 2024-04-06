import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _user = {
    'username': '',
    'email': '',
    'credits': 0,
    'longitude': 0.0,
    'latitude': 0.0,
  };
  void updateFormValue(Map<String, dynamic> user) {
    _user["username"] = user["username"];
    _user["email"] = user["email"];
    _user["credits"] = user["credits"];
    _user["longitude"] = user["longitude"];
    _user["latitude"] = user["latitude"];
    notifyListeners();
  }

  Map<String, dynamic> get user => _user;
}
