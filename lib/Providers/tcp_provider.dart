import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class TcpProvider extends ChangeNotifier {
  String ip = "127.0.0.1";
  //int port = 2930;
  Socket? socket;
  static const int maxAttempts = 5;
  static const Duration waitDuration = Duration(seconds: 5);

  Future<void> connect(int port) async {
    if (socket != null) {
      print("Already connected");
      return;
    }
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        print("Connecting to $ip:$port (Attempt: ${attempt + 1})");
        socket = await Socket.connect(ip, port);
        print("Connected successfully");
        return;
      } catch (e) {
        print(e);
        if (attempt >= maxAttempts - 1) {
          print("Failed to connect after $maxAttempts attempts.");
          return;
        } else {
          print("Waiting before next attempt...");
          await Future.delayed(waitDuration);
        }
      }
    }
  }

  Future<String> read() async {
    final Completer<String> completer = Completer<String>();
    String msg = "";

    socket?.listen(
      (List<int> data) {
        // Convertir los datos recibidos a String y completar el completer
        msg = utf8.decode(data);
        completer.complete(msg);
      },
      onDone: () {
        // Si la conexión se cierra sin recibir datos, completar con un mensaje vacío
        if (!completer.isCompleted) {
          completer.complete("");
        }
      },
      onError: (e) {
        // En caso de error, completar con un mensaje vacío o manejar el error como se desee
        completer.completeError(e);
      },
    );

    // Esperar a que el completer se complete y luego retornar el mensaje
    return completer.future;
  }

  void startOffering(String username) {
    String msg = 'startOffering|$username\n';
    socket?.encoding = utf8;
    socket?.write(msg);
  }

  void startGameWithUser(String usernameClient, String userToConnect, String game, int minutes) {
    String msg = 'startGameWithUser|$usernameClient|$userToConnect|$game|$minutes\n';
    socket?.encoding = utf8;
    socket?.writeln(msg);
  }

  void endSession() {
    String msg = 'disconnect\n';
    socket?.encoding = utf8;
    socket?.write(msg);
  }

  void disconnect() {
    socket?.destroy();
    socket = null;
  }
}
