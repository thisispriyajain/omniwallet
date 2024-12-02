import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeCubit extends Cubit<double> {
  FontSizeCubit() : super(16.0) {
    _loadFontSize();
  }

  void setFontSize(double size) async {
    emit(size);
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('font_size', size);
  }

  void _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSize = prefs.getDouble('font_size') ?? 16.0;
    emit(savedSize);
  }
}

