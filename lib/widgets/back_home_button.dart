import 'package:flutter/material.dart';
import 'package:cloud_gaming/themes/app_theme.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, "home");
        },
        style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
        child: Text(
          "Back to home",
          style: AppTheme.commonText(Colors.white, 18),
        ));
  }
}
