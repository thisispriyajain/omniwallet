import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/firebase_options.dart';
import 'package:omniwallet/navigation/routerdemo.dart';
//import 'pages/login/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
  print('Message notification: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(await FirebaseInstallations.instance.getId());
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  const vapidKey =
      "BI8WScW_CiCQMj-yBaJm1587JI6B-yMlJDo0PG-Rs-wSaqaaGUhQn7tsRi0mCeOXV1EcyVVqXsymN3rPk2LokkE";
  String? token;
  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
    token = await messaging.getToken(
      vapidKey: vapidKey,
    );
  } else {
    try {
      token = await messaging.getToken();
    } catch (e) {
      print("Error getting token $e");
    }
  }
  print("Messaging token: $token");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class SettingsState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isBigFont = false;

  bool get isDarkMode => _isDarkMode;
  bool get isBigFont => _isBigFont;

  ThemeData get currentTheme => ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: _isBigFont ? 20.0 : 16.0),
          bodyMedium: TextStyle(fontSize: _isBigFont ? 18.0 : 14.0),
          bodySmall: TextStyle(fontSize: _isBigFont ? 16.0 : 12.0),
          headlineLarge: TextStyle(fontSize: _isBigFont ? 26.0 : 22.0),
          headlineMedium: TextStyle(fontSize: _isBigFont ? 22.0 : 18.0),
          headlineSmall: TextStyle(fontSize: _isBigFont ? 20.0 : 16.0),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
      );

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleFontSize(bool value) {
    _isBigFont = value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final authenticationBloc = AuthenticationBloc();
  late final routerConfig = routerDemo(authenticationBloc);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsState(),
      child: Consumer<SettingsState>(
        builder: (context, settingsState, child) {
          return MaterialApp.router(
            title: 'OmniWallet',
            theme: settingsState.currentTheme,
            routerConfig:
                routerConfig, //prevent theme to reinitailize routerConfig
          );
        },
      ),
    );
  }
}
