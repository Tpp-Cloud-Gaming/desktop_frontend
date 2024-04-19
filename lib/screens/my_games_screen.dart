import 'dart:ui';

import 'package:cloud_gaming/widgets/background.dart';
import 'package:cloud_gaming/widgets/custom_pannel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  
  List<Game> games = [
      Game('assets/example-games/finals.webp','Finals', "Es un videojuego de disparos en primera persona free-to-play. El juego se centra en partidas por equipos en mapas con un entorno destructible, donde se anima a los jugadores a utilizar el entorno dinámico a su favor.","Acción"),
      Game('assets/example-games/terraria.webp','Terraria', 'Terraria es un videojuego de acción, aventura y sandbox. Tiene características tales como la exploración, la artesanía, la construcción de estructuras y el combate.', 'Aventura'),
      Game('assets/example-games/nba.webp','NBA2K24', 'Juego de baloncesto.', 'Deportes'),
      Game('assets/example-games/finals.webp','Finals', "Es un videojuego de disparos en primera persona free-to-play. El juego se centra en partidas por equipos en mapas con un entorno destructible, donde se anima a los jugadores a utilizar el entorno dinámico a su favor.","Acción"),
      Game('assets/example-games/terraria.webp','Terraria', 'Terraria es un videojuego de acción, aventura y sandbox. Tiene características tales como la exploración, la artesanía, la construcción de estructuras y el combate.', 'Aventura'),
      Game('assets/example-games/nba.webp','NBA2K24', 'Juego de baloncesto.', 'Deportes'),
      Game('assets/example-games/finals.webp','Finals', "Es un videojuego de disparos en primera persona free-to-play. El juego se centra en partidas por equipos en mapas con un entorno destructible, donde se anima a los jugadores a utilizar el entorno dinámico a su favor.","Acción"),
      Game('assets/example-games/terraria.webp','Terraria', 'Terraria es un videojuego de acción, aventura y sandbox. Tiene características tales como la exploración, la artesanía, la construcción de estructuras y el combate. Terraria es un videojuego de acción, aventura y sandbox. Tiene características tales como la exploración, la artesanía, la construcción de estructuras y el combate.Terraria es un videojuego de acción, aventura y sandbox. Tiene características tales como la exploración, la artesanía, la construcción de estructuras y el combate. ', 'Aventura'),
      Game('assets/example-games/nba.webp','NBA2K24', 'Juego de baloncesto.', 'Deportes'),
  ];

  void refresh() {
    setState(() {});
  }

  _showDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
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
                child: Column(
                  children: [

                    //IMAGEN
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.02),
                      child: SizedBox(
                        width: size.width * 0.1,
                        height: size.height * 0.3,
                        child: Stack(

                        children: [
                          Center(child: Container(
                            width: size.width * 0.08,
                            height: size.height * 0.185,
                            decoration: const BoxDecoration(
                              color: Color(0xff100f22),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Color(0xff100f22)
                                )
                              ],
                              shape: BoxShape.rectangle,
                              
                              // image: const DecorationImage(
                              //   fit: BoxFit.cover,
                              //   image: AssetImage('assets/example-games/terraria.webp')
                              // )
                            ),
                            child: Icon(
                                Icons.image_outlined,
                                size: size.height * 0.1,
                                color: Colors.black.withOpacity(.4),
                            ),
                          )),
                          Positioned(
                            bottom: 35,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 3),
                                color: const Color(0xff100f22),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white,),
                                onPressed: () {},
                              ),
                            ),
                            
                          )
                          
                        ]
                        )
                      ),
                     
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0, left: size.width * 0.02),
                      child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Título",
                          style: GoogleFonts.kanit(
                            color: Colors.white,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.normal,
                          )
                        ),
                      ),
                    ),

                    Padding (
                      padding: EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02),
                      child: TextField(
                      decoration: InputDecoration(
                          hintText: "Ingrese un título...",
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: size.height * 0.016,
                            fontWeight: FontWeight.w100,
                          ),
                          filled: true,
                          fillColor: const Color(0xff100f22),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                              color:  Color(0xff100f22),
                            ),
                          ),
                        ),
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: size.height * 0.016,
                            fontWeight: FontWeight.w200,
                          ),
                      ),
                    ),
                    
                    Padding(
                      padding:  EdgeInsets.only(top: 10.0, left: size.width * 0.02),
                      child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Categoría",
                          style: GoogleFonts.kanit(
                            color: Colors.white,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.normal,
                          )
                        ),
                      ),
                    ),
                    
                    Padding (
                      padding:  EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02),
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: "Ingrese una categoría...",
                            hintStyle: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: size.height * 0.016,
                              fontWeight: FontWeight.w100,
                            ),
                            filled: true,
                            fillColor: const Color(0xff100f22),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                            enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                              color:  Color(0xff100f22),
                            ),
                          ),
                          ),
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: size.height * 0.016,
                              fontWeight: FontWeight.w200,
                          ),
                        ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top: 10.0, left: size.width * 0.02),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Descripción",
                            style: GoogleFonts.kanit(
                              color: Colors.white,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.normal,
                            )
                          ),
                        ),
                    ),
                    Padding (
                      padding:  EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02),
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: "Ingrese una descripción...",
                            hintStyle: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: size.height * 0.016,
                              fontWeight: FontWeight.w100,
                            ),
                            filled: true,
                            fillColor: const Color(0xff100f22),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                            enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                              color:  Color(0xff100f22),
                            ),
                          ),
                          ),
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: size.height * 0.016,
                              fontWeight: FontWeight.w200,
                          ),
                          maxLines: 4,
                        ),
                    ),

                    Padding(
                        padding:  EdgeInsets.only(top: size.height * 0.03 ),
                        child: 
                        Row (
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {  },
                              icon:  Icon(
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
                              style:  ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.6)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                )
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {  },
                              icon:  Icon(
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
                              style:  ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.6)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                )
                              ),
                            ),
                          ],
                        ),
                    )
                  ]
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    return Scaffold(
          body: Stack(children: [
        const BackGround(),
        Row(
          children: [
            const CustomPannel(),
            Expanded(
              child: 
                Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.width * 0.08, left: size.height * 0.20),
                    child: const Text(
                        "Mis Juegos",
                        style: TextStyle(color: Colors.white, fontSize: 45)),
                  )
                ),
                Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: size.width * 0.03, left: size.width * 0.00),
                  child: SizedBox(
                    height: 100,
                    width: size.width * 0.55,
                    child: games.isEmpty ? 
                    const Text(
                      "No tienes juegos", 
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.normal,
                    )) : 
                    ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GameItem(
                              games: games,
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
                child:
                Padding (
                  padding: EdgeInsets.only(top: size.height * 0.05, bottom: size.height * 0.05),
                  child: SizedBox(
                      height: 60,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {_showDialog();},
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
                        )
                      ),
                    ),
                )
              ),

              ]),
            )
            
            
          ],
        ),
      ]));
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
  State <GameItem> createState() =>  GameItemState();
}


class GameItemState extends State <GameItem> {
  
  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      color: const Color(0xFF000000).withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              height: size.height * 0.1,
              width: size.height * 0.1, 
              fit: BoxFit.fitHeight,
              image: AssetImage(widget.games[widget.index].image)
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
                  Text(
                    widget.games[widget.index].description,
                    style: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    )
                  )
                ],
              )
            ),
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
          ]
        ),
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