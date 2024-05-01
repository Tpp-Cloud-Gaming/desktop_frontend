import 'dart:io';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class BackendService {
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  final String _baseUrl = 'cloud-gaming-server.onrender.com';

  Future<String?> createUser(Map<String, dynamic> formValues, bool createInFirebase) async {
    String? token = "";
    if (createInFirebase) {
      token = await firebaseAuth.registerWithEmail(formValues["email"], formValues["password"], formValues["username"]);
      if (token == null) {
        return "cannot create user in firebase";
      }
    } else {
      token = await firebaseAuth.getToken();
      if (token == null) {
        return "cannot get token from firebase";
      }
    }

    final url = Uri.https(_baseUrl, '/users/' + formValues["username"]); //NO HACER LA SUGERENCIA

    final resp = await http.post(url, body: json.encode(formValues), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: token
    });

    String? error = checkResponse(resp);
    if (error != null) {
      return error;
    }

    try {
      json.decode(utf8.decode(resp.bodyBytes));
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

    String? error = checkResponse(resp);
    if (error != null) {
      return null;
    }

    try {
      final Map<String, dynamic> decodedResp = json.decode(utf8.decode(resp.bodyBytes));
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

    String? error = checkResponse(resp);
    if (error != null) {
      return null;
    }

    final List<dynamic> jsonData;
    try {
      jsonData = json.decode(utf8.decode(resp.bodyBytes));
    } on FormatException catch (_) {
      return null;
    }

    return jsonData.map((dynamic item) => item as Map<String, dynamic>).toList();
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

    String? error = checkResponse(resp);
    if (error != null) {
      return null;
    }

    try {
      final Map<String, dynamic> decodedResp = json.decode(utf8.decode(resp.bodyBytes));
      return decodedResp;
    } on FormatException catch (_) {
      return null;
    }
  }

  Future<String?> changeUserData(String username, Map<String, dynamic> data) async {
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

    String? error = checkResponse(resp);
    if (error != null) {
      return null;
    }
    try {
      json.decode(utf8.decode(resp.bodyBytes));
      return null;
    } on FormatException catch (_) {
      return "Cant edit the user data error: ${resp.statusCode}";
    }
  }

  Future<String?> addUserGames(List<Map<String, dynamic>> games) async {
    String? username = firebaseAuth.getUsername();
    if (username == null) {
      return "Username not found";
    }

    final url = Uri.https(_baseUrl, '/users/$username/games');
    String? token = await firebaseAuth.getToken();
    if (token == null) {
      return "User token not found";
    }
    final resp = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: token
        },
        body: jsonEncode(games));
    String? error = checkResponse(resp);
    if (error != null) {
      return error;
    }
    return null;
  }

  String? checkResponse(Response resp) {
    if (resp.statusCode < 200 || resp.statusCode > 300) {
      return resp.toString();
    }
    return null;
  }
}
