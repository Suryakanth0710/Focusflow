import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    const base = Color(0xFFF7F7F9);
    const card = Colors.white;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: base,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D6CDF),
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, height: 1.4),
        bodyMedium: TextStyle(fontSize: 14, height: 1.35),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
