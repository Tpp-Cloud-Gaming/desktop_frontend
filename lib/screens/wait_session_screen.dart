import 'dart:ui';
import 'package:cloud_gaming/Providers/tcp_provider.dart';
import 'package:cloud_gaming/Providers/web_socket_provider.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitSessionScreen extends StatefulWidget {
  const WaitSessionScreen({super.key});

  @override
  State<WaitSessionScreen> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<WaitSessionScreen> {
  @override
  Widget build(BuildContext context) {
    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: true);

    if (webSocketProvider.activeSession) {
      return Material(
        child: Stack(
          children: [
            const BackGround(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("YOUR SESSION IS IN PROGRESS", style: AppTheme.commonText(Colors.white, 40, FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: const Color(0xFFD9D9D9)),
                        onPressed: () async {
                          _showCreateDialog(context);
                        },
                        child: Text(
                          "STOP SESSION",
                          style: AppTheme.commonText(const Color(0xFF902424), 18, FontWeight.bold),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Material(
        child: Stack(
          children: [
            const BackGround(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("WAITING SESSION...", style: AppTheme.commonText(Colors.white, 40, FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 25),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: const Color(0xFFD9D9D9)),
                        onPressed: () async {
                          _showCreateDialog(context);
                        },
                        child: Text(
                          "STOP SESSION",
                          style: AppTheme.commonText(const Color(0xFF902424), 18, FontWeight.bold),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}

void _showCreateDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.5),
                width: 1.0,
              ),
              color: const Color(0xff0c1d43),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2, // changes position of shadow
                ),
              ],
            ),
            height: 300,
            width: 700,
            child: Center(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text("Are you sure you want to stop the session?", style: AppTheme.commonText(Colors.white, 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: const Color(0xFFD9D9D9)),
                        onPressed: () async {
                          //Notificar el stop de la sesion
                          final tcpProvider = Provider.of<TcpProvider>(context, listen: false);
                          tcpProvider.endSession();
                          Navigator.popAndPushNamed(context, "home");
                          return;
                        },
                        child: Text(
                          "YES",
                          style: AppTheme.commonText(AppTheme.primary, 18, FontWeight.bold),
                        )),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: const Color(0xFFD9D9D9)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          return;
                        },
                        child: Text(
                          "NO",
                          style: AppTheme.commonText(AppTheme.primary, 18, FontWeight.bold),
                        ))
                  ],
                )
              ]),
            ),
          )),
        );
      });
}
