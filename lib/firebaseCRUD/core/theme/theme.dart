import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      tertiary: Colors.grey.shade200,
      primary: Colors.black,
      secondary: Colors.white,
      // Below is a gradient
      inversePrimary: Color(0xfffdfbfb),
      surface: Colors.white,
      onPrimary: Colors.grey.shade300,
      inverseSurface: Colors.grey.shade500,
      onInverseSurface: Colors.grey.shade900

      //     Theme.of(context).colorScheme.surface,
      // Theme.of(context).colorScheme.onPrimary,
      // Theme.of(context).colorScheme.inverseSurface,
      ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.black,
      tertiary: Colors.black,
      // Below is a gradient
      inversePrimary: Colors.black54,
      surface: Colors.black12,
      onPrimary: Colors.grey.shade300,
      inverseSurface: Colors.grey.shade500,
      onInverseSurface: Colors.grey.shade900),
);
