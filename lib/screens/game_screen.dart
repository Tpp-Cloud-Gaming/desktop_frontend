import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/services/rust_communication_service.dart';
import 'package:cloud_gaming/Providers/web_socket_provider.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.gameName});
  final String gameName;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: true);
    List<User> users = webSocketProvider.getUsersByGame(gameName);

    return Scaffold(
        body: Stack(children: [
      const BackGround(),
      Row(
        children: [
          const CustomPannel(),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(top: size.width * 0.08, left: size.height * 0.05),
              child: Text(gameName, style: TextStyle(color: Colors.white, fontSize: 45)),
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
