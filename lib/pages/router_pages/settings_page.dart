import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omniwallet/widgets/scaffold_with_nav_bar.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:omniwallet/pages/settings_options/cubit/font_size/font_size_cubit.dart';
import 'package:omniwallet/pages/settings_options/cubit/theme/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<Map<String, dynamic>> fetchAllPreferences() async {
    try {
      final notificationsEnabled = await fetchPreference('notifications');
      return {
        'notifications': notificationsEnabled ?? true,
      };
    } catch (e) {
      print('Error fetching preferences: $e');
      return {'notifications': true};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OmniWallet',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchAllPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading settings'));
          } 
          final preferences = snapshot.data ?? {};
          
          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text('General'),
                tiles: [
                  SettingsTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    value: const Text('English'),
                  ),
                  SettingsTile(  
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Theme'),
                    value: BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        return Text(themeMode == ThemeMode.dark ? 'Dark' : 'Light');
                      },
                    ),
                    onPressed: (context) {
                      showThemeDialog(context);
                    },
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.text_fields),
                    title: const Text('Font'),
                    value: const Text('Font Size'),
                    onPressed: (context) {
                      _showFontSizeDialog(context);
                    },
                  ),
                  SettingsTile.switchTile(
                    onToggle: (bool value) async {
                      try {
                        await savePreference('notifications', value);
                        print('Notification preference updated: $value');
                      } catch (e) {
                        print('Failed to save notification preference: $e');
                      } 
                    },
                    initialValue: preferences['notifications'],
                    leading: const Icon(Icons.notifications),
                    title: const Text('Push Notifications'),
                  ),
                ],
              ),

              SettingsSection(
                title: const Text('Account'),
                tiles: [
                  SettingsTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Name'),
                    value: Text(FirebaseAuth.instance.currentUser?.displayName ?? 'No name set'),
                    onPressed: (context) {
                      _showNameEditDialog(context);
                    },
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    value: Text(FirebaseAuth.instance.currentUser?.email ?? 'No email available'),
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: (context) async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
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

void showThemeDialog(BuildContext context) {
  final themeCubit = context.read<ThemeCubit>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeCubit.state,
              onChanged: (value) {
                themeCubit.emit(value!);
                Navigator.pop(context);
              },              
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeCubit.state,
              onChanged: (value) {
                themeCubit.emit(value!);
                Navigator.pop(context);
              },           
            ),
          ],
        ),
      );
    }
  );
}

void _showFontSizeDialog(BuildContext context) {
  final fontSizeCubit = context.read<FontSizeCubit>();

  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return BlocBuilder<FontSizeCubit, double> (
        builder: (context, fontSize) {
          return AlertDialog(
            title: const Text('Adjust Font Size'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sample Text',
                  style: TextStyle(fontSize: fontSize),
                ),
                Slider(
                  min: 12.0,
                  max: 24.0,
                  value: fontSize,
                  divisions: 6,
                  label: fontSize.toStringAsFixed(0),
                  onChanged: (value) {
                    fontSizeCubit.setFontSize(value);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> savePreference(String key, dynamic value) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  try {
    await FirebaseFirestore.instance
        .collection('userPreferences')
        .doc(user.uid)
        .set({key: value}, SetOptions(merge: true));
    print('Preference saved: $key = $value');
  } catch (e) {
    print('Error saving preference: $e');
  }
}

Future<dynamic> fetchPreference(String key) async {
  final user = FirebaseAuth.instance.currentUser;

  if(user == null) {
    throw Exception('User not logged in');
  }

  try {
    final doc = await FirebaseFirestore.instance
      .collection('userPreferences')
      .doc(user.uid)
      .get();

    return doc.data()?[key];
  } catch (e) {
    print('Error fetching preference: $e');
    return null;
  }
}