import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class CustomPannel extends StatefulWidget {
  const CustomPannel({super.key});

  @override
  State<CustomPannel> createState() => _CustomPannelState();
}

class _CustomPannelState extends State<CustomPannel> {
  List<Map<String, dynamic>> items = [
    {
      'image': 'assets/pannel-icons/history.png',
      'title': 'Biblioteca',
      'page': 'settings'
    },
    {
      'image': 'assets/pannel-icons/settings.png',
      'title': 'Configuracion',
      'page': 'settings'
    },
    {
      'image': 'assets/pannel-icons/friends.png',
      'title': 'Amigos',
      'page': 'settings'
    },
    {
      'image': 'assets/pannel-icons/star.png',
      'title': 'Favoritos',
      'page': 'settings'
    },
    {
      'image': 'assets/pannel-icons/joystick.png',
      'title': 'Mis Juegos',
      'page': 'my_games'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.20,
        height: size.height,
        decoration: BoxDecoration(
          color: AppTheme.pannelColor.withOpacity(0.75),
        ),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(top: size.width * 0.01, left: 40, right: 40),
                child: const AppLogoButton(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.2, left: size.width * 0.02),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: CustomItem(item: items[index], context: context),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class AppLogoButton extends StatefulWidget {
  const AppLogoButton({
    super.key,
  });

  @override
  State<AppLogoButton> createState() => _AppLogoButtonState();
}

class _AppLogoButtonState extends State<AppLogoButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.popAndPushNamed(context, "home");
      },
      child: const Image(image: AssetImage(AppTheme.logoPath), height: 100, width: 100),
    );
  }
}

class CustomItem extends StatefulWidget {
  final BuildContext context;
  final Map<String, dynamic> item;
  const CustomItem({super.key, required this.context, required this.item});

  @override
  State<CustomItem> createState() => _CustomItemState();
}

class _CustomItemState extends State<CustomItem> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return OutlinedButton(
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
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.transparent),
      ),
      onPressed: () {
        Navigator.pushNamed(context, widget.item["page"]);
      },
      child: Row(
        children: [
          Image(
            image: AssetImage(widget.item["image"]),
            height: 40,
            width: 40,
            color: color,
            filterQuality: FilterQuality.high,
          ),
          SizedBox(width: size.width * 0.005), // 2% of width
          Text(
            widget.item["title"],
            style: TextStyle(color: color, fontSize: size.width * 0.012),
          ),
        ],
      ),
    );
  }
}
