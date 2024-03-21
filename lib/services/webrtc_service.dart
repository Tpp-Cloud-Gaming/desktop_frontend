//import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class WebRTCService {
  TcpSocketConnection socketConnection =
      TcpSocketConnection("127.0.0.1", 28080);

//receiving and sending back a custom message
  void messageReceived(String msg) {
    socketConnection.sendMessage("MessageIsReceived :D ");
  }

  void start() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    }
  }
}
