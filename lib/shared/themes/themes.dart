import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_schemes.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: _lightColorScheme.onPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _lightColorScheme.onPrimary,
    foregroundColor: _lightColorScheme.onPrimary,
  ),
  dialogBackgroundColor: _lightColorScheme.onPrimary,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 22,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 18,
    ),
    bodySmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 14,
    ),
    titleLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.roboto(
      color: Colors.black,
      fontSize: 24,
    ),
    labelMedium: GoogleFonts.roboto(
      color: Colors.black,
      fontSize: 20,
    ),
    labelSmall: GoogleFonts.roboto(
      color: Colors.black,
      fontSize: 16,
    ),
    displayLarge: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: _darkColorScheme.onPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _darkColorScheme.onPrimary,
    foregroundColor: _darkColorScheme.onPrimary,
  ),
  dialogBackgroundColor: _darkColorScheme.onPrimary,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 24,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 20,
    ),
    bodySmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 16,
    ),
    titleLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 24,
    ),
    labelMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 20,
    ),
    labelSmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 16,
    ),
    displayLarge: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);
