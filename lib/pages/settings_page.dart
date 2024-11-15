import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = true;
  bool isLockdownMode = true;
  bool isFaceID = true;
  bool isNotifications = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          buildSwitchListTile('Dark Mode', isDarkMode, (value) {
            setState(() {
              isDarkMode = value;
            });
          }),
          buildSwitchListTile('Lockdown Mode', isLockdownMode, (value) {
            setState(() {
              isLockdownMode = value;
            });
          }),
          buildSwitchListTile('FaceID', isFaceID, (value) {
            setState(() {
              isFaceID = value;
            });
          }),
          buildSwitchListTile('Notifications', isNotifications, (value) {
            setState(() {
              isNotifications = value;
            });
          }),
        ],
      ),
    );
  }

Widget buildSwitchListTile(String title, bool value, ValueChanged<bool> onChanged) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.blue.withOpacity(0.2)),
      ),
    ),
    child: SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    ),
  );
}
}