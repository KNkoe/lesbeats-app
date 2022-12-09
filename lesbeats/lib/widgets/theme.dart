import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xff2a9d8f)),
    dialogTheme: const DialogTheme(actionsPadding: EdgeInsets.only(bottom: 20)),
    primaryColor: const Color(0xff2a9d8f),
    backgroundColor: Colors.white,
    cardColor: const Color(0xff2a9d8f),
    indicatorColor: const Color(0xffe76f51),
    snackBarTheme: const SnackBarThemeData(backgroundColor: Color(0xff264653)),
    inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff2a9d8f)))),
    popupMenuTheme: const PopupMenuThemeData(color: Colors.white, elevation: 2),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Color(0xff264653),
      ),
      headline2: TextStyle(
        color: Color(0xff264653),
      ),
      headline3: TextStyle(
        color: Color(0xff264653),
      ),
      headline4: TextStyle(
        color: Color(0xff264653),
      ),
      headline5: TextStyle(
        color: Color(0xff264653),
      ),
      headline6: TextStyle(
        color: Color(0xff264653),
      ),
    ));

ThemeData darkTheme = ThemeData(
    backgroundColor: const Color(0xff264653),
    indicatorColor: const Color(0xfff4a261));
