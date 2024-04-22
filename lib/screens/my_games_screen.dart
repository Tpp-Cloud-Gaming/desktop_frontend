import 'dart:io';
import 'dart:ui';

import 'package:cloud_gaming/Providers/user_provider.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:cloud_gaming/widgets/custom_pannel.dart';
import 'package:fhoto_editor/fhoto_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorGen = ColorFilterGenerator.getInstance();

    return FutureBuilder(
      future: loadGames(context),
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
          return Scaffold(
              body: Stack(children: [
            const BackGround(),
            Row(
              children: [
                const CustomPannel(),
                Expanded(
                  child: Column(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: size.width * 0.08, left: size.height * 0.20),
                          child: const Text("Mis Juegos", style: TextStyle(color: Colors.white, fontSize: 45)),
                        )),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: size.width * 0.03, left: size.width * 0.00),
                        child: SizedBox(
                          height: 100,
                          width: size.width * 0.55,
                          child: snapshot.data!.isEmpty
                              ? const Text("No tienes juegos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.normal,
                                  ))
                              : ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GameItem(
                                          games: snapshot.data!,
                                          index: index,
                                          callback: refresh,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),

                    // ADD GAME BUTTON
                    Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.05, bottom: size.height * 0.05),
                      child: SizedBox(
                        height: 60,
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () async {
                              saveGame(context);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Agregar Juego",
                                  style: TextStyle(fontSize: 34.0),
                                ),
                                Icon(Icons.add_box_outlined, size: 34.0),
                              ],
                            )),
                      ),
                    )),
                  ]),
                )
              ],
            ),
          ]));
        }
      },
    );
  }
}

class GameItem extends StatefulWidget {
  const GameItem({
    super.key,
    required this.games,
    required this.index,
    required this.callback,
  });

  final List<Game> games;
  final int index;
  final VoidCallback callback;

  @override
  State<GameItem> createState() => GameItemState();
}

class GameItemState extends State<GameItem> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      color: const Color(0xFF000000).withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(widget.games[widget.index].image),
            width: size.width * 0.1,
            height: size.height * 0.1,
            fit: BoxFit.fitHeight,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.games[widget.index].title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "Categoría: ${widget.games[widget.index].category}",
                style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(widget.games[widget.index].description,
                  style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ))
            ],
          )),
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.edit,
              color: Colors.white.withOpacity(0.7),
              size: 30.0,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.games.removeAt(widget.index);
              widget.callback();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red.withOpacity(0.7),
              size: 30.0,
            ),
          )
        ]),
      ),
    );
  }
}

class Game {
  String title;
  String description;
  String category;
  String image;

  Game(this.image, this.title, this.description, this.category);
}

// class AddGameButton extends StatelessWidget {
//   const AddGameButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return
//       SizedBox(
//         height: 60,
//         width: 300,
//         child: ElevatedButton(
//           onPressed: () {_showDialog()},
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 "Agregar Juego",
//                 style: TextStyle(fontSize: 34.0),
//               ),
//               Icon(Icons.add_box_outlined, size: 34.0),
//             ],
//           )
//         ),
//       );
//   }
// }

class GameDialog extends StatelessWidget {
  const GameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<List<Game>> loadGames(BuildContext context) async {
  final provider = Provider.of<UserProvider>(context, listen: false);

  List<Map<String, dynamic>> userGames = provider.userGames;
  List<Map<String, dynamic>> games = provider.games;

  List<Game> gamesList = [];

  //Armar cada game segun los userGames y los datos del game.
  userGames.forEach((element) {
    Map<String, dynamic> gameData = games.firstWhere((gameElement) => element["gamename"] == gameElement["name"]);
    Game game = Game(gameData["image_1"], gameData["name"], gameData["description"], gameData["category"]);
    gamesList.add(game);
  });

  return gamesList;
}

void saveGame(BuildContext context) async {
  //Obtener el path del juego
  String? path = await FilesystemPicker.open(
    theme: FilesystemPickerTheme(
        topBar: FilesystemPickerTopBarThemeData(backgroundColor: AppTheme.onHoverColor),
        backgroundColor: AppTheme.pannelColor,
        messageTextStyle: const TextStyle(color: Colors.white),
        fileList: FilesystemPickerFileListThemeData(
          folderTextStyle: const TextStyle(color: Colors.white),
          fileTextStyle: const TextStyle(color: Colors.white),
        )),
    title: 'Select Game Path',
    context: context,
    rootDirectory: Directory("C:"), //TODO: podria no ser el disco C
    fsType: FilesystemType.file,
    allowedExtensions: [
      '.exe',
      '.url'
    ],
    fileTileSelectMode: FileTileSelectMode.wholeTile,
  );

  if (path != null && path.isNotEmpty) {
    //Mostrar el dialogo para que el usuario confirme la carga del juego
    _showDialog(context, path);
  }
}

void _showDialog(BuildContext context, String path) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        final provider = Provider.of<UserProvider>(context, listen: false);
        String? dropdownvalue;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.5),
                  width: 1.0,
                ),
                color: const Color(0xff0c1d43),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2, // changes position of shadow
                  ),
                ],
              ),
              height: size.height * 0.85,
              width: size.width * 0.35,
              child: Expanded(
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.0, left: size.width * 0.02),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Selected Path: $path",
                          style: GoogleFonts.kanit(
                            color: Colors.white,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: DropdownGames(provider: provider),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (path.isEmpty || provider.newGame.isEmpty) {
                              NotificationsService.showSnackBar("No game name or path selected", Colors.red, AppTheme.loginPannelColor);
                            } else {
                              Map<String, dynamic> newGame = {
                                "path": path.replaceAll(r"\", r"\\"),
                                "gamename": provider.newGame,
                              };
                              BackendService backendService = BackendService();
                              provider.addNewUserGame(newGame);
                              String? resp = await backendService.addUserGames(provider.userGames);
                              print(resp);
                              print(provider.userGames);
                              provider.newGame = '';
                              if (resp == null) {
                                Navigator.of(context).pop();
                                NotificationsService.showSnackBar("Game added successfully", Colors.green, AppTheme.loginPannelColor);
                                return;
                              } else {
                                provider.removeLastUserGame();
                                Navigator.of(context).pop();
                                NotificationsService.showSnackBar("Error adding game: $resp", Colors.red, AppTheme.loginPannelColor);
                                return;
                              }
                            }
                          },
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: size.height * 0.04,
                          ),
                          label: Text(
                            "Guardar",
                            style: GoogleFonts.kanit(
                              color: Colors.white,
                              fontSize: size.height * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.6)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ))),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: size.height * 0.04,
                          ),
                          label: Text(
                            "Cancelar",
                            style: GoogleFonts.kanit(
                              color: Colors.white,
                              fontSize: size.height * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.6)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ))),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
        );
      });
}

class DropdownGames extends StatefulWidget {
  DropdownGames({super.key, required this.provider});

  final UserProvider provider;

  @override
  State<DropdownGames> createState() => _DropdownGamesState();
}

class _DropdownGamesState extends State<DropdownGames> {
  String? dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: DropdownButton(
        // Initial Value
        icon: const Icon(Icons.keyboard_arrow_down),
        isExpanded: true,
        items: widget.provider.games.map((value) {
          return DropdownMenuItem(
            value: value["name"] as String,
            child: Text(
              value["name"] ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        hint: const Text(
          'Games',
          style: TextStyle(color: Colors.white),
        ),
        onChanged: (String? newValue) async {
          setState(() {
            dropdownvalue = newValue;
          });
          widget.provider.newGame = newValue ?? '';
        },
      ),
    );
  }
}
