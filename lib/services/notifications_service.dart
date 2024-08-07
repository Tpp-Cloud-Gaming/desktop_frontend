import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String msg, Color? textColor, Color? backgroundColor) {
    final snackBar = SnackBar(
      content: Text(msg, style: AppTheme.commonText(textColor ?? const Color.fromARGB(255, 255, 17, 0), 18)),
      backgroundColor: backgroundColor ?? Colors.grey[800],
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
