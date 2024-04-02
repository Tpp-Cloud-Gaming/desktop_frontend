import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Map<String, dynamic>> users = [
      {
        'username': 'User1',
      },
      {
        'username': 'User2',
      },
      {
        'username': 'User3',
      },
    ];
    return Scaffold(
        body: Stack(children: [
      const BackGround(),
      Row(
        children: [
          const CustomPannel(),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                  top: size.width * 0.08, left: size.height * 0.05),
              child: const Text(
                  "Valorant", //TODO: el nombre se cargaría jutno al map de users
                  style: TextStyle(color: Colors.white, fontSize: 45)),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: size.width * 0.03, left: size.width * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5)),
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

  final List<Map<String, dynamic>> users;
  final int index;

  @override
  State<UserCustomItem> createState() => _UserCustomItemState();
}

class _UserCustomItemState extends State<UserCustomItem> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
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
                  widget.users[widget.index]["username"],
                  style: TextStyle(color: color),
                )),
          ),
        ],
      ),
    );
  }
}
