import 'package:cloud_gaming/theme/app_theme.dart';
import 'package:cloud_gaming/widget/widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackGround(),
          Container(
            color: AppTheme.primary,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                const Text(
                  'Home Screen',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: double.infinity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
