import 'package:flutter/material.dart';

import '../constants/colors.dart';

// import 'element/text_theme.dart';

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
    dividerColor: Color(0xffC9C9C9),
    // cardColor: colorWhite,
    primaryColorLight: Color(0xff4B4B4B),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: brandOne, // Color of the selection highlight
      // cursorColor: brandOne, // Color of the text cursor
      selectionHandleColor: brandOne,
    ),
    // unselectedWidgetColor: brandOne,

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandOne,
      primary: colorBlack,
      brightness: Brightness.light,
      background: brandOne,
    ),
  );
}
