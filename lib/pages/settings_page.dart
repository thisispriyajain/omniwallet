import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isLockdownMode = false;
  bool isFaceID = false;
  bool isNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              activeColor: Colors.blue,
            ),
            Divider(),
            SwitchListTile(
              title: Text("Lockdown Mode"),
              value: isLockdownMode,
              onChanged: (value) {
                setState(() {
                  isLockdownMode = value;
                });
              },
              activeColor: Colors.blue,
            ),
            Divider(),
            SwitchListTile(
              title: Text("Face ID"),
              value: isFaceID,
              onChanged: (value) {
                setState(() {
                  isFaceID = value;
                });
              },
              activeColor: Colors.blue,
            ),
            Divider(),
            SwitchListTile(
              title: Text("Notifications"),
              value: isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}