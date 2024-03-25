import 'package:cloud_gaming/helpers/helpers.dart';
import 'package:cloud_gaming/screens/screens.dart';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/services/desktop_oauth_manager.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/services/server_service.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:fhoto_editor/fhoto_editor.dart';

class LoginScreen extends StatelessWidget {
  final ServerService server;
  const LoginScreen({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                    image: const AssetImage(
                        'assets/background/login.jpg')), //TODO: no usar cte
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
                              image: AssetImage(
                                  'assets/logo.png'), //TODO: no usar cte
                              height: 95,
                              width: 95,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 30, left: 40),
                          child: Text(
                            "Email",
                            style: TextStyle(color: Colors.white, fontSize: 22),
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
                        const Padding(
                          padding: EdgeInsets.only(top: 15, left: 40),
                          child: Text(
                            "Password",
                            style: TextStyle(color: Colors.white, fontSize: 22),
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
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(
                                color: AppTheme.loginButtonTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: const Offset(0.0, 00.0),
                                    blurRadius: 0.5,
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.8),
                                  ),
                                ],
                              ),
                            ),
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
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: AppTheme.primary),
                                  onPressed: () async {
                                    loginFunction(emailController,
                                        passwordController, context, server);
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  )),
                            ),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Text(
                                  "Need an account?",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      color: AppTheme.loginButtonTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: const Offset(0.0, 00.0),
                                          blurRadius: 0.5,
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.8),
                                        ),
                                      ],
                                    ),
                                  ),
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
