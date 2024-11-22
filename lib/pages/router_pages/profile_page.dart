import 'package:flutter/material.dart';
import 'package:omniwallet/navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OmniWallet"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Priya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.black),
                    title: Text("+1 (123) 456 7890"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.black),
                    title: Text("example@gmail.com"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.black),
                    title: Text("Settings"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text("Log Out", style: TextStyle(color: Colors.red)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:  () {
                    },
                    child: Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                  ),
                ],
              ),
            ), 
          ],
        ),
      ),
    );
  }
}