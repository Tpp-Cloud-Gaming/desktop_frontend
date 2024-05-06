import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class RustCommunicationProvider extends ChangeNotifier {
  Socket socket;

  RustCommunicationProvider(this.socket);

  void doneHandler(){
    socket.destroy();
  }

  void startOffering(){
    String msg = 'startOffering|franco\n';
    socket.encoding = utf8;
    socket.write(msg);
  }

  void startGameWithUser(){
    String msg = 'startGameWithUser|tadeo|franco|valorant\n';
    socket.encoding = utf8;
    socket.writeln(msg);
  }
}
