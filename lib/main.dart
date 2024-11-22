import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omniwallet/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omniwallet/navigation/routerdemo.dart';
import 'package:omniwallet/pages/router_pages/home_page.dart';
import 'my_home_page.dart';
import 'pages/login/landing_page.dart';
import 'pages/login/forgot_password.dart';
import 'navigation_bar.dart';
import 'pages/router_pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/login/signup_page.dart';

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
    return MaterialApp.router(
      title: 'OmniWallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: routerDemo(),
    );
  }
}
