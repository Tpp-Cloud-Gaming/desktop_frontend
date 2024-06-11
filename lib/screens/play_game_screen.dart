import 'dart:async';
import 'dart:ui';

import 'package:cloud_gaming/Providers/user_provider.dart';
import 'package:cloud_gaming/Providers/web_socket_provider.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/services/rust_communication_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayGameScreen extends StatefulWidget {
  const PlayGameScreen({super.key});

  @override
  State<PlayGameScreen> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  @override
  Widget build(BuildContext context) {
    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: true);

    return FutureBuilder(
        future: negociateSession(context, webSocketProvider.currentSession!),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            final colorGen = ColorFilterGenerator.getInstance();
            final size = MediaQuery.of(context).size;
            return Material(
              child: Stack(
                children: [
                  Container(
                    color: AppTheme.primary,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(colorGen.getHighlightedMatrix(value: 0.12)),
                      child: Image(fit: BoxFit.cover, height: size.height, width: size.width, image: const AssetImage(AppTheme.loginBackgroundPath)),
                    ),
                  ),
                  Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      CircularProgressIndicator(
                        color: Colors.grey[500],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          } else {
            if (!webSocketProvider.isConnected) {
              Navigator.popAndPushNamed(context, "home");
              NotificationsService.showSnackBar("Session is disconnected", Colors.red, AppTheme.loginPannelColor);
            }
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
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: GameTimer(),
                            ),
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
          }
        });
  }
}

Future<bool> negociateSession(BuildContext context, Session session) async {
  //Esto lo hace una vez tenga la aprobacion en ek back
  // -> aca mandar a la api validacion de creditos
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  RustCommunicationService rustCommunicationService = RustCommunicationService();
  await rustCommunicationService.connect(2930);
  rustCommunicationService.startGameWithUser(userProvider.user["username"], session.offerer, session.gameName);
  rustCommunicationService.disconnect();
  final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
  webSocketProvider.setConnected(true);
  return Future(() => true);
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
                        RustCommunicationService rustCommunicationService = RustCommunicationService();
                        await rustCommunicationService.connect(3132);
                        rustCommunicationService.endSession();
                        rustCommunicationService.disconnect();
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
  const GameTimer({super.key});

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  int minutes = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {
        minutes++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: segun el tiempo restante de sesion verde, amarillo o rojo
    return Text("$minutes minutes elapsed", style: AppTheme.commonText(Colors.green.withOpacity(0.7), 40));
  }
}
