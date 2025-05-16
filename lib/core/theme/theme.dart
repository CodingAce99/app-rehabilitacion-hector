import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Tema claro
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFAF5EF),
    primaryColor: const Color(0xFFD8BBA1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAF5EF),
      foregroundColor: Color(0xFF4B4032),
      elevation: 0,
    ),
    cardColor: const Color(0xFFF5ECE5),
    iconTheme: const IconThemeData(color: Color(0xFFD8BBA1)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD8BBA1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFFD8BBA1)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFD8BBA1),
        side: const BorderSide(color: Color(0xFFD8BBA1)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFD8BBA1),
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD8BBA1),
      brightness: Brightness.light,
    ).copyWith(
      secondary: const Color(0xFFB8C1C2),
      primary: const Color(0xFFD8BBA1),
    ),
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      titleLarge: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF4B4032),
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF4B4032),
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        color: const Color(0xFF4B4032),
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        color: const Color(0xFF5C5244),
      ),
    ),
  );

  // Tema oscuro
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color(0xFFB0B0B0),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF1F1F1F),
    iconTheme: const IconThemeData(color: Color(0xFFB0B0B0)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E2E2E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2E2E2E),
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFB0B0B0),
      secondary: Color(0xFFB0B0B0),
      surface: Color(0xFF1F1F1F),
      background: Color(0xFF121212),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme).copyWith(
      titleLarge: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, color: Color(0xFFDADADA)),
    ),
  );
}
