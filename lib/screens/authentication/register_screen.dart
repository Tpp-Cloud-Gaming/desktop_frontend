import 'package:cloud_gaming/helpers/helpers.dart';
import 'package:cloud_gaming/helpers/remember_helper.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/services/server_service.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                    height: 600,
                    width: 480,
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
                          padding: const EdgeInsets.only(top: 5, left: 40),
                          child: Text(
                            "Email",
                            style: AppTheme.loginTextStyle,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: CustomInputField(
                              controller: emailController,
                              textType: TextInputType.emailAddress,
                              obscureText: false,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 40),
                          child: Text(
                            "Username",
                            style: AppTheme.loginTextStyle,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: CustomInputField(
                              controller: usernameController,
                              obscureText: false,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 40),
                          child: Text(
                            "Password",
                            style: AppTheme.loginTextStyle,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: CustomInputField(
                              controller: passwordController,
                              obscureText: true,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                              child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 40, right: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.10,
                                    height: 50,
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
                                        onPressed: () async {
                                          registerFunction(emailController, usernameController, passwordController, context);
                                        },
                                        child: Text(
                                          "Register",
                                          style: AppTheme.commonText(Colors.white, 18),
                                        )),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: GoogleLoginButton(
                                      isRegister: true,
                                    ),
                                  )
                                ],
                              ),
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

void registerFunction(TextEditingController emailController, TextEditingController usernameController, TextEditingController passwordController, BuildContext context) async {
  String email = emailController.text;
  String username = usernameController.text;
  String password = passwordController.text;

  bool validEmail = isValidEmail(email);
  bool validUsername = isValidUsername(username);
  bool validPassword = isValidPassword(password);

  if (!validUsername || !validPassword || !validEmail) {
    //Mensaje por pantalla de error
    passwordController.clear();
    NotificationsService.showSnackBar("Not Valid credentials", Colors.red, AppTheme.loginPannelColor);
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble("latitude") ?? 0;
    double longitude = prefs.getDouble("longitude") ?? 0;
    Map<String, dynamic> values = {
      "email": email,
      "username": username,
      "password": password,
      "latitude": latitude,
      "longitude": longitude
    };

    String? result = await BackendService().createUser(values, true);
    usernameController.clear();
    passwordController.clear();
    emailController.clear();
    await showRememberDialog(context);
    Navigator.of(context).pushReplacementNamed("home");
  }
}
