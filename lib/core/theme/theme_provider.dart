import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  // Almacena el tema actual de la aplicación
  ThemeMode get themeMode => _themeMode;

  // Cambia el tema de la aplicación según el modo seleccionado
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
