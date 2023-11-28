import 'package:rentspace/constants/colors.dart';
import 'package:flutter/material.dart';

class Themes {
  //Light Theme params
  final lightTheme = ThemeData().copyWith(
    primaryColor: Colors.black,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    canvasColor: Color(0xFFFFFFFF),
    cardColor: Color(0xFFF5F5F5),
    primaryColorLight: Color(0xFFf2eeed),
    unselectedWidgetColor: Colors.black,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.black,
      primary: Colors.white,
    ),
  );
  //Dark Theme params
  final darkTheme = ThemeData().copyWith(
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    unselectedWidgetColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandOne,
      primary: brandOne,
    ),
    canvasColor: Color(0xFF00283C),
    cardColor: Color(0xFF363636),
    primaryColorLight: Color(0xFF363636),
  );
}
