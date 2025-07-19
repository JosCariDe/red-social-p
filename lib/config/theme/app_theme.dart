import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF6AFB92);
  static const Color _backgroundColor = Color(0xFF1C2541);
  static const Color _scaffoldBackgroundColor = Color(0xFF0B132B);
  static const Color _cardColor = Color(0xFF1C2541);
  static const Color _textColor = Colors.white;
  static const Color _subtleTextColor = Colors.white70;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: _scaffoldBackgroundColor,
      cardColor: _cardColor,
      
      appBarTheme: const AppBarTheme(
        color: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
        titleTextStyle: TextStyle(
          color: _textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: _textColor),
        bodyMedium: TextStyle(color: _subtleTextColor),
        titleLarge: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: _backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: _primaryColor),
        ),
        labelStyle: const TextStyle(color: _subtleTextColor),
        hintStyle: const TextStyle(color: _subtleTextColor),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor.withAlpha(128);
          }
          return null;
        }),
      ),

      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _primaryColor,
        surface: _cardColor,
        onPrimary: _backgroundColor,
        onSecondary: _backgroundColor,
        onSurface: _textColor,
      ),
    );
  }
}
