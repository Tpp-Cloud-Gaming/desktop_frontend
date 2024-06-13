import 'dart:async';
import 'dart:io';

import 'package:cloud_gaming/Providers/providers.dart';
import 'package:cloud_gaming/Providers/user_provider.dart';
import 'package:cloud_gaming/services/rust_communication_service.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class User {
  String username;
  int calification;

  User({required this.username, required this.calification});
}

class Session {
  String offerer;
  int hours;
  String gameName;

  Session({required this.offerer, required this.hours, required this.gameName});
}

class WebSocketProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  final String _wsUrl = 'wss://cloud-gaming-server.onrender.com';

  bool _isConnected = false;
  Map<String, List<User>> _gamesByUser = {
    "The Finals": [
      new User(username: "Test", calification: 1)
    ]
  };
  StreamSubscription<dynamic>? a;
  UserProvider? userProvider;
  bool _accredit = false;
  Session? currentSession;

  void connect(String username, UserProvider user) async {
    //Conectarse al servidor
    _channel = WebSocketChannel.connect(
      Uri.parse(_wsUrl),
    );

    //Validar si se conecto correctamente
    try {
      await _channel!.ready;
      print("se conecto ok");
    } on SocketException catch (e) {
      print("Error: $e");
      throw Exception("Error al conectarse al servidor: $e");
    } on WebSocketChannelException catch (e) {
      print("Error: $e");
      throw Exception("Error al conectarse al servidor: $e");
    }
    //Avisar que se conecto
    _channel!.sink.add("subscribe|$username");

    //Escuchar mensajes y establecer los handlers
    StreamSubscription<dynamic> a = _channel!.stream.listen((event) {
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
      } else if (type == 'notifPayment') {
        _updateCredits(splitData, user);
        setAccredit(true);
      } else if (type == 'notifEndSession') {
        endSession(splitData);
      } else {
        print("Tipo de mensaje desconocido: $type datos: $splitData");
      }
    });
    // a.onError((error) {
    //   print("Error: $error");
    // });
    // a.onDone(() {
    //   print("Done");
    // });
  }

  void setAccredit(bool value) {
    _accredit = value;
    notifyListeners();
  }

  bool get accredit => _accredit;

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

    for (var element in data) {
      if (_gamesByUser.containsKey(element)) {
        _gamesByUser[element]!.add(User(username: username, calification: int.parse(calification)));
      } else {
        _gamesByUser[element] = [
          User(username: username, calification: int.parse(calification))
        ];
      }
    }
  }

  void _removeGames(List<String> data) {
    String username = data[1];
    _gamesByUser.forEach((key, value) {
      value.removeWhere((element) => element.username == username);
    });
  }

  void _updateCredits(List<String> data, UserProvider user) {
    String credits = data[2];
    try {
      user.loadCredits(int.parse(credits));
    } catch (e) {
      return;
    }
  }

  bool get isConnected => _isConnected;

  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  Future<void> shutdown() async {
    if (a != null) {
      a!.cancel();
    }
    _isConnected = false;
    _gamesByUser = {};
    _channel!.sink.close();
    _channel = null;
  }

  void setUserProvider(UserProvider user) {
    userProvider = user;
  }

  void endSession(List<String> data) async {
    if (userProvider == null) {
      return;
    }

    String offerer = data[1];
    String receiver = data[2];
    //int credits = int.parse(data[3]);
    //TODO: calcularse como credito redondeado / 60
    int credits = 5;

    String username = userProvider!.user["username"];

    if (username == offerer) {
      print("Quiero mandar start offering");
      RustCommunicationService rustCommunicationService = RustCommunicationService();
      await rustCommunicationService.connect(2930);
      rustCommunicationService.startOffering(userProvider!.user["username"]);
      rustCommunicationService.disconnect();
      userProvider!.loadCredits(credits);
    } else {
      userProvider!.loadCredits(credits * -1);
    }
  }
}
