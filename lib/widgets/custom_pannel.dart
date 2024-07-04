import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class CustomPannel extends StatefulWidget {
  const CustomPannel({super.key, this.page});

  final String? page;

  @override
  State<CustomPannel> createState() => _CustomPannelState();
}

class _CustomPannelState extends State<CustomPannel> {
  List<Map<String, dynamic>> items = [
    {
      'image': 'assets/pannel-icons/games.png',
      'title': 'GAMES',
      'page': 'my_games',
      'color': const Color.fromARGB(255, 225, 186, 186).withOpacity(0.4)
    },
    {
      'image': 'assets/pannel-icons/favorite.png',
      'title': 'FAVORITES',
      'page': 'fav',
      'color': const Color.fromARGB(255, 225, 186, 186).withOpacity(0.4)
    },
    {
      'image': 'assets/pannel-icons/credits.png',
      'title': 'CREDITS',
      'page': 'coins',
      'color': const Color.fromARGB(255, 225, 186, 186).withOpacity(0.4)
    },
    {
      'image': 'assets/pannel-icons/settings.png',
      'title': 'SETTINGS',
      'page': 'settings',
      'color': const Color.fromARGB(255, 225, 186, 186).withOpacity(0.4)
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
              padding: EdgeInsets.only(top: size.height * 0.2),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CustomItem(item: items[index], context: context, page: widget.page ?? ""),
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
  final String page;
  const CustomItem({super.key, required this.context, required this.item, required this.page});

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: const BorderSide(color: Colors.transparent),
        backgroundColor: widget.item["page"] == widget.page ? const Color.fromRGBO(158, 111, 70, 0.2) : Colors.transparent,
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
                style: AppTheme.commonText(color, 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
