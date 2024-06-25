import 'dart:ui';

import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:cloud_gaming/widgets/custom_pannel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCoinsScreen extends StatelessWidget {
  const MyCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<UserProvider>(context, listen: true);

    int totalMinutes = provider.credits;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    String formattedTime = "$hours hours and $minutes minutes";

    int hourPrice = 3000;
    return Material(
      child: Stack(
        children: [
          const BackGround(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              size.width > 1400 ? const CustomPannel() : Container(),
              Padding(
                padding: EdgeInsets.only(top: size.width * 0.08, left: size.height * 0.05),
                child: Container(
                  height: 500,
                  width: size.width > 1400 ? size.width * 0.55 : size.width * 0.9,
                  decoration: BoxDecoration(color: AppTheme.pannelColor.withOpacity(0.45), borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Available time:", style: AppTheme.commonText(Colors.white, 34)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 20),
                                  child: Text(formattedTime, style: AppTheme.commonText(Colors.white, 24)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 80),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white, width: 2), color: const Color.fromARGB(255, 25, 0, 59).withOpacity(0.3)),
                              height: 300,
                              width: 500,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LoadHours(
                                    hours: "1",
                                    price: hourPrice.toString(),
                                  ),
                                  LoadHours(
                                    hours: "3",
                                    price: (hourPrice * 3).toString(),
                                  ),
                                  LoadHours(
                                    hours: "5",
                                    price: (hourPrice * 5).toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LoadHours extends StatefulWidget {
  const LoadHours({super.key, required this.hours, required this.price});
  final String hours;
  final String price;

  @override
  State<LoadHours> createState() => _LoadHoursState();
}

class _LoadHoursState extends State<LoadHours> {
  Color color = Colors.white;
  double scale = 1.0;
  double opacity = 0.5;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WebSocketProvider>(context, listen: true);
    return Container(
      height: 270,
      width: 140,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white, width: 3), color: const Color.fromARGB(255, 25, 0, 59).withOpacity(opacity)),
      child: InkWell(
        onHover: (value) {
          if (value) {
            setState(() {
              scale = 1.1;
              opacity = 1.0;
            });
          } else {
            setState(() {
              scale = 1.0;
              opacity = 0.5;
            });
          }
        },
        onTap: () async {
          final user = Provider.of<UserProvider>(context, listen: false);

          Map<String, dynamic>? resp = await BackendService().loadCredits(int.parse(widget.hours), user.user["username"]);
          if (resp == null) {
            NotificationsService.showSnackBar("Error locading payment: $resp", Colors.red, AppTheme.loginPannelColor);
          } else {
            if (resp["url"] != null) {
              //Sirve para probar pagos, dsp comentar
              print(resp["url"]);
              provider.setAccredit(false);
              _launchInBrowser(Uri.parse(resp["url"]));
              Navigator.popAndPushNamed(context, "waitAccredit");
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Transform.scale(
              scale: scale,
              child: SizedBox(
                height: 130,
                width: 140,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Hours",
                        style: AppTheme.commonText(color, 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        widget.hours,
                        style: AppTheme.commonText(color, 34),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: 140,
              height: 3,
            ),
            Transform.scale(
              scale: scale,
              child: SizedBox(
                height: 130,
                width: 140,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Price",
                        style: AppTheme.commonText(color, 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        widget.price,
                        style: AppTheme.commonText(color, 34),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
