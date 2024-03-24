import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

class ServerService {
  final socket = io.io('http://127.0.0.1:3000', <String, dynamic>{
    'transports': ['websocket'],
    "autoConnect": true,
    "reconnection": true,
  });

  void start() {
    try {
      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('location', (data) => handleLocationListen);
      socket.on('typing', (data) => handleTyping);
      socket.on('message', (data) {
        print("Recibo Mensaje!!!");
      });
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  // Send Location to Server
  sendLocation(Map<String, dynamic> data) {
    socket.emit("location", data);
  }

  // Listen to Location updates of connected users from server
  handleLocationListen(Map<String, dynamic> data) async {
    print(data);
  }

  // Send update of user's typing status
  sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }

  // Listen to update of typing status from connected users
  void handleTyping(Map<String, dynamic> data) {
    print(data);
  }

  void login(String username, String password, BuildContext context) {
    socket.emitWithAck(
      "Login",
      {"username": username, "password": password},
      ack: (data) {
        if (data) {
          Navigator.pushNamed(context, 'home');
        } else {
          NotificationsService.showSnackBar("Incorrect Username or Password",
              Colors.red, AppTheme.loginPannelColor);
        }
      },
    );
  }

  void register(
      String email, String username, String password, BuildContext context) {
    socket.emitWithAck(
      "Register",
      {"email": email, "username": username, "password": password},
      ack: (data) {
        if (data) {
          Navigator.pushNamed(context, 'home');
        } else {
          NotificationsService.showSnackBar("Incorrect Username or Password",
              Colors.red, AppTheme.loginPannelColor);
        }
      },
    );
  }

  // Send a Message to the server
  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Listen to all message events from connected users
  void handleMessage(Map<String, dynamic> data) {
    print(data);
  }
}
