import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fhoto_editor/fhoto_editor.dart';

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();
    return Stack(
      children: [
        Container(
          color: AppTheme.primary,
          child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(colorGen.getExposureMatrix(value: 0.2)),
            child: Image(
                fit: BoxFit.cover,
                height: size.height,
                width: size.width,
                image: const AssetImage(
                    'assets/background/wallhaven-d6mkv3.jpg')), //TODO: no usar cte
          ),
        )
      ],
    );
  }
}
