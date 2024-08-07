import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
