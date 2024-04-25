import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: Material(
        child: Stack(
          children: [
            Container(
              color: AppTheme.primary,
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(colorGen.getHighlightedMatrix(value: 0.12)),
                child: Image(fit: BoxFit.cover, height: size.height, width: size.width, image: const AssetImage(AppTheme.loginBackgroundPath)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                    size: 35,
                  )),
            ),
            Center(
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            color: AppTheme.loginPannelColor,
                            height: size.height * 0.55,
                            width: size.width * 0.25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Image(
                                      image: AssetImage(AppTheme.logoPath),
                                      height: 95,
                                      width: 95,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30, left: 40),
                                  child: Text(
                                    "Email",
                                    style: AppTheme.loginTextStyle,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                                    child: CustomInputField(
                                      controller: emailController,
                                      obscureText: false,
                                      textType: TextInputType.emailAddress,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                    child: SizedBox(
                                      width: size.width * 0.10,
                                      height: 50,
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
                                          onPressed: () async {
                                            String email = emailController.text;
                                            if (email.isEmpty) {
                                              NotificationsService.showSnackBar("Please enter your email", Colors.red, AppTheme.loginPannelColor);
                                              return;
                                            } else {
                                              await FirebaseAuthService().resetPassword(email);
                                              NotificationsService.showSnackBar("Reset password email was send", Colors.red, AppTheme.loginPannelColor);
                                            }
                                          },
                                          child: Text(
                                            "Send",
                                            style: AppTheme.commonText(Colors.white, 18),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            )))))
          ],
        ),
      ),
    );
  }
}
