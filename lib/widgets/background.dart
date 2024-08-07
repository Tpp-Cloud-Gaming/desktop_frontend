import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/screens/authentication/login_screen.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();
    final provider = Provider.of<UserProvider>(context, listen: true);

    return Stack(
      children: [
        Container(
          color: AppTheme.primary,
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(colorGen.getExposureMatrix(value: 0.2)),
            child: Image(fit: BoxFit.cover, height: size.height, width: size.width, image: const AssetImage(AppTheme.appBackgroundPath)),
          ),
        ),
        Positioned(
          top: 30,
          right: 40,
          child: ProfileCard(provider: provider),
        ),
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  final UserProvider provider;
  const ProfileCard({
    super.key,
    required this.provider,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Color color = AppTheme.pannelColor.withOpacity(0.75);
  Color personColor = Colors.grey.withOpacity(0.6);
  bool showWidget = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String username = (widget.provider.user["username"] ?? "").toUpperCase();
    int credits = widget.provider.user["credits"] ?? 0;
    int hours = credits ~/ 60;
    int minutes = credits % 60;
    String hoursString = hours.toString();
    String minutesString = minutes.toString();

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () {
          // setState(() {
          //   showWidget = !showWidget;
          // });
          Navigator.popAndPushNamed(context, "coins");
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
              height: 60,
              width: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.person, color: personColor, size: 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 15),
                    child: Text(
                      username.length > 14 ? "${username.substring(0, 11)}..." : username,
                      style: AppTheme.commonText(Colors.white.withOpacity(0.6), 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Image.asset(
                      color: personColor,
                      "assets/background/watch.png",
                      height: 40,
                      width: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "${hoursString}h ${minutesString}min",
                      style: AppTheme.commonText(Colors.white.withOpacity(0.6), 18),
                    ),
                  ),
                ],
              ),
            ),
            // showWidget
            //     ? Container(
            //         color: AppTheme.pannelColor.withOpacity(0.75),
            //         height: 40,
            //         width: 200,
            //         child: ListTile(
            //           focusColor: AppTheme.onHoverColor.withOpacity(0.7),
            //           title: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               const Icon(
            //                 Icons.logout_rounded,
            //                 color: Colors.white,
            //               ),
            //               Text(
            //                 "Log Out",
            //                 style: AppTheme.commonText(Colors.white, 14),
            //               ),
            //             ],
            //           ),
            //           onTap: () async {
            //             shutdown(context);
            //           },
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}

void shutdown(BuildContext context) async {
  //Clean the shared preferences
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("remember", false);
  prefs.setString('email', '');
  prefs.setString('password', '');
  prefs.setString('username', '');

  //Clean the providers
  final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  final WebSocketProvider webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
  //final TcpProvider tcpProvider = Provider.of<TcpProvider>(context, listen: false);

  userProvider.shutdown();
  await webSocketProvider.shutdown();
  //tcpProvider.disconnect();

  Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreen(),
      ));
}
