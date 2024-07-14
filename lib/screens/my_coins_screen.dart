import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:cloud_gaming/widgets/custom_pannel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCoinsScreen extends StatelessWidget {
  const MyCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ScrollController controller = ScrollController();
    final provider = Provider.of<UserProvider>(context, listen: true);

    int totalMinutes = provider.credits;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    String formattedTime = "$hours hours and $minutes minutes";

    int hourPrice = 3000;

    List<Map<String, String>> prices = [
      {
        "hours": "1",
        "price": (hourPrice).toString(),
        "image": "assets/prices/1hour.jpg"
      },
      {
        "hours": "3",
        "price": (hourPrice * 3).toString(),
        "image": "assets/prices/3hours.jpg"
      },
      {
        "hours": "5",
        "price": (hourPrice * 5).toString(),
        "image": "assets/prices/5hours.jpg"
      },
    ];

    return Material(
      child: Stack(
        children: [
          const BackGround(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomPannel(page: "coins"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 60, top: 70),
                    child: Text("CHOOSE YOUR PACK", style: AppTheme.commonText(Colors.white, 35, FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, top: 20),
                    child: Text("Available time: $formattedTime", style: AppTheme.commonText(Colors.white, 32)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.width * 0.03, left: size.width * 0.05),
                      child: Scrollbar(
                        controller: controller,
                        thumbVisibility: true,
                        child: SizedBox(
                          width: size.width > 1400 ? size.width * 0.75 : size.width * 0.9,
                          child: GridView.builder(
                            controller: controller,
                            padding: const EdgeInsets.only(right: 200, top: 100),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //segun la resolucion de la pantalla se ajusta el numero de juegos a mostrar
                              crossAxisCount: size.width > 1800
                                  ? 4
                                  : size.width > 1400
                                      ? 3
                                      : 2, // number of items in each row
                              mainAxisSpacing: 5.0, // spacing between rows
                              crossAxisSpacing: 5.0, // spacing between columns
                            ),
                            itemCount: prices.length,
                            itemBuilder: (context, index) {
                              return PriceCard(
                                item: prices[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class PriceCard extends StatefulWidget {
  const PriceCard({super.key, required this.item});

  final Map<String, String> item;

  @override
  State<PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WebSocketProvider>(context, listen: true);
    return InkWell(
      onTap: () async {
        final user = Provider.of<UserProvider>(context, listen: false);

        Map<String, dynamic>? resp = await BackendService().loadCredits(int.parse(widget.item["hours"] ?? "0"), user.user["username"]);
        if (resp == null) {
          NotificationsService.showSnackBar("Error locading payment: $resp", Colors.red, AppTheme.loginPannelColor);
        } else {
          if (resp["url"] != null) {
            //Sirve para probar pagos, dsp comentar
            print(resp["url"]);
            provider.setAccredit(false);
            _launchInBrowser(Uri.parse(resp["url"]));
            Navigator.popAndPushNamed(context, "waitAccredit");
          }
        }
      },
      onHover: (value) {
        if (value) {
          setState(() {
            scale = 1.1;
          });
        } else {
          setState(() {
            scale = 1.0;
          });
        }
      },
      child: Transform.scale(
        scale: scale,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.item["image"] ?? 'assets/no-image.jpg',
                  width: 190,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 25,
              width: 170,
              child: Center(
                child: Text(
                  "${widget.item["price"]} ARS",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
