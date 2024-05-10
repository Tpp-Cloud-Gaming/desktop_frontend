import 'dart:io';
import 'dart:convert';

class RustCommunicationService {

  String ip = "127.0.0.1";
  int port = 2930;
  Socket? socket;
  
  Future<void> connect() async {
    socket = await Socket.connect(ip, port);
    return;
  }
  

  void startOffering(String username){
    String msg = 'startOffering|$username\n';
    socket?.encoding = utf8;
    socket?.write(msg);
  }

  void startGameWithUser(String usernameClient, String userToConnect, String game ){
    String msg = 'startGameWithUser|$usernameClient|$userToConnect|$game\n';
    socket?.encoding = utf8;
    socket?.writeln(msg);
  }
  
  void disconnect(){
    socket?.destroy();
  }

}