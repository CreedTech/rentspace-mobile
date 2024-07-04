import 'package:flutter/material.dart';

import '../constants/colors.dart';


// ignore: non_constant_identifier_names
ThemeData LightThemeData() {
  return ThemeData(
    primaryColor: brandOne,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF6F6F8),
      surfaceTintColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: const Color(0xffF6F6F8),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: const IconThemeData(
      color: brandOne,
    ),
    canvasColor: colorWhite,
    brightness: Brightness.light,
    dividerColor: const Color(0xffC9C9C9),
    // cardColor: colorWhie,
    primaryColorLight: const Color(0xff4B4B4B),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: brandOne,
      selectionHandleColor: brandOne,
    ),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandOne,
      primary: colorBlack,
      brightness: Brightness.light,
      background: brandOne,
    ),
  );
}
