import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.gameName});
  final String gameName;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: true);
    List<User> users = webSocketProvider.getUsersByGame(gameName);

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
                        Text(gameName, style: const TextStyle(color: Colors.white, fontSize: 45)),
                        FavGameButton(
                          gameName: gameName,
                          prefs: snapshot.data as SharedPreferences,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.width * 0.03, left: size.width * 0.05),
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
  });

  final List<User> users;
  final int index;

  @override
  State<UserCustomItem> createState() => _UserCustomItemState();
}

class _UserCustomItemState extends State<UserCustomItem> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    final rustComunicationProvider = Provider.of<RustCommunicationProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        //RustCommunicationService rustCommunicationService = RustCommunicationService(rustComunicationProvider.socket);
        //rustCommunicationService.startGameWithUser(userProvider.user["username"], widget.users[widget.index].username);
        //si todo sale bien:
        final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
        webSocketProvider.setConnected(true);
        Navigator.pushNamed(context, "play_game");
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
