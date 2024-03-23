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
