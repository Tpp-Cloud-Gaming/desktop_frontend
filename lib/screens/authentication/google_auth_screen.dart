import 'package:cloud_gaming/helpers/google_username_helper.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/desktop_oauth_manager.dart';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthScreen extends StatelessWidget {
  final bool isRegister;
  const GoogleAuthScreen({super.key, required this.isRegister});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();

    return Scaffold(
      body: FutureBuilder(
          future: DesktopOAuthManager().signInWithGoogle(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Material(
                child: Stack(
                  children: [
                    Container(
                      color: AppTheme.primary,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(colorGen.getHighlightedMatrix(value: 0.12)),
                        child: Image(fit: BoxFit.cover, height: size.height, width: size.width, image: const AssetImage(AppTheme.loginBackgroundPath)),
                      ),
                    ),
                    Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        CircularProgressIndicator(
                          color: Colors.grey[500],
                        ),
                        const Text(
                          "Please, verify your Google Account",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            } else {
              Future.microtask(() async {
                if (isRegister) {
                  registerUserInBack(context);
                }
                Navigator.of(context).pushReplacementNamed("home");
              });
              return Stack(
                children: [
                  Container(
                    color: AppTheme.primary,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(colorGen.getHighlightedMatrix(value: 0.12)),
                      child: Image(fit: BoxFit.cover, height: size.height, width: size.width, image: const AssetImage(AppTheme.loginBackgroundPath)),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}

void registerUserInBack(BuildContext context) async {
  FirebaseAuthService firebaseAuth = FirebaseAuthService();
  await showUsernameInput(context, firebaseAuth);
  String email = firebaseAuth.getEmail() ?? "";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  double latitude = prefs.getDouble("latitude") ?? 0;
  double longitude = prefs.getDouble("longitude") ?? 0;
  String username = prefs.getString("username") ?? "";

  Map<String, dynamic> values = {
    "username": username,
    "email": email,
    "latitude": latitude,
    "longitude": longitude,
    "credits": 0
  };

  String? resp = await BackendService().createUser(values, false);
}
