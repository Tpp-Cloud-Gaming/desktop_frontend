import 'package:socket_io_client/socket_io_client.dart' as io;

class WebRTCService {
  // Replace 'https://your_socket_server_url' with the URL of your Socket.IO server.
  final socket = io.io('http://localhost:3000');

  void connectToSocket() {
    socket.connect();

    socket.onConnect((_) {
      print('Connected to the socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

    socket.on('message', (data) {
      print('Received message: $data');
    });

    // Add more event listeners and functionality as needed.

    // To send a message to the server, use:
    // socket.emit('eventName', 'message data');
  }
}
