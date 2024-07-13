import 'package:cloud_gaming/helpers/helper_validations.dart';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future showUsernameInput(BuildContext context, FirebaseAuthService auth) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            content: UsernameAlert(
              auth: auth,
            ),
          ));
}

class UsernameAlert extends StatefulWidget {
  final FirebaseAuthService auth;
  const UsernameAlert({
    super.key,
    required this.auth,
  });

  @override
  State<UsernameAlert> createState() => _UsernameAlertState();
}

class _UsernameAlertState extends State<UsernameAlert> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    return Stack(
      children: [
        SizedBox(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Write username",
                style: AppTheme.commonText(Colors.white, 18),
              ),
              CustomInputField(
                controller: usernameController,
                obscureText: false,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
                      onPressed: () async {
                        String username = usernameController.text;
                        if (!isValidUsername(username)) {
                          usernameController.clear();
                          NotificationsService.showSnackBar("Not Valid username", Colors.red, AppTheme.loginPannelColor);
                        } else {
                          bool result = await widget.auth.changeUsername(username);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("username", username);

                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Confirm",
                        style: AppTheme.commonText(Colors.white, 18),
                      )),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
