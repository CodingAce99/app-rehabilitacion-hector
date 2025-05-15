import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF9F6F3),
    primaryColor: const Color(0xFFC9A98D),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF9F6F3),
      foregroundColor: Color(0xFF3E3E3E),
      elevation: 0,
    ),
    cardColor: const Color.fromARGB(255, 248, 244, 241),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFF3E3E3E),
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: Color(0xFF4D4D4D)),
    ),
    iconTheme: IconThemeData(color: Color.fromARGB(255, 196, 164, 138)),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF91A8B0),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    primaryColor: const Color.fromARGB(255, 142, 116, 175),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF2C2C2C),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Color(0xFFDADADA)),
    ),
    iconTheme: IconThemeData(color: Color.fromARGB(255, 142, 116, 175)),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: const Color(0xFFB294C7)),
  );
}
