import 'package:cloud_gaming/helpers/helpers.dart';
import 'package:cloud_gaming/helpers/remember_helper.dart';
import 'package:cloud_gaming/screens/screens.dart';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/services/server_service.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:fhoto_editor/fhoto_editor.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    ServerService server = ServerService();
    server.start();
    //server.sendMessage("Hola desde Flutter");

    return Scaffold(
      body: Material(
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
                    image: const AssetImage(AppTheme.loginBackgroundPath)),
              ),
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
                            padding: const EdgeInsets.only(
                                top: 10, left: 40, right: 40),
                            child: CustomInputField(
                              controller: emailController,
                              obscureText: false,
                              textType: TextInputType.emailAddress,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 40),
                          child: Text(
                            "Password",
                            style: AppTheme.loginTextStyle,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 40, right: 40),
                            child: CustomInputField(
                              controller: passwordController,
                              obscureText: true,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 10),
                          child: InkWell(
                            onTap: () {},
                            child: Text("Forgot your password?",
                                style: AppTheme.loginTextButtonsStyle),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                              child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.10,
                                    height: 50,
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            backgroundColor: AppTheme.primary),
                                        onPressed: () async {
                                          loginFunction(
                                              emailController,
                                              passwordController,
                                              context,
                                              server);
                                        },
                                        child: Text(
                                          "Login",
                                          style: AppTheme.commonText(
                                              Colors.white, 18),
                                        )),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: GoogleLoginButton(
                                      isRegister: false,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Text(
                                  "Need an account?",
                                  style: AppTheme.commonText(Colors.white, 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              RegisterScreen(server: server),
                                        ));
                                  },
                                  child: Text("Register",
                                      style: AppTheme.loginTextButtonsStyle),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void loginFunction(
    TextEditingController emailController,
    TextEditingController passwordController,
    BuildContext context,
    ServerService server) async {
  String email = emailController.text;
  String password = passwordController.text;

  bool validUsername = isValidEmail(email);
  bool validPassword = isValidPassword(password);

  FirebaseAuthService authService = FirebaseAuthService();
  if (!validUsername || !validPassword) {
    //Mensaje por pantalla de error
    passwordController.clear();
    NotificationsService.showSnackBar(
        "Invalid Email or Password", Colors.red, AppTheme.loginPannelColor);
  } else {
    final String? resp = await authService.loginUser(email, password);
    if (resp != null) {
      passwordController.clear();
      NotificationsService.showSnackBar(
          resp, Colors.red, AppTheme.loginPannelColor);
      return;
    } else {
      //if (await authService.isEmailVerified()) {

      server.login(email, password, context);
      emailController.clear();
      passwordController.clear();
      await ShowRememberDialog(context);

      // } else {
      //   NotificationsService.showSnackBar(
      //       "Email isn´t verified, we resend the email verification for you",
      //       Colors.red,
      //       AppTheme.loginPannelColor);
      //   await authService.sendEmailVerification();
      // }
    }
  }
}
