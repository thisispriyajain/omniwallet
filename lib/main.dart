import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omniwallet/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_home_page.dart';
import 'pages/landing_page.dart';
import 'pages/forgot_password.dart';
import 'navigation_bar.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniWallet',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // '/': (context) => MyHomePage(),
        '/landing': (context) => LandingPage(),
        '/forgot_password': (context) => ForgotPassword(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingsPage(),
      },
     home: const MyHomePage(title: 'OmniWallet'),
      //home: const LandingPage(),
      //home: const ForgotPassword(),
      //home: SettingsPage(),
    );
  }
}
