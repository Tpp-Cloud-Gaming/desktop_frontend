import 'dart:ui';

import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/helpers/helper_validations.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/services/rust_communication_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.game});
  final Map<String, dynamic> game;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: true);
    List<User> users = webSocketProvider.getUsersByGame(game["name"]);

    String description = game["description"];
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
              body: Stack(children: [
            const BackGround(),
            Row(
              children: [
                const CustomPannel(),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.width * 0.08, left: size.height * 0.05),
                    child: Row(
                      children: [
                        Text(game["name"], style: const TextStyle(color: Colors.white, fontSize: 45)),
                        FavGameButton(
                          gameName: game["name"],
                          prefs: snapshot.data as SharedPreferences,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(game["category"], style: AppTheme.commonText(Colors.white, 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(description.toString().substring(0, description.length > 100 ? 100 : description.length), style: AppTheme.commonText(Colors.white, 20)),
                  ),
                  description.length > 100
                      ? Padding(
                          padding: EdgeInsets.only(left: size.width * 0.03),
                          child: Text(description.toString().substring(100, description.length > 200 ? 200 : description.length), style: AppTheme.commonText(Colors.white, 20)),
                        )
                      : Container(),
                  description.length > 200
                      ? Padding(
                          padding: EdgeInsets.only(left: size.width * 0.03),
                          child: Text(description.toString().substring(200, description.length > 300 ? 300 : description.length), style: AppTheme.commonText(Colors.white, 20)),
                        )
                      : Container(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.width * 0.02, left: size.width * 0.05),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                        height: 100,
                        width: size.width * 0.55,
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                UserCustomItem(
                                  users: users,
                                  index: index,
                                  gameName: game["name"],
                                ),
                                Container(
                                  height: 1,
                                  width: size.width * 0.55,
                                  color: Colors.black.withOpacity(0.2),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ]));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class FavGameButton extends StatefulWidget {
  FavGameButton({
    super.key,
    required this.gameName,
    required this.prefs,
  });

  final String gameName;
  SharedPreferences prefs;

  @override
  State<FavGameButton> createState() => _FavGameButtonState();
}

class _FavGameButtonState extends State<FavGameButton> {
  Icon icon = const Icon(Icons.favorite_outline_rounded, color: Colors.red, size: 40);
  bool active = false;

  @override
  Widget build(BuildContext context) {
    final List<String>? games = widget.prefs.getStringList('favGames');
    if (games == null) {
      active = false;
    } else {
      if (games.contains(widget.gameName)) {
        active = true;
      } else {
        active = false;
      }
    }
    if (!active) {
      icon = const Icon(Icons.favorite_outline_rounded, color: Colors.red, size: 40);
    } else {
      icon = const Icon(Icons.favorite_outlined, color: Colors.red, size: 40);
    }
    return Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: InkWell(
          onTap: () async {
            final List<String>? games = widget.prefs.getStringList('favGames');
            if (games == null) {
              await widget.prefs.setStringList('favGames', <String>[
                widget.gameName
              ]);
            } else {
              if (games.contains(widget.gameName)) {
                games.remove(widget.gameName);
                await widget.prefs.setStringList('favGames', games);
              } else {
                games.add(widget.gameName);
                await widget.prefs.setStringList('favGames', games);
              }
            }
            setState(() {
              active = !active;
            });
          },
          child: icon,
        ));
  }
}

class UserCustomItem extends StatefulWidget {
  const UserCustomItem({
    super.key,
    required this.users,
    required this.index,
    required this.gameName,
  });

  final String gameName;
  final List<User> users;
  final int index;

  @override
  State<UserCustomItem> createState() => _UserCustomItemState();
}

class _UserCustomItemState extends State<UserCustomItem> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return InkWell(
      onTap: () async {
        //disparar un dialog para cargar cantidad de hs y que el back lo apruebe
        showNegociationDialog(context);

        //Esto lo hace una vez tenga la aprobacion en ek back
        // RustCommunicationService rustCommunicationService = RustCommunicationService();
        // await rustCommunicationService.connect(2930);
        // rustCommunicationService.startGameWithUser(userProvider.user["username"], widget.users[widget.index].username, widget.gameName);
        // rustCommunicationService.disconnect();
        // final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
        // webSocketProvider.setConnected(true);
        // Navigator.pushNamed(context, "play_game");
      },
      onHover: (value) {
        if (value) {
          setState(() {
            color = AppTheme.onHoverColor.withOpacity(0.7);
          });
        } else {
          setState(() {
            color = Colors.white;
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Icon(
              Icons.computer_sharp,
              color: color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20),
            child: SizedBox(
                height: 40,
                child: Text(
                  widget.users[widget.index].username,
                  style: TextStyle(color: color, fontSize: 22),
                )),
          ),
          Expanded(child: Container()),
          const Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Icon(
              Icons.star,
              color: Colors.yellow,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Text(
              widget.users[widget.index].calification.toString(),
              style: TextStyle(color: color, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}

showNegociationDialog(BuildContext context) {
  TextEditingController controller = TextEditingController();

  final userProvider = Provider.of<UserProvider>(context, listen: false);

  showDialog(
      context: context,
      builder: (context) {
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
              width: 550,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "How many hours do you want to play?",
                    style: AppTheme.commonText(Colors.white, 22),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: CustomInputField(
                      controller: controller,
                      obscureText: false,
                      hintText: "Hours",
                      textType: TextInputType.number,
                    ),
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
                      onPressed: () {
                        String hours = controller.text;

                        try {
                          if (userProvider.user["credits"] < int.parse(hours)) {
                            Navigator.pop(context);
                            NotificationsService.showSnackBar("You don't have enough credits", Colors.red, AppTheme.loginPannelColor);
                          } else {
                            //Aca iria la logica de validacion
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                          controller.clear();
                        }
                      },
                      child: Text(
                        "Confirm",
                        style: AppTheme.commonText(Colors.white, 18),
                      )),
                ],
              ),
            ),
          ),
        );
      });
}
