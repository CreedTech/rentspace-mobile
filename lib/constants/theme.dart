import 'package:rentspace/constants/colors.dart';
import 'package:flutter/material.dart';

class Themes {
  //Light Theme params
  final lightTheme = ThemeData().copyWith(
    primaryColor: brandOne,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      color: brandOne,
    ),
    canvasColor: const Color(0xFFFFFFFF),
    cardColor: const Color(0xFFF5F5F5),
    primaryColorLight: const Color(0xFFf2eeed),
    unselectedWidgetColor: brandOne,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandOne,
      primary: Colors.white,
    ),
  );
  //Dark Theme params
  final darkTheme = ThemeData().copyWith(
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: brandOne,
    ),
    scaffoldBackgroundColor: brandOne,
    unselectedWidgetColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandTwo,
      primary: brandOne,
    ),
    canvasColor: const Color(0xFF00283C),
    cardColor: const Color(0xFF363636),
    primaryColorLight: const Color(0xFF363636),
  );
}
