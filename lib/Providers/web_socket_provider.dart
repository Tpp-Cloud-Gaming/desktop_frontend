import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class User {
  String username;
  int calification;

  User({required this.username, required this.calification});
}

class WebSocketProvider extends ChangeNotifier {
  late final WebSocketChannel _channel;
  final String _wsUrl = 'wss://cloud-gaming-server.onrender.com';

  Map<String, List<User>> _gamesByUser = {};

  void connect(String username) async {
    //Conectarse al servidor
    _channel = WebSocketChannel.connect(
      Uri.parse(_wsUrl),
    );

    //Validar si se conecto correctamente
    try {
      await _channel.ready;
      print("se conecto ok");
    } on SocketException catch (e) {
      print("Error: $e");
      throw Exception("Error al conectarse al servidor: $e");
    } on WebSocketChannelException catch (e) {
      print("Error: $e");
      throw Exception("Error al conectarse al servidor: $e");
    }

    //Avisar que se conecto
    _channel.sink.add("subscribe|$username");

    //Escuchar mensajes y establecer los handlers
    StreamSubscription<dynamic> a = _channel.stream.listen((event) {
      print("Recibo: $event");
    });
    a.onData((data) {
      print("Data: $data");
      List<String> splitData = data.toString().split('|');
      String type = splitData[0];
      if (type == 'notifConnection') {
        _loadGames(splitData);
        notifyListeners();
      } else if (type == 'notifDisconnection') {
        _removeGames(splitData);
        notifyListeners();
      }
    });
    // a.onError((error) {
    //   print("Error: $error");
    // });
    // a.onDone(() {
    //   print("Done");
    // });
  }

  List<User> getUsersByGame(String gameName) {
    if (_gamesByUser.isEmpty) {
      return [];
    }
    if (!_gamesByUser.containsKey(gameName)) {
      return [];
    }

    return _gamesByUser[gameName] ?? [];
  }

  void _loadGames(List<String> data) {
    String username = data[1];
    String calification = data[2];
    data.removeRange(0, 3);

    data.forEach((element) {
      if (_gamesByUser.containsKey(element)) {
        _gamesByUser[element]!.add(User(username: username, calification: int.parse(calification)));
      } else {
        _gamesByUser[element] = [
          User(username: username, calification: int.parse(calification))
        ];
      }
    });
  }

  void _removeGames(List<String> data) {
    String username = data[1];
    _gamesByUser.forEach((key, value) {
      value.removeWhere((element) => element.username == username);
    });
  }
}