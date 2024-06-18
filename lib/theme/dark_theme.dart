import 'package:flutter/material.dart';
import '../constants/colors.dart';

// ignore: non_constant_identifier_names
ThemeData DarkThemeData() {
  return ThemeData(
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1C1C1C),
    ),
    scaffoldBackgroundColor: const Color(0xff1C1C1C),
    unselectedWidgetColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: colorWhite,
      primary: colorWhite,
      brightness: Brightness.dark,
      background: brandTwo,
    ),
    dividerColor: const Color(0xff414141),
    canvasColor: const Color(0xff282828), 
    cardColor: const Color.fromRGBO(255, 255, 255, 0.05),
    primaryColorLight: const Color(0xffD6D6D6),
  );
}
