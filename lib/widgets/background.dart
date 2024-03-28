import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:geolocator/geolocator.dart';

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
                image: const AssetImage(AppTheme.appBackgroundPath)),
          ),
        ),
        Positioned(
          top: 30,
          right: 40,
          child: ProfileCard(),
        )
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Color color = AppTheme.pannelColor.withOpacity(0.75);
  Color personColor = Colors.grey.withOpacity(0.6);

  @override
  Widget build(BuildContext context) {
    String username = "username";
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          if (value) {
            setState(() {
              color = AppTheme.onHoverColor.withOpacity(0.7);
              personColor = Colors.black.withOpacity(0.6);
            });
          } else {
            setState(() {
              color = AppTheme.pannelColor.withOpacity(0.75);
              personColor = Colors.grey.withOpacity(0.6);
            });
          }
        },
        child: Container(
          color: color,
          height: 75,
          width: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.person, color: personColor, size: 40),
              Text(
                username.length > 14
                    ? "${username.substring(0, 11)}..."
                    : username, //TODO: load real username
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
