import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omniwallet/pages/login/landing_page.dart';

import 'pages/login/forgot_password.dart';
import 'pages/router_pages/home_page.dart';
import 'pages/login/signup_page.dart';
import 'pages/router_pages/tracking_page.dart';
import 'pages/router_pages/transactions_page.dart';
import 'pages/router_pages/settings_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  DocumentReference? docRef;

  final List<Widget> UIPages = [
    const LandingPage(),
    const ForgotPassword(),
    const SignupPage(),
    const HomePage(),
    const TransactionsPage(),
    const TrackingPage(),
    const SettingsPage(),
  ];

  void _incrementCounter() async {
    docRef = await FirebaseFirestore.instance.collection("test").add({'name':'Lauren'});
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Pages without functionality'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: UIPages.length,
        itemBuilder: (context, index) {
          final widgetName = UIPages[index].runtimeType.toString();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              color: const Color.fromARGB(255, 179, 206, 234),
              child: ListTile(
                title: Text(widgetName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UIPages[index]),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}