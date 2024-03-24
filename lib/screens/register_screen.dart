import 'package:cloud_gaming/helpers/helpers.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/services/server_service.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:fhoto_editor/fhoto_editor.dart';

class RegisterScreen extends StatelessWidget {
  final ServerService server;
  const RegisterScreen({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();

    TextEditingController emailController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
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
                              textType: TextInputType.emailAddress,
                              obscureText: false,
                            )),
                        const Padding(
                          padding: EdgeInsets.only(top: 15, left: 40),
                          child: Text(
                            "Username",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 40, right: 40),
                            child: CustomInputField(
                              controller: usernameController,
                              obscureText: false,
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
                          padding: const EdgeInsets.only(top: 40),
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
                                  onPressed: () {
                                    String email = emailController.text;
                                    String username = usernameController.text;
                                    String password = passwordController.text;

                                    bool validEmail = isValidEmail(email);
                                    bool validUsername =
                                        isValidUsername(username);
                                    bool validPassword =
                                        isValidPassword(password);

                                    if (!validUsername ||
                                        !validPassword ||
                                        !validEmail) {
                                      //Mensaje por pantalla de error
                                      passwordController.clear();
                                      NotificationsService.showSnackBar(
                                          "Not Valid credentials",
                                          Colors.red,
                                          AppTheme.loginPannelColor);
                                    } else {
                                      server.register(
                                          email, username, password, context);
                                      usernameController.clear();
                                      passwordController.clear();
                                      emailController.clear();
                                    }
                                  },
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  )),
                            ),
                          )),
                        ),
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
