import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future showRememberDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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

                    Navigator.pop(context);
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Omit",
                    style: AppTheme.commonText(AppTheme.loginButtonTextColor, 14),
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
