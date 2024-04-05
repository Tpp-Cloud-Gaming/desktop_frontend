import 'package:cloud_gaming/screens/authentication/login_screen.dart';
import 'package:cloud_gaming/services/server_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fhoto_editor/fhoto_editor.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();
    return Stack(
      children: [
        Container(
          color: AppTheme.primary,
          child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(colorGen.getExposureMatrix(value: 0.2)),
            child: Image(
                fit: BoxFit.cover,
                height: size.height,
                width: size.width,
                image: const AssetImage(AppTheme.appBackgroundPath)),
          ),
        ),
        const Positioned(
          top: 30,
          right: 40,
          child: ProfileCard(),
        ),
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Color color = AppTheme.pannelColor.withOpacity(0.75);
  Color personColor = Colors.grey.withOpacity(0.6);
  String _username = "user";
  bool showWidget = false;
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Method to load the shared preference data
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'user';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () {
          setState(() {
            showWidget = !showWidget;
          });
        },
        onHover: (value) {
          if (!showWidget) {
            if (value) {
              setState(() {
                color = AppTheme.onHoverColor.withOpacity(0.7);
                personColor = Colors.black.withOpacity(0.6);
              });
            } else {
              setState(() {
                color = AppTheme.pannelColor.withOpacity(0.75);
                personColor = Colors.grey.withOpacity(0.6);
              });
            }
          }
        },
        child: Column(
          children: [
            Container(
              color: color,
              height: 75,
              width: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.person, color: personColor, size: 40),
                  Text(
                    _username.length > 14
                        ? "${_username.substring(0, 11)}..."
                        : _username,
                    style: AppTheme.commonText(Colors.white, 14),
                  ),
                ],
              ),
            ),
            showWidget
                ? Container(
                    color: AppTheme.pannelColor.withOpacity(0.75),
                    height: 40,
                    width: 160,
                    child: ListTile(
                      focusColor: AppTheme.onHoverColor.withOpacity(0.7),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            "Log Out",
                            style: AppTheme.commonText(Colors.white, 14),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool("remember", false);
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => LoginScreen(),
                            ));
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
