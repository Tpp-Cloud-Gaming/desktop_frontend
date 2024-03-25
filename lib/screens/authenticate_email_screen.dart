import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    FirebaseAuthService authService = FirebaseAuthService();
    authService.startEmailVerificationCheck();

    return StreamBuilder<bool>(
      stream: authService.emailVerificationStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('home');
          });
          return Center(
              child: CircularProgressIndicator(
            color: Colors.grey[600],
          ));
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.grey[600],
        ));
      },
    );
  }
}
