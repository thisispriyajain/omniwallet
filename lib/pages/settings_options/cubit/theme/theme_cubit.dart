import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme(bool isDarkMode) {
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
