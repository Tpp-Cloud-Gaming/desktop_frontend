import 'package:flutter_regex/flutter_regex.dart';

bool isValidUsername(String username) {
  return username.isUsername();
}

bool isValidEmail(String email) {
  return email.isEmail();
}

bool isValidPassword(String password) {
  return password.isPasswordEasy();
}
