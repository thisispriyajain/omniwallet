// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Transactions",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Tracking",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
      },
    );
  }
}