import 'package:cloud_gaming/screens/screens.dart';
import 'package:cloud_gaming/services/desktop_oauth_manager.dart';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleAuthScreen extends StatelessWidget {
  const GoogleAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: DesktopOAuthManager().signInWithGoogle(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.grey[500],
                  )
                ]);
          } else {
            return HomeScreen();
          }
        });
  }
}
