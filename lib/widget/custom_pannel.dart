import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomPannel extends StatefulWidget {
  const CustomPannel({super.key});

  @override
  State<CustomPannel> createState() => _CustomPannelState();
}

class _CustomPannelState extends State<CustomPannel> {
  List<Map<String, dynamic>> items = [
    {
      'image': 'assets/pannel-icons/friends.png',
      'title': 'Home',
    },
    {
      'image': 'assets/pannel-icons/history.png',
      'title': 'Profile',
    },
    {
      'image': 'assets/pannel-icons/settings.png',
      'title': 'Settings',
    },
    {
      'image': 'assets/pannel-icons/star.png',
      'title': 'Logout',
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
            Container(
              child: Text(
                "ICONO",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.2, left: size.width * 0.02),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: CustomItem(
                        title: items[index]['title'],
                        imgPath: items[index]['image']),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class CustomItem extends StatefulWidget {
  final String title;
  final String imgPath;
  const CustomItem({super.key, required this.title, required this.imgPath});

  @override
  State<CustomItem> createState() => _CustomItemState();
}

class _CustomItemState extends State<CustomItem> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.transparent),
      ),
      onPressed: () {},
      child: Row(
        children: [
          Image(
            image: AssetImage(widget.imgPath),
            height: 40,
            width: 40,
            color: Colors.white,
            filterQuality: FilterQuality.high,
          ),
          SizedBox(width: size.width * 0.005), // 2% of width
          Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
