import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xff264653),
        unselectedItemColor: Colors.black38),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    dialogTheme: const DialogTheme(actionsPadding: EdgeInsets.only(bottom: 20)),
    primaryColor: const Color(0xff2a9d8f),
    backgroundColor: Colors.white,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
    cardColor: const Color(0xff2a9d8f),
    indicatorColor: const Color(0xffe76f51),
    primaryIconTheme: const IconThemeData(color: Color(0xff264653)),
    snackBarTheme: const SnackBarThemeData(backgroundColor: Color(0xff264653)),
    inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff2a9d8f)))),
    popupMenuTheme: const PopupMenuThemeData(color: Colors.white, elevation: 2),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.black54,
      ),
      bodyText2:
          TextStyle(color: Colors.black54, fontWeight: FontWeight.normal),
      headline1: TextStyle(
        color: Color(0xff264653),
      ),
      subtitle1: TextStyle(
        color: Colors.black38,
      ),
      subtitle2: TextStyle(
        color: Colors.black38,
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
    primaryColor: const Color(0xff2a9d8f),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xff264653),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38),
    primaryIconTheme: const IconThemeData(color: Colors.white),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xff264653),
    ),
    appBarTheme:
        const AppBarTheme(backgroundColor: Color(0xff264653), elevation: 0),
    backgroundColor: const Color(0xff264653),
    scaffoldBackgroundColor: const Color(0xff264653),
    indicatorColor: const Color(0xfff4a261),
    snackBarTheme: const SnackBarThemeData(backgroundColor: Color(0xff2a9d8f)),
    inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff2a9d8f)))),
    popupMenuTheme:
        const PopupMenuThemeData(color: Color(0xff264653), elevation: 2),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.white54,
      ),
      bodyText2:
          TextStyle(color: Colors.white54, fontWeight: FontWeight.normal),
      subtitle1: TextStyle(
        color: Colors.white30,
      ),
      subtitle2: TextStyle(
        color: Colors.white30,
      ),
      headline1: TextStyle(
        color: Colors.white,
      ),
      headline2: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
      headline4: TextStyle(
        color: Colors.white,
      ),
      headline5: TextStyle(
        color: Colors.white,
      ),
      headline6: TextStyle(
        color: Colors.white,
      ),
    ));
