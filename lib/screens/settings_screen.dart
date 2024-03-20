import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [BackGround(), CustomPannel()],
      ),
    );
  }
}
