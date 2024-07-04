import 'package:cloud_gaming/Providers/user_provider.dart';
import 'package:cloud_gaming/screens/home_screen.dart';
import 'package:cloud_gaming/widgets/background.dart';
import 'package:cloud_gaming/widgets/custom_pannel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ScrollController controller = ScrollController();
    final provider = Provider.of<UserProvider>(context, listen: false);
    return Material(
      child: Stack(
        children: [
          const BackGround(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              size.width > 1400
                  ? const CustomPannel(
                      page: "fav",
                    )
                  : Container(),
              FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      SharedPreferences prefs = snapshot.data as SharedPreferences;
                      final List<String>? games = prefs.getStringList('favGames');
                      if (games == null) {
                        return const Center(
                          child: Text('No games added to favorites'),
                        );
                      } else {
                        if (games.isEmpty) {
                          return const Center(
                            child: Text('No games added to favorites'),
                          );
                        } else {
                          return Expanded(
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
                                    itemCount: games.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> game = provider.games.firstWhere((element) => element["name"] == games[index]);
                                      return GameCard(game: game);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          )
        ],
      ),
    );
  }
}
