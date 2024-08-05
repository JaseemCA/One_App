import 'package:flutter/material.dart';

import 'package:oneappcounter/core/config/color/appcolors.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(Appcolors.materialIconButtonDark),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 10,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
    ),
    
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: createMaterialColor(Appcolors.buttonColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: Appcolors.appBackgrondcolor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: elevatedButtonStyle,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 10,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black45,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
  );
}

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Appcolors.buttonColor,
  foregroundColor: Colors.white,
  minimumSize: const Size(10, 45),
);

MaterialColor createMaterialColor(Color color) {
  final Map<int, Color> swatch = {};
  final List<double> strengths = [for (int i = 1; i <= 10; i++) i * 0.1];
  strengths.insert(0, 0.05);

  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      color.red + ((ds < 0 ? color.red : (255 - color.red)) * ds).round(),
      color.green + ((ds < 0 ? color.green : (255 - color.green)) * ds).round(),
      color.blue + ((ds < 0 ? color.blue : (255 - color.blue)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
