import 'package:cloud_gaming/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: AppTheme.primary,
        )
      ],
    );
  }
}
