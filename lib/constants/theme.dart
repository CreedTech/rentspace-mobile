import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';

class Themes {
  // Light Theme
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: brandOne,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF6F6F8),
      surfaceTintColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: const Color(0xffF6F6F8),
    iconTheme: const IconThemeData(
      color: brandOne,
    ),
    canvasColor: const Color(0xffF6F6F8),
    cardColor: Color(0xffF6F6F8),
    primaryColorLight: brandOne,
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color(0xffF6F6F8), // Color of the selection highlight
      // cursorColor: brandOne, // Color of the text cursor
      selectionHandleColor: brandOne,
    ),
    // unselectedWidgetColor: brandOne,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandOne,
      primary: Colors.white,
      background: Colors.white,
    ),
  );

  // Dark Theme
  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1B1C1E),
    ),
    scaffoldBackgroundColor: const Color(0xff1B1C1E),
    unselectedWidgetColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: brandTwo,
      primary: brandOne,
      background: brandTwo,
    ),
    canvasColor: const Color(0xff1B1C1E),
    cardColor: const Color(0xFFFFFFFF),
    primaryColorLight: const Color(0xff1B1C1E),
  );
}
