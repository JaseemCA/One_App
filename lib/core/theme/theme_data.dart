// import 'package:flutter/material.dart';

// const Color kBackgroundColor = Color(0xffEE413E);
// const Color kCardColor = Color(0x00ffffff);
// const Color kButtonColor = Color(0xff171f4c);
// const Color kButtonSelectedColor = Color(0xff575d7d);
// const Color kTextInputFiledLabelColor = Color(0xffFFFFFF);
// const Color kLoadingColor = Color(0xff3142a1);
// const Color kCardDetailTextColor = Color(0xffFFFFFF);
// const Color kActiveFieldColor = Colors.white;
// const Color kInActiveFieldColor = Colors.white70;
// const Color kCopyRightTextColor = Colors.white;
// const Color klowPriorityDark = Color(0xffcf6679);
// const Color klowPriorityLight = Color(0xffb00020);
// const Color kwarningDark = Color(0xffd89614);
// const Color kwarningLight = Color(0xfffaad14);

// const Color khighPriorityDark = Color(0xff64fedc);
// const Color kmaterialIconButtonDark = Color(0xff52a18e);

// ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
//   foregroundColor: Colors.white,
//   backgroundColor: kButtonColor,
//   minimumSize: const Size(10, 45),
// );
// ButtonStyle kInverseElevatedButtonStyle = ElevatedButton.styleFrom(
//   foregroundColor: kButtonColor,
//   backgroundColor: const Color.fromARGB(255, 3, 24, 63),
//   elevation: 10,
//   minimumSize: const Size(10, 45),
// );

// ThemeData kDarkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primarySwatch: _createMaterialColor(const Color(0xff52a18e)),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     elevation: 10,
//     selectedItemColor: Colors.white,
//     unselectedItemColor: Colors.white54,
//   ),
//   bottomSheetTheme:
//       const BottomSheetThemeData(backgroundColor: Colors.transparent),
// );

// ThemeData kLightTheme = ThemeData(
//   brightness: Brightness.light,
//   primarySwatch: _createMaterialColor(kButtonColor),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: kBackgroundColor,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: kElevatedButtonStyle,
//   ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     elevation: 10,
//     selectedItemColor: Colors.black,
//     unselectedItemColor: Colors.black45,
//   ),
//   bottomSheetTheme:
//       const BottomSheetThemeData(backgroundColor: Colors.transparent),
// );

// MaterialColor _createMaterialColor(Color color) {
//   List strengths = <double>[.05];
//   Map<int, Color> swatch = {};
//   final int r = color.red, g = color.green, b = color.blue;

//   for (int i = 1; i < 10; i++) {
//     strengths.add(0.1 * i);
//   }
//   for (var strength in strengths) {
//     final double ds = 0.5 - strength;
//     swatch[(strength * 1000).round()] = Color.fromRGBO(
//       r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//       g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//       b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//       1,
//     );
//   }
//   return MaterialColor(color.value, swatch);
// }
