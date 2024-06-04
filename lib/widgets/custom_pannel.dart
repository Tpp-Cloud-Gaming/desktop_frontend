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
      'image': 'assets/pannel-icons/joystick.png',
      'title': 'My Games',
      'page': 'my_games',
      'color': Colors.white
    },
    {
      'image': 'assets/pannel-icons/favourite.png',
      'title': 'Favourites',
      'page': 'fav',
      'color': Colors.red.withOpacity(0.8)
    },
    {
      'image': 'assets/pannel-icons/load_coin.png',
      'title': 'My Coins',
      'page': 'coins',
      'color': null
    },
    {
      'image': 'assets/pannel-icons/settings.png',
      'title': 'Settings',
      'page': 'settings',
      'color': Colors.white
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width > 1800 ? 350 : 280,
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
  int imgSize = 40;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return OutlinedButton(
      onHover: (value) {
        if (value) {
          setState(() {
            color = AppTheme.onHoverColor.withOpacity(0.7);
            imgSize = 45;
          });
        } else {
          setState(() {
            color = Colors.white;
            imgSize = 40;
          });
        }
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.transparent),
      ),
      onPressed: () {
        Navigator.pushNamed(context, widget.item["page"]);
      },
      child: SizedBox(
        height: imgSize.toDouble(),
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(widget.item["image"]),
              height: imgSize.toDouble(),
              width: imgSize.toDouble(),
              color: widget.item["color"],
              filterQuality: FilterQuality.high,
            ),
            SizedBox(width: size.width * 0.005), // 2% of width
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.item["title"],
                style: AppTheme.commonText(color, 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
