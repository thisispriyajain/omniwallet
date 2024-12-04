import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/firebase_options.dart';
import 'package:omniwallet/navigation/routerdemo.dart';
import 'package:provider/provider.dart';
//import 'pages/login/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class SettingsState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isBigFont = false;

  bool get isDarkMode => _isDarkMode;
  bool get isBigFont => _isBigFont;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleFontSize(bool value) {
    _isBigFont = value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final authenticationBloc = AuthenticationBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsState(),
      child: Consumer<SettingsState>(
        builder: (context, settingsState, child) {
          return MaterialApp.router(
            title: 'OmniWallet',
            theme: ThemeData(
              brightness: settingsState.isDarkMode ? Brightness.dark : Brightness.light,
              textTheme: TextTheme(
                bodyLarge: TextStyle(fontSize: settingsState.isBigFont ? 18.0 : 14.0),
                bodyMedium: TextStyle(fontSize: settingsState.isBigFont ? 16.0: 12.0),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: settingsState.isDarkMode ? Brightness.dark : Brightness.light,
              ),
            ),
            routerConfig: routerDemo(authenticationBloc),
          );
        },
      ),
    );
  }
}