import 'package:cloud_gaming/Providers/web_socket_provider.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitAccreditScreen extends StatelessWidget {
  const WaitAccreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: true);
    return Material(
      child: Stack(
        children: [
          const BackGround(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                webSocketProvider.accredit
                    ? Text(
                        "Accreditation completed",
                        style: AppTheme.commonText(Colors.white, 22),
                      )
                    : Text(
                        "Waiting for accreditation",
                        style: AppTheme.commonText(Colors.white, 22),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: webSocketProvider.accredit
                      ? OutlinedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "home");
                          },
                          style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
                          child: Text(
                            "Back to home",
                            style: AppTheme.commonText(Colors.white, 18),
                          ))
                      : const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
