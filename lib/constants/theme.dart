import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';

class Themes {
  // Light Theme
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: brandOne,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      color: brandOne,
    ),
    canvasColor: const Color(0xFFFFFFFF),
    cardColor: brandTwo.withOpacity(0.2),
    primaryColorLight: const Color(0xFFf2eeed),
    unselectedWidgetColor: brandOne,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandOne,
      primary: Colors.white,
    ),
  );

  // Dark Theme
  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1B1C1E),
    ),
    scaffoldBackgroundColor: Color(0xff1B1C1E),
    unselectedWidgetColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandTwo,
      primary: brandOne,
    ),
    canvasColor: const Color(0xff1B1C1E),
    cardColor: const Color(0xFFFFFFFF),
    primaryColorLight: const Color(0xFF363636),
  );
}
