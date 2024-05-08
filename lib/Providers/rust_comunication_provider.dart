import 'package:flutter/material.dart';
import 'dart:io';

class RustCommunicationProvider extends ChangeNotifier {
  final Socket _socket;

  RustCommunicationProvider(this._socket);

  void doneHandler(){
    _socket.destroy();
  }

  Socket get socket => _socket;

}
