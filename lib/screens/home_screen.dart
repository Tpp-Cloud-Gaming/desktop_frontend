import 'package:cloud_gaming/theme/app_theme.dart';
import 'package:cloud_gaming/widget/widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //esto vendría de un request a la API
    List<Map<String, dynamic>> games = [
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

    return Scaffold(
      body: Stack(
        children: [
          const BackGround(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomPannel(),
              // Padding(
              //     padding: const EdgeInsets.only(left: 20.0),
              //     child: ListView(children: [
              // GridView.builder(
              //   gridDelegate:
              //       const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2, // number of items in each row
              //     mainAxisSpacing: 8.0, // spacing between rows
              //     crossAxisSpacing: 8.0, // spacing between columns
              //   ),
              //   itemCount: games.length,
              //   itemBuilder: (context, index) {
              //     return Text(
              //       "HOLA",
              //       style: TextStyle(color: Colors.white),
              //     );
              //   },
              // ),
              // ]))
            ],
          ),
        ],
      ),
    );
  }
}
