import 'dart:io';
import 'package:cloud_gaming/firebase_options.dart';
import 'package:cloud_gaming/routes/app_routes.dart';
import 'package:cloud_gaming/screens/screens.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/services/server_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); //por mas que es windows usar la config de android para firebase

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //setWindowMaxSize(const Size(1920, 1080));
    setWindowMinSize(const Size(1700, 900));
  }
  final prefs = await SharedPreferences.getInstance();

  //Esto es para hacer la com con RUST
  //await comunication();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool remember = widget.prefs.getBool('remember') ?? false;
    return MaterialApp(
      theme: AppTheme.lightTheme,
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
      home: remember ? const HomeScreen() : const LocationScreen(),
      routes: AppRoutes.routes,
      scaffoldMessengerKey: NotificationsService.messengerKey,
    );
  }
}

Future<void> comunication() async {
  //WebRTCService().start();
}
