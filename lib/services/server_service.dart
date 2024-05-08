import 'dart:async';

import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerService {
  final wsUrl = Uri.parse('wss://cloud-gaming-server.onrender.com');
  late WebSocketChannel _channel;

  ServerService() {
    _channel = WebSocketChannel.connect(wsUrl);
  }

  Future<void> start(String username) async {
    await channel.ready;

    channel.sink.add('initOfferer|${username}');

    print("ya mande el start");
  }

  Future<void> loadGame(String game) async {
    await channel.ready;

    channel.sink.add('getUsersForGame|${game}');

    print("ya mande el game");
  }

  Future<void> listen() async {
    channel.stream.listen(
      (message) {
        // Handle incoming messages
        print("Recibo mensaje: $message");
      },
      onDone: () {
        // WebSocket is closed
        print('Connection closed');
        channel.sink.close(status.goingAway);
      },
      onError: (error) {
        // Handle errors
        print('Error received: $error');
        channel.sink.close(status.goingAway);
      },
    );
    print("Se va del listen");
  }

  WebSocketChannel get channel => _channel;
}
