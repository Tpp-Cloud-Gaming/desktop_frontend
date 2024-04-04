import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future ShowRememberDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            content: const RememberAlert(),
          ));
}

class RememberAlert extends StatefulWidget {
  const RememberAlert({
    super.key,
  });

  @override
  State<RememberAlert> createState() => _RememberAlertState();
}

class _RememberAlertState extends State<RememberAlert> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CheckboxListTile(
                  title: Text("Remember account?",
                      style: AppTheme.commonText(
                        Colors.black,
                        14,
                      )),
                  value: value,
                  onChanged: (newValue) async {
                    setState(() {
                      value = newValue!;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("remember", newValue ?? false);
                    Navigator.pushNamed(context, 'location');
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'home');
                  },
                  child: Text(
                    "Omit",
                    style:
                        AppTheme.commonText(AppTheme.loginButtonTextColor, 14),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class RememberCheck extends StatefulWidget {
  const RememberCheck({super.key});

  @override
  State<RememberCheck> createState() => _RememberCheckState();
}

class _RememberCheckState extends State<RememberCheck> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 70, right: size.width * 0.125, top: 10),
      child: CheckboxListTile(
          title: const Text("Remember",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              )),
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue!;
            });
          }),
    );
  }
}
