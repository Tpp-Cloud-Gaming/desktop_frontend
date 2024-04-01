import 'package:cloud_gaming/screens/screens.dart';
import 'package:cloud_gaming/services/desktop_oauth_manager.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:flutter/material.dart';

class GoogleAuthScreen extends StatelessWidget {
  const GoogleAuthScreen({super.key});

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
                        colorFilter: ColorFilter.matrix(
                            colorGen.getHighlightedMatrix(value: 0.12)),
                        child: Image(
                            fit: BoxFit.cover,
                            height: size.height,
                            width: size.width,
                            image:
                                const AssetImage(AppTheme.loginBackgroundPath)),
                      ),
                    ),
                    Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.grey[500],
                            ),
                            const Text(
                              "Please, verify your Google Account",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ]),
                    ),
                  ],
                ),
              );
            } else {
              Future.microtask(() {
                Navigator.of(context).pushReplacementNamed("location");
              });
              return Container();
            }
          }),
    );
  }
}
