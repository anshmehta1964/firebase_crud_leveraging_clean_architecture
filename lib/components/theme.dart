import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    tertiary: Colors.grey.shade200,
    primary: Colors.black,
    secondary: Colors.white
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black12,
    primary: Colors.white,
    secondary: Colors.black,
    tertiary: Colors.black
  )
);