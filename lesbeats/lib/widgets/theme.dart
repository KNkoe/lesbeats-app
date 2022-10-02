import 'package:flutter/material.dart';

const Color starCommandblue = Color(0xff2D80B0);
const Color grey = Color(0xffCBCBCB);
const Color yellow = Color(0xffF1D801);
const Color babypowder = Color(0xffFFFCF9);
const Color black = Color(0xff141414);
const Color background = Color(0xff02020A);
const Color coquilicot = Color(0xffFC440F);
const Color malachite = Color(0xff09E85E);

ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffFCFFF7),
    appBarTheme:
        const AppBarTheme(backgroundColor: Color(0xff2a9d8f), elevation: 0),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(selectedItemColor: background),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xff2a9d8f)),
    primaryColor: const Color(0xff2a9d8f),
    backgroundColor: const Color(0xffFCFFF7),
    cardColor: const Color(0xff2a9d8f),
    indicatorColor: const Color(0xffe76f51),
    canvasColor: const Color(0xffFCFFF7),
    inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff2a9d8f)))),
    popupMenuTheme:
        const PopupMenuThemeData(color: Color(0xffFCFFF7), elevation: 2),
    textTheme: const TextTheme(
      headline1: TextStyle(),
      headline2: TextStyle(),
      headline3: TextStyle(),
      headline4: TextStyle(),
      headline5: TextStyle(),
      headline6: TextStyle(),
    ));

const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xff0093E9), starCommandblue]);

ThemeData darkTheme = ThemeData(
    backgroundColor: const Color(0xff264653),
    indicatorColor: const Color(0xfff4a261));
