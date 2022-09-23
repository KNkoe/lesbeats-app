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
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(selectedItemColor: background),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: starCommandblue),
    primaryColor: starCommandblue,
    backgroundColor: babypowder,
    popupMenuTheme: const PopupMenuThemeData(elevation: 2),
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


// background-color: #0093E9;
// background-image: linear-gradient(160deg, #0093E9 0%, #80D0C7 100%);
