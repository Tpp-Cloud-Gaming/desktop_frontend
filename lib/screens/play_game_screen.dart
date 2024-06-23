import 'dart:async';
import 'dart:ui';

import 'package:cloud_gaming/Providers/tcp_provider.dart';
import 'package:cloud_gaming/Providers/web_socket_provider.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_gaming/widgets/back_home_button.dart';

class PlayGameScreen extends StatelessWidget {
  const PlayGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: true);

    if (webSocketProvider.activeSession) {
      return Material(
        child: Stack(
          children: [
            const BackGround(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 80),
                  child: Row(
                    children: [
                      Text("Your session is in progress", style: AppTheme.commonText(Colors.white, 50)),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 20.0),
                      //   child: GameTimer(session: webSocketProvider.currentSession!),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 80),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary.withOpacity(0.7)),
                      onPressed: () async {
                        _showCreateDialog(context);
                      },
                      child: Text(
                        "STOP SESSION",
                        style: AppTheme.commonText(Colors.red, 18),
                      )),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Material(
        child: Stack(
          children: [
            const BackGround(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your session has ended.", style: AppTheme.commonText(Colors.white, 30)),
                const Padding(padding: EdgeInsets.only(top: 40, left: 80), child: BackHomeButton()),
              ],
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
            height: 200,
            width: 500,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text("Are you sure you want to stop the session?", style: AppTheme.commonText(Colors.black, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.loginButtonColor),
                      onPressed: () async {
                        //Notificar el stop de la sesion
                        final tcpProvider = Provider.of<TcpProvider>(context, listen: false);
                        tcpProvider.endSession();

                        final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
                        webSocketProvider.activeSession = false;
                        Navigator.popAndPushNamed(context, "home");
                        return;
                      },
                      child: Text(
                        "YES",
                        style: AppTheme.commonText(Colors.black, 18),
                      )),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.loginButtonColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                        return;
                      },
                      child: Text(
                        "NO",
                        style: AppTheme.commonText(Colors.black, 18),
                      ))
                ],
              )
            ]),
          )),
        );
      });
}

class GameTimer extends StatefulWidget {
  final Session session;
  const GameTimer({super.key, required this.session});

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  int minutes = 0;

  @override
  void initState() {
    Timer timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {
        minutes++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if ((widget.session.minutes) > 60) {
      textColor = Colors.green.withOpacity(0.7);
    } else if ((widget.session.minutes) > 30) {
      textColor = Colors.yellow.withOpacity(0.7);
    } else {
      textColor = Colors.red.withOpacity(0.7);
    }
    return Text("$minutes minutes elapsed of ${(widget.session.minutes)}", style: AppTheme.commonText(textColor, 40));
  }
}
