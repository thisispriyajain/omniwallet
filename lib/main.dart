import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/firebase_options.dart';
import 'package:omniwallet/navigation/routerdemo.dart';
//import 'pages/login/signup_page.dart';
import 'package:provider/provider.dart';

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

  ThemeData get currentTheme => ThemeData(
    brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: _isBigFont ? 20.0: 16.0),
      bodyMedium: TextStyle(fontSize: _isBigFont ? 18.0 : 14.0),
      bodySmall: TextStyle(fontSize: _isBigFont ? 16.0: 12.0),
      headlineLarge: TextStyle(fontSize: _isBigFont ? 26.0: 22.0),
      headlineMedium: TextStyle(fontSize: _isBigFont ? 22.0: 18.0),
      headlineSmall: TextStyle(fontSize: _isBigFont ? 20.0: 16.0),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    ),
  );

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
      create: (_) => SettingsState(),
      child: Consumer<SettingsState>(
        builder: (context, settingsState, child) {
          return MaterialApp.router(
            title: 'OmniWallet',
            theme: settingsState.currentTheme,
            routerConfig: routerDemo(authenticationBloc),
          );
        },
      ),
    );
  }
}