import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Definition
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6200EA),
      // Rich purple
      secondary: Color(0xFF03DAC6),
      // Teal for contrast
      surface: Color(0xFFFFFFFF),
      // White for clean backgrounds
      onPrimary: Color(0xFFFFFFFF),
      // White text on primary
      onSurface: Color(0xFF000000), // Black text on surface
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    // Light gray
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6200EA), // Solid fallback color
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF000000)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF757575)),
      // Subtle gray
      headlineSmall: TextStyle(fontSize: 20, color: Color(0xFF6200EA)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6200EA),
        // Use gradient in widgets instead
        textStyle: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  // Dark Theme Definition
  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFBB86FC),
      // Softer purple for dark mode
      secondary: Color(0xFF03DAC6),
      // Bright teal
      surface: Color(0xFF121212),
      // Deep black surface
      onPrimary: Color(0xFF000000),
      // Black text on lighter primary
      onSurface: Color(0xFFFFFFFF), // White text on dark surface
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF3700B3), // Solid fallback color
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
      // Subtle gray
      headlineSmall: TextStyle(fontSize: 20, color: Color(0xFF03DAC6)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF03DAC6),
        // Use gradient in widgets instead
        textStyle: const TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
