import 'dart:io';
import 'dart:convert';

class RustCommunicationService {

  Socket socket;
  RustCommunicationService(this.socket);
  


  void startOffering(String username){
    String msg = 'startOffering|$username\n';
    socket.encoding = utf8;
    socket.write(msg);
  }

  void startGameWithUser(String usernameClient, String userToConnect ){
    String msg = 'startGameWithUser|$usernameClient|$userToConnect|cuphead\n';
    socket.encoding = utf8;
    socket.writeln(msg);
  }

}