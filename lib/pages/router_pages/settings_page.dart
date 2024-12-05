import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omniwallet/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
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
 void initState() {
  super.initState();
  _loadPreferences();
 }

 Future<void> _loadPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final preferences = await FirebaseService.getUserPreferences(user.uid);
      if (preferences != null) {
        setState(() {
          isNotificationsEnabled = preferences['notificationsEnabled'] ?? false;
        });
      }
    }
  }

 @override
 Widget build(BuildContext context) {
  final settingsState = Provider.of<SettingsState>(context, listen: true);

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "OmniWallet",
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Color(0xFF0093FF),
            fontWeight: FontWeight.bold,
        ),
      ),
       centerTitle: true,
     ),
     body: ListView(
       children: [
         Padding(
           padding: EdgeInsets.all(16.0),
           child: Text(
             "General",
             style: Theme.of(context).textTheme.titleMedium?.copyWith(
               color: Colors.blue,
               fontSize: 18,
               fontWeight: FontWeight.w100,
             ),
           ),
         ),
         ListTile(
           title: Text('Language', style: Theme.of(context).textTheme.bodyLarge),
           subtitle: Text('English', style: Theme.of(context).textTheme.bodyMedium),
           leading: Icon(Icons.language, color: Colors.blue),
         ),
         Consumer<SettingsState>(
          builder: (context, settingsState, child) {
            return SwitchListTile(
              title: Text("Dark Mode", style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text(settingsState.isDarkMode ? "Enabled" : "Disabled", style: Theme.of(context).textTheme.bodyMedium),
              value: settingsState.isDarkMode,
              onChanged: (value) {
                settingsState.toggleDarkMode(value);
                GoRouter.of(context).go('/settings');
              },
              secondary: const Icon(Icons.brightness_6, color: Colors.blue),
            );
          },
        ),
        Consumer<SettingsState>(
          builder: (context, settingsState, child) {
            return ListTile(
              title: Text('Font Size', style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text(settingsState.isBigFont ? "Big Font" : "Small Font", style: Theme.of(context).textTheme.bodyMedium),
              leading: const Icon(Icons.text_fields, color: Colors.blue),
              trailing: DropdownButton<bool>(
                value: settingsState.isBigFont,
                items: const [
                  DropdownMenuItem(value: false, child: Text("Small")),
                  DropdownMenuItem(value: true, child: Text("Big")),
                ],
                onChanged: (value) {
                  settingsState.toggleFontSize(value ?? false);
                  GoRouter.of(context).go('/settings');
                },
              ),
            );
          },
        ),
        SwitchListTile(
          title: Text("Notifications", style: Theme.of(context).textTheme.bodyLarge),
          subtitle: Text(isNotificationsEnabled ? "Enabled" : "Disabled", style: Theme.of(context).textTheme.bodyMedium),
          value: isNotificationsEnabled,
          secondary: const Icon(Icons.notifications, color: Colors.blue),
          onChanged: (value) async {
            if (mounted) {
              setState(() {
                isNotificationsEnabled = value;
              });
            }

            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({
                      'preferences': {'notificationsEnabled' : value},
                    }, SetOptions(merge: true));
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update notification preference: $e')),
                  );
                }
              }
            }
            if (mounted) {
              GoRouter.of(context).go('/settings');
            }
          }
        ),
        const Divider(),

        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
             "Account",
             style: Theme.of(context).textTheme.titleMedium?.copyWith(
               color: Colors.blue,
               fontWeight: FontWeight.w100,
             ),
           ),
         ),
         ListTile(
           title: Text('Name', style: Theme.of(context).textTheme.bodyLarge),
           subtitle: Text(FirebaseAuth.instance.currentUser?.displayName ?? 'No name set', style: Theme.of(context).textTheme.bodyMedium),
           leading: const Icon(Icons.person, color: Colors.blue),
           onTap: () {
            _showNameEditDialog(context);
           },
         ),
         ListTile(
           title: Text('Email', style: Theme.of(context).textTheme.bodyLarge),
           subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? 'No email available', style: Theme.of(context).textTheme.bodyMedium),
           leading: const Icon(Icons.email, color: Colors.blue),
         ),
         ListTile(
           title: Text(
             'Log Out',
             style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
           ),
           leading: const Icon(Icons.logout, color: Colors.red),
           onTap: () async {
             await FirebaseAuth.instance.signOut();
             await GoogleSignIn().signOut();
             GoRouter.of(context).go('/login');
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
       title: Text('Edit Name', style: Theme.of(context).textTheme.titleMedium),
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