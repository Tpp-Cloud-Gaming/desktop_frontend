import 'dart:io';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendService {
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  final String _baseUrl = 'cloud-gaming-server.onrender.com';

  Future<String?> createUser(Map<String, dynamic> formValues) async {
    String? token = await firebaseAuth.registerWithEmail(
        formValues["email"], formValues["password"], formValues["username"]);
    if (token == null) {
      return "No se pudo obtener el token de autenticación";
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
}
