import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/screens/game_screen.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ScrollController controller = ScrollController();
    final colorGen = ColorFilterGenerator.getInstance();
    final provider = Provider.of<UserProvider>(context, listen: false);
    return FutureBuilder(
        future: loadData(context, provider),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Material(
              child: Stack(
                children: [
                  Container(
                    color: AppTheme.primary,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(colorGen.getHighlightedMatrix(value: 0.12)),
                      child: Image(fit: BoxFit.cover, height: size.height, width: size.width, image: const AssetImage(AppTheme.loginBackgroundPath)),
                    ),
                  ),
                  Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      CircularProgressIndicator(
                        color: Colors.grey[500],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, left: 20),
                        child: Text(
                          "LOADING...",
                          style: AppTheme.commonText(Colors.white, 30, FontWeight.bold),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.data == {} || snapshot.data!["games"] == null) {
              //Navigator.pop(context);
              return Container();
            }
            return Scaffold(
                body: Stack(
              children: [
                const BackGround(),
                Row(
                  children: [
                    const CustomPannel(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.width * 0.08, left: size.height * 0.05),
                          child: Text(AppLocalizations.of(context)!.homeTitle, style: const TextStyle(color: Colors.white, fontSize: 45)),
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
                                  itemCount: snapshot.data!["games"].length,
                                  itemBuilder: (context, index) {
                                    return GameCard(
                                      game: snapshot.data!["games"][index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ));
          }
        });
  }
}

class GameCard extends StatefulWidget {
  const GameCard({super.key, required this.game});

  final Map<String, dynamic> game;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => GameScreen(
                game: widget.game,
              ),
            ));
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
                child: FadeInImage(
                  fadeInDuration: const Duration(milliseconds: 10),
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(widget.game["image_1"]),
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
              child: Text(
                widget.game["name"] ?? 'no-name',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Cargar imagenes de juegos y datos del usuario
Future<Map<String, dynamic>> loadData(BuildContext context, UserProvider provider) async {
  Map<String, dynamic> data = {};
  if (provider.firstLogin) {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = await FirebaseAuthService().getToken();
    print(token);
    Map<String, dynamic>? user = await BackendService().getUser();
    List<Map<String, dynamic>>? games = await BackendService().getAllGames();
    if (user == null || games == null) {
      prefs.setBool('remember', false);
      Navigator.popAndPushNamed(context, 'login');
      return {};
    }
    //Decodificar la lista de juegos del usuario
    final List<dynamic> dataGames = user["userGames"];
    List<Map<String, dynamic>> userGames = dataGames.map((dynamic item) => item as Map<String, dynamic>).toList();

    provider.setUserGames(userGames);
    provider.updateFormValue(user['user']);

    data['user'] = provider.user;

    provider.setGames(games);
    data['games'] = provider.games;

    provider.setLoggin(false);

    final tcpProvider = Provider.of<TcpProvider>(context, listen: false);

    //Inicializar el web socket
    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
    webSocketProvider.connect(provider.user["username"], provider);
    webSocketProvider.setUserProvider(provider);
    webSocketProvider.setTcpProvider(tcpProvider);

    return data;
  } else {
    data['games'] = provider.games;
    data['user'] = provider.user;

    return data;
  }
}
