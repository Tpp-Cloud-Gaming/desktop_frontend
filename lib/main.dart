import 'dart:io';

import 'package:cloud_gaming/routes/app_routes.dart';
import 'package:cloud_gaming/screens/login_screen.dart';
import 'package:cloud_gaming/services/server_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //setWindowMaxSize(const Size(1920, 1080));
    setWindowMinSize(const Size(1700, 900));
  }

  //Esto es para hacer la com con RUST
  //await comunication();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ServerService server = ServerService();
  @override
  void initState() {
    super.initState();
    server.start();
    server.sendMessage("Hola desde Flutter");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('es', ''), // Default English
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Cloud Gaming',
      home: LoginScreen(server: server),
      routes: AppRoutes.routes,
    );
  }
}

Future<void> comunication() async {
  //WebRTCService().start();
}
