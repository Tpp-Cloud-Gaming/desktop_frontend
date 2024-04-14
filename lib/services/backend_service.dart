import 'dart:io';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendService {
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  final String _baseUrl = 'cloud-gaming-server.onrender.com';

  Future<String?> createUser(
      Map<String, dynamic> formValues, bool createInFirebase) async {
    String? token = "";
    if (createInFirebase) {
      token = await firebaseAuth.registerWithEmail(
          formValues["email"], formValues["password"], formValues["username"]);
      if (token == null) {
        return "No se pudo obtener el token de autenticación";
      }
    } else {
      token = await firebaseAuth.getToken();
      if (token == null) {
        return "No se pudo obtener el token de autenticación";
      }
    }

    final url = Uri.https(_baseUrl, '/users/' + formValues["username"]);

    print(formValues);
    final resp = await http.post(url, body: json.encode(formValues), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: token
    });

    try {
      final Map<String, dynamic> decodedResp =
          json.decode(utf8.decode(resp.bodyBytes));
      if (decodedResp.containsKey("detail")) {
        return decodedResp["detail"];
      }
      if (decodedResp.containsKey('error')) {
        if (decodedResp['error'] ==
            'user with the provided email already exists') {
          return 'Usuario existente';
        } else {
          return 'No fué posible realizar el registro';
        }
      }

      return null;
    } on FormatException catch (_) {
      return "No se pudo realizar el registro: error ${resp.statusCode}";
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? username = firebaseAuth.getUsername();
    if (username == null) {
      return null;
    }

    final url = Uri.https(_baseUrl, '/users/$username');
    String? token = await firebaseAuth.getToken();
    if (token == null) {
      return null;
    }
    final resp = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: token
    });
    try {
      final Map<String, dynamic> decodedResp =
          json.decode(utf8.decode(resp.bodyBytes));
      if (decodedResp.containsKey("detail")) {
        return null;
      }
      return decodedResp;
    } on FormatException catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllGames() async {
    final url = Uri.https(_baseUrl, '/games');
    String? token = await firebaseAuth.getToken();
    if (token == null) {
      return null;
    }
    final resp = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: token
    });
    final List<dynamic> jsonData;
    try {
      jsonData = json.decode(utf8.decode(resp.bodyBytes));
    } on FormatException catch (_) {
      return null;
    }
    final List<Map<String, dynamic>> decodedResp =
        jsonData.map((dynamic item) => item as Map<String, dynamic>).toList();

    return decodedResp;
  }

  Future<Map<String, dynamic>?> getGame(String name) async {
    final url = Uri.https(_baseUrl, '/games/$name');
    String? token = await firebaseAuth.getToken();
    if (token == null) {
      return null;
    }
    final resp = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: token
    });
    try {
      final Map<String, dynamic> decodedResp =
          json.decode(utf8.decode(resp.bodyBytes));
      if (decodedResp.containsKey("detail")) {
        return null;
      }
      return decodedResp;
    } on FormatException catch (_) {
      return null;
    }
  }

  Future<String?> changeUserData(
      String username, Map<String, dynamic> data) async {
    final url = Uri.https(_baseUrl, '/users/$username');
    String? token = await firebaseAuth.getToken();
    if (token == null) {
      return null;
    }
    final resp = await http.put(url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: token
        },
        body: json.encode(data));
    try {
      final Map<String, dynamic> decodedResp =
          json.decode(utf8.decode(resp.bodyBytes));
      if (decodedResp.containsKey("detail")) {
        return decodedResp["detail"];
      }
      if (decodedResp.containsKey('error')) {
        return decodedResp['error'];
      }

      return null;
    } on FormatException catch (_) {
      return "No se pudo actualizar los datos: error ${resp.statusCode}";
    }
  }
}
