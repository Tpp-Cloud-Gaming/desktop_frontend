import 'package:cloud_gaming/Providers/user_provider.dart';
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
    final ScrollController _controller = ScrollController();
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
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.data == {}) {
              Navigator.pop(context);
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
                              controller: _controller,
                              thumbVisibility: true,
                              child: SizedBox(
                                width: size.width * 0.75,
                                child: GridView.builder(
                                  controller: _controller,
                                  padding: const EdgeInsets.only(right: 400, top: 100),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // number of items in each row
                                    mainAxisSpacing: 5.0, // spacing between rows
                                    crossAxisSpacing: 5.0, // spacing between columns
                                  ),
                                  itemCount: snapshot.data!["games"].length,
                                  itemBuilder: (context, index) {
                                    return GameCard(
                                      title: snapshot.data!["games"][index]["name"],
                                      imagePath: snapshot.data!["games"][index]["image_1"],
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
  const GameCard({super.key, required this.title, required this.imagePath});

  final String imagePath;
  final String title;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.3,
      width: size.width * 0.1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "game");
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
                    placeholder: const AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(widget.imagePath),
                    width: size.width * 0.1,
                    height: size.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.title ?? 'no-name',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ],
          ),
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
    bool remember = prefs.getBool('remember') ?? false;

    if (remember) {
      //Obtengo el token para refrescar el usuario
      await FirebaseAuthService().getToken();
    }

    Map<String, dynamic>? user = await BackendService().getUser();
    List<Map<String, dynamic>>? games = await BackendService().getAllGames();

    if (user == null || games == null) {
      prefs.setBool('remember', false);
      return {};
    }

    provider.updateFormValue(user['user']);
    data['user'] = provider.user;

    provider.setGames(games);
    data['games'] = provider.games;

    provider.setLoggin(false);

    return data;
  } else {
    data['games'] = provider.games;
    data['user'] = provider.user;

    return data;
  }
}
