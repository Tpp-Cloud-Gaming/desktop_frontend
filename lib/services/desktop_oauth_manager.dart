import 'dart:async';
import 'dart:io';

import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:oauth2/oauth2.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:window_to_front/window_to_front.dart';

const String redirectUrl = 'http://localhost:';
const String googleAuthApi = "https://accounts.google.com/o/oauth2/v2/auth";
const String googleTokenApi = "https://oauth2.googleapis.com/token";
const String revokeTokenUrl = 'https://oauth2.googleapis.com/revoke';

class DesktopLoginManager {
  HttpServer? redirectServer;
  oauth2.Client? client;

  // Launch the URL in the browser using url_launcher
  Future<void> redirect(Uri authorizationUrl) async {
    var url = authorizationUrl.toString();
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Future<Map<String, String>> listen() async {
    var request = await redirectServer!.first;
    var params = request.uri.queryParameters;
    await WindowToFront
        .activate(); // Using window_to_front package to bring the window to the front after successful login.
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await redirectServer!.close();
    redirectServer = null;
    return params;
  }
}

class DesktopOAuthManager extends DesktopLoginManager {
  DesktopOAuthManager() : super();

  Future<oauth2.Credentials> login() async {
    await redirectServer?.close();
    // Bind to an ephemeral port on localhost
    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = redirectUrl + redirectServer!.port.toString();
    var authenticatedHttpClient = await _getOauthClient(Uri.parse(redirectURL));

    return authenticatedHttpClient.credentials;
  }

  Future<User?> signInWithGoogle() async {
    User? user;

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      Credentials credentials = await login();

      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: credentials.idToken, accessToken: credentials.accessToken);

      UserCredential userCredential = await _signInWithFirebase(authCredential);
      user = userCredential.user;
    }
    return user;
  }

  Future<UserCredential> _signInWithFirebase(
      AuthCredential authCredential) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential;

    try {
      userCredential = await auth.signInWithCredential(authCredential);
      //TODO: cambiar el nombre de usuario
      await auth.currentUser!.updateDisplayName("Google");
    } on FirebaseAuthException catch (error) {
      throw Exception('Could not authenticated $error');
    }

    return userCredential;
  }

  Future<oauth2.Client> _getOauthClient(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
        dotenv.env["CLIENT_ID"]!, //Your google client ID
        Uri.parse(googleAuthApi),
        Uri.parse(googleTokenApi),
        httpClient: JsonAcceptingHttpClient(),
        secret: dotenv.env["TOKEN_API"]! //Your google client secret
        );

    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: ['email']);
    await redirect(authorizationUrl);
    var responseQueryParameters = await listen();
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }

  Future<bool> signOutFromGoogle(String accessToken) async {
    final Uri uri = Uri.parse(revokeTokenUrl)
        .replace(queryParameters: {'token': accessToken});
    final http.Response response = await http.post(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        if (FirebaseAuth.instance.currentUser != null) {
          String? token = await FirebaseAuth.instance.currentUser!.getIdToken();
          if (token != null) {
            await signOutFromGoogle(token);
          }
        }
      }
      await auth.signOut();
    } on Exception {
      throw Exception('Something went wrong');
    }
  }
}

class JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}
