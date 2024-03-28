import 'package:cloud_gaming/screens/screens.dart';
import 'package:cloud_gaming/services/desktop_oauth_manager.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();

    return FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return Material(
              child: Stack(
                children: [
                  Container(
                    color: AppTheme.primary,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                          colorGen.getHighlightedMatrix(value: 0.12)),
                      child: Image(
                          fit: BoxFit.cover,
                          height: size.height,
                          width: size.width,
                          image:
                              const AssetImage(AppTheme.loginBackgroundPath)),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          "Please, enable location services",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: size.width * 0.10,
                          height: 50,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: AppTheme.primary),
                              onPressed: () {
                                setState(() {});
                              },
                              child: const Text(
                                "Reload",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              )),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
          if (snapshot.data == null) {
            return Material(
              child: Stack(
                children: [
                  Container(
                    color: AppTheme.primary,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                          colorGen.getHighlightedMatrix(value: 0.12)),
                      child: Image(
                          fit: BoxFit.cover,
                          height: size.height,
                          width: size.width,
                          image:
                              const AssetImage(AppTheme.loginBackgroundPath)),
                    ),
                  ),
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.grey[500],
                          ),
                          const Text(
                            "Please, verify your Google Account",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ]),
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.data == null) {
              print("ERROR");
            } else {
              print(snapshot.data!.latitude);
            }

            return const HomeScreen();
          }
        });
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
