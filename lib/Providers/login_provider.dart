import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  Map<String, String> formValues = {
    'username': '',
    'password': '',
  };

  bool _recordarme = false;

  set recordarme(bool value) {
    _recordarme = value;
    notifyListeners();
  }

  void updateFormValue(String username, String key) {
    formValues['username'] = username;
    formValues['key'] = key;
    notifyListeners();
  }

  bool get recordarme => _recordarme;
}
