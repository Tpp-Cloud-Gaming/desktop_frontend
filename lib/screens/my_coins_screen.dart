import 'dart:ui';

import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/Providers/user_provider.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:cloud_gaming/widgets/custom_pannel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCoinsScreen extends StatelessWidget {
  const MyCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<UserProvider>(context, listen: true);
    return Material(
      child: Stack(
        children: [
          const BackGround(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              size.width > 1400 ? const CustomPannel() : Container(),
              Padding(
                padding: EdgeInsets.only(top: size.width * 0.08, left: size.height * 0.05),
                child: Container(
                  height: 500,
                  width: size.width > 1400 ? size.width * 0.55 : size.width * 0.9,
                  decoration: BoxDecoration(color: AppTheme.pannelColor.withOpacity(0.45), borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Image(
                                  image: AssetImage("assets/pannel-icons/load_coin.png"),
                                  height: 60,
                                  width: 60,
                                  filterQuality: FilterQuality.high,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 20),
                                  child: Text("${provider.credits}", style: AppTheme.commonText(Colors.white, 24)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 80),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.white, width: 1)),
                              height: 100,
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const LoadHours(
                                    hours: "1",
                                    price: "1000",
                                  ),
                                  Container(height: 100, width: 1, color: Colors.white),
                                  const LoadHours(
                                    hours: "5",
                                    price: "4500",
                                  ),
                                  Container(height: 100, width: 1, color: Colors.white),
                                  const LoadHours(
                                    hours: "10",
                                    price: "9000",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 40.0, left: 10),
                          //   child: SizedBox(
                          //     width: 280,
                          //     height: 55,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         CoinsButton(
                          //           title: "Load",
                          //           onPressed: () {
                          //             _addCoinsDialog(context, provider);
                          //           },
                          //         ),
                          //         CoinsButton(
                          //           title: "Extract",
                          //           onPressed: () {
                          //             _extractCoinsDialog(context, provider);
                          //           },
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LoadHours extends StatelessWidget {
  const LoadHours({super.key, required this.hours, required this.price});
  final String hours;
  final String price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final user = Provider.of<UserProvider>(context, listen: false);
        if (user.user["mercadopago_mail"] == null || user.user["mercadopago_mail"] == "") {
          NotificationsService.showSnackBar("To load credits you need a payment email. Load it in settings/Load payment account", Colors.red, AppTheme.loginPannelColor);
        } else {
          Map<String, dynamic>? resp = await BackendService().loadCredits(int.parse(hours), user.user["username"]);
          if (resp == null) {
            NotificationsService.showSnackBar("Error locading payment: $resp", Colors.red, AppTheme.loginPannelColor);
          } else {
            if (resp["url"] != null) {
              _launchInBrowser(Uri.parse(resp["url"]));
            }
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: hours,
                  style: AppTheme.commonText(Colors.white, 20),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.access_time_sharp,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: AppTheme.commonText(Colors.white, 20),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.attach_money_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class CoinsButton extends StatelessWidget {
//   const CoinsButton({super.key, required this.title, required this.onPressed});
//   final String title;
//   final Function() onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: 120,
//         height: 50,
//         child: OutlinedButton(
//           onPressed: onPressed,
//           style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
//           child: Text(
//             title,
//             style: AppTheme.commonText(Colors.white, 18),
//           ),
//         ));
//   }
// }

// void _addCoinsDialog(BuildContext context, UserProvider provider) {
//   TextEditingController coinController = TextEditingController();
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Dialog(
//               child: Container(
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.all(Radius.circular(15)),
//               border: Border.all(
//                 color: Colors.blueAccent.withOpacity(0.5),
//                 width: 1.0,
//               ),
//               color: const Color(0xff0c1d43),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blueAccent.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 2, // changes position of shadow
//                 ),
//               ],
//             ),
//             height: 200,
//             width: 500,
//             child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//               Text("Amount to load:", style: AppTheme.commonText(Colors.white, 20)),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: CustomInputField(
//                   controller: coinController,
//                   obscureText: false,
//                   textType: TextInputType.number,
//                   inputFormatters: <TextInputFormatter>[
//                     FilteringTextInputFormatter.digitsOnly
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   OutlinedButton(
//                       style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.loginButtonColor),
//                       onPressed: () {
//                         //Navigator.popAndPushNamed(context, "home");
//                         provider.loadCredits(int.parse(coinController.text));
//                         _launchInBrowser(Uri.parse("https://www.google.com/"));
//                         Navigator.of(context).pop();
//                         return;
//                       },
//                       child: Text(
//                         "Confirm",
//                         style: AppTheme.commonText(Colors.white, 18),
//                       )),
//                   OutlinedButton(
//                       style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.loginButtonColor),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         return;
//                       },
//                       child: Text(
//                         "Cancel",
//                         style: AppTheme.commonText(Colors.white, 18),
//                       ))
//                 ],
//               )
//             ]),
//           )),
//         );
//       });
// }

// void _extractCoinsDialog(BuildContext context, UserProvider provider) {
//   TextEditingController coinController = TextEditingController();
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Dialog(
//               child: Container(
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.all(Radius.circular(15)),
//               border: Border.all(
//                 color: Colors.blueAccent.withOpacity(0.5),
//                 width: 1.0,
//               ),
//               color: const Color(0xff0c1d43),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blueAccent.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 2, // changes position of shadow
//                 ),
//               ],
//             ),
//             height: 200,
//             width: 500,
//             child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//               Text("Amount to extract:", style: AppTheme.commonText(Colors.white, 20)),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: CustomInputField(
//                   controller: coinController,
//                   obscureText: false,
//                   textType: TextInputType.number,
//                   inputFormatters: <TextInputFormatter>[
//                     FilteringTextInputFormatter.digitsOnly
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   OutlinedButton(
//                       style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.loginButtonColor),
//                       onPressed: () {
//                         //Navigator.popAndPushNamed(context, "home");
//                         provider.loadCredits(int.parse(coinController.text) * -1);
//                         Navigator.of(context).pop();
//                         return;
//                       },
//                       child: Text(
//                         "Confirm",
//                         style: AppTheme.commonText(Colors.white, 18),
//                       )),
//                   OutlinedButton(
//                       style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.loginButtonColor),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         return;
//                       },
//                       child: Text(
//                         "Cancel",
//                         style: AppTheme.commonText(Colors.white, 18),
//                       ))
//                 ],
//               )
//             ]),
//           )),
//         );
//       });
// }

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
