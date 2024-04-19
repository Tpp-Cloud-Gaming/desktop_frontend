import 'package:cloud_gaming/screens/authentication/google_auth_screen.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  final bool isRegister;
  const GoogleLoginButton({super.key, required this.isRegister});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: AppTheme.primary),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => GoogleAuthScreen(
                  isRegister: isRegister,
                ),
              ));
        },
        child: const Image(
          image: AssetImage(AppTheme.googleIconPath),
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
