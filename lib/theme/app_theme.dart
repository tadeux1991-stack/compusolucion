import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonPurple = Color(0xFFD500F9);
  static const Color darkBg = Color(0xFF0A0A12);
  static const Color glassWhite = Color(0x1AFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: neonCyan,
      colorScheme: ColorScheme.dark(
        primary: neonCyan,
        secondary: neonPurple,
        surface: Color(0xFF1E1E2C),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          decoration: TextDecoration.none,
        ),
        headlineMedium: GoogleFonts.orbitron(
          color: neonCyan,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
        bodyLarge: const TextStyle(decoration: TextDecoration.none),
        bodyMedium: const TextStyle(decoration: TextDecoration.none),
      ),
    );
  }
}
