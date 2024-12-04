import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:omniwallet/main.dart';


class SettingsPage extends StatefulWidget {
 const SettingsPage({super.key});


 @override
 _SettingsPageState createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {
 bool isNotificationsEnabled = false;


 @override
 Widget build(BuildContext context) {
   final settingsState = Provider.of<SettingsState>(context, listen: true);


   return Scaffold(
     appBar: AppBar(
       title: const Text(
         "Omniwallet",
         style: TextStyle(
           color: Color(0xFF0093FF),
           fontSize: 30,
           fontWeight: FontWeight.bold,
         ),
       ),
       centerTitle: true,
     ),
     body: ListView(
       children: [
         const Padding(
           padding: EdgeInsets.all(16.0),
           child: Text(
             "General",
             style: TextStyle(
               color: Colors.blue,
               fontSize: 18,
               fontWeight: FontWeight.w100,
             ),
           ),
         ),
         const ListTile(
           title: Text('Language'),
           subtitle: Text('English'),
           leading: Icon(Icons.language, color: Colors.blue),
         ),
         SwitchListTile(
           title: const Text("Dark Mode"),
           subtitle: Text(settingsState.isDarkMode ? "Enabled" : "Disabled"),
           value: settingsState.isDarkMode,
           onChanged: (value) {
             settingsState.toggleDarkMode(value);
           },
           secondary: const Icon(Icons.brightness_6, color: Colors.blue),
         ),
         ListTile(
           title: const Text('Font Size'),
           subtitle: Text(settingsState.isBigFont ? "Big Font" : "Small Font"),
           leading: const Icon(Icons.text_fields, color: Colors.blue),
           trailing: DropdownButton<bool>(
             value: settingsState.isBigFont,
             items: const [
               DropdownMenuItem(value: false, child: Text("Small")),
               DropdownMenuItem(value: true, child: Text("Big")),
             ],
             onChanged: (value) {
               settingsState.toggleFontSize(value ?? false);
             },
           ),
         ),
         SwitchListTile(
           title: const Text("Notifications"),
           subtitle: Text(isNotificationsEnabled ? "Enabled" : "Disabled"),
           value: isNotificationsEnabled,
           onChanged: (value) {
             setState(() {
               isNotificationsEnabled = value;
             });
           },
           secondary: const Icon(Icons.notifications, color: Colors.blue),
         ),
         const Divider(),


         const Padding(
           padding: EdgeInsets.all(16.0),
           child: Text(
             "Account",
             style: TextStyle(
               color: Colors.blue,
               fontSize: 18,
               fontWeight: FontWeight.w100,
             ),
           ),
         ),
         ListTile(
           title: const Text('Name'),
           subtitle: Text(FirebaseAuth.instance.currentUser?.displayName ?? 'No name set'),
           leading: const Icon(Icons.person, color: Colors.blue),
           onTap: () {
            _showNameEditDialog(context);
           },
         ),
         ListTile(
           title: const Text('Email'),
           subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? 'No email available'),
           leading: const Icon(Icons.email, color: Colors.blue),
         ),
         ListTile(
           title: const Text(
             'Log Out',
             style: TextStyle(color: Colors.red),
           ),
           leading: const Icon(Icons.logout, color: Colors.red),
           onTap: () async {
             await FirebaseAuth.instance.signOut();
             await GoogleSignIn().signOut();
           },
         ),
       ]
     )
   );
 }
}

void _showNameEditDialog(BuildContext context) {
 final user = FirebaseAuth.instance.currentUser;
 final TextEditingController nameController = TextEditingController(text: user?.displayName);


 showDialog(
   context: context,
   builder: (BuildContext context) {
     return AlertDialog(
       title: const Text('Edit Name'),
       content: TextField(
         controller: nameController,
         decoration: const InputDecoration(
           labelText: 'Name',
           hintText: 'Enter your name',
         ),
       ),
       actions: [
         TextButton(
           onPressed: () {
             Navigator.pop(context);
           },
           child: const Text('Cancel'),
         ),
         ElevatedButton(
           onPressed: () async {
             try {
               await user?.updateDisplayName(nameController.text);
               await user?.reload();
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Name updated successfully')),
               );
               Navigator.pop(context);
             } catch (e) {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Failed to update name: $e')),
               );
             }
           },
           child: const Text('Save'),
         ),
       ],
     );
   },
 );
}