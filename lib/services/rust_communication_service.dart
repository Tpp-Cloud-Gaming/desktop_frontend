import 'dart:io';
import 'dart:convert';

class RustCommunicationService {
  String ip = "127.0.0.1";
  //int port = 2930;
  Socket? socket;
  static const int maxAttempts = 5;
  static const Duration waitDuration = Duration(seconds: 5);

  Future<void> connect(int port) async {
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

  void startOffering(String username) {
    String msg = 'startOffering|$username\n';
    socket?.encoding = utf8;
    socket?.write(msg);
  }

  void startGameWithUser(String usernameClient, String userToConnect, String game) {
    String msg = 'startGameWithUser|$usernameClient|$userToConnect|$game\n';
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
  }
}
