import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/firebase_options.dart';
import 'package:omniwallet/navigation/routerdemo.dart';
import 'package:omniwallet/pages/settings_options/cubit/font_size/font_size_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omniwallet/pages/settings_options/cubit/theme/theme_cubit.dart';

//import 'pages/login/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FontSizeCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final authenticationBloc = AuthenticationBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((ThemeCubit cubit) => cubit.state);
    final fontSize = context.select((FontSizeCubit cubit) => cubit.state);
    
    return MaterialApp.router(
      title: 'OmniWallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: fontSize),
          bodyMedium: TextStyle(fontSize: fontSize * 0.9),
          bodySmall: TextStyle(fontSize: fontSize * 0.8),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: fontSize),
          bodyMedium: TextStyle(fontSize: fontSize * 0.9),
          bodySmall: TextStyle(fontSize: fontSize * 0.8),
        ),
      ),
      themeMode: themeMode,
      routerConfig: routerDemo(authenticationBloc),
    );
  }
}