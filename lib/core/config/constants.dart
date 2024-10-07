// import 'package:flutter/material.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// // import 'package:flutter_translate/flutter_translate.dart';
// import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
// import 'package:oneappcounter/services/auth_service.dart';
// import 'package:oneappcounter/services/splash_services.dart';

// /// certificate value
// ///
// // ignore: constant_identifier_names

// const String kISRG_X1 = """-----BEGIN CERTIFICATE-----
// MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
// TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
// cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
// WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
// ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
// MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
// h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
// 0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
// A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
// T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
// B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
// B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
// KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
// OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
// jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
// qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
// rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
// HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
// hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
// ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
// 3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
// NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
// ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
// TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
// jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
// oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
// 4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
// mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
// emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
// -----END CERTIFICATE-----""";
// //constant values
// const String kExampleBranchDomainUrl = 'https://branch-domain.oneapp.life';

// const String kNoPhoneStr = "k3JvgCljqW";

// //color constants
//    const Color appBackgrondcolor = Color(0xffEE413E);
//    const Color cardColor = Color(0x00ffffff);
//    const Color buttonColor = Color(0xff171f4c);
//    const Color buttonSelectedColor = Color(0xff575d7d);
//    const Color textInputFiledLabelColor = Color(0xffFFFFFF);
//    const Color loadingColor = Color(0xff3142a1);
//    const Color cardDetailTextColor = Color(0xffFFFFFF);
//    const Color activeFieldColor = Colors.white;
//    const Color inActiveFieldColor = Colors.white70;
//    const Color bottomsheetDarkcolor = Color.fromARGB(179, 103, 102, 102);
//    const Color copyRightTextColor = Colors.white;
//    const Color lowPriorityDark = Color(0xffcf6679);
//    const Color lowPriorityLight = Color(0xffb00020);
//    const Color warningDark = Color(0xffd89614);
//    const Color warningLight = Color(0xfffaad14);
//    const Color highPriorityDark = Color(0xff64fedc);
//    const Color materialIconButtonDark = Color(0xff52a18e);

// // const Color khighPriorityDark = Color(0xff64fedc);
// // const Color kmaterialIconButtonDark = Color(0xff52a18e);

// //  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

// ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
//   foregroundColor: Colors.white,
//   backgroundColor: buttonColor,
//   minimumSize: const Size(10, 45),
// );

// // ButtonStyle ElevatedButtonStyle = ElevatedButton.styleFrom(
// //   foregroundColor: Colors.white, // Keep this for light theme
// //   backgroundColor: Theme.of(context).brightness == Brightness.dark
// //       ? Theme.of(context).colorScheme.primary // Use theme's primary color for dark theme
// //       : kButtonColor, // Use your custom color for light theme
// //   minimumSize: const Size(10, 45),
// // );

// ButtonStyle kInverseElevatedButtonStyle = ElevatedButton.styleFrom(
//   foregroundColor: buttonColor,
//   backgroundColor: const Color.fromARGB(255, 3, 24, 63),
//   elevation: 10,
//   minimumSize: const Size(10, 45),
// );

// ListView kListViewNoDataFound() {
//   return ListView(
//     physics: const AlwaysScrollableScrollPhysics(),
//     children: [
//       Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 15.0),
//           child: Text(
//             translate('No Data!'),
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//         ),
//       )
//     ],
//   );
// }

// ///theme data
// ///dark theme
// ThemeData kdarkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primarySwatch: _createMaterialColor(const Color(0xff52a18e)),

//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: kElevatedButtonStyle,
//   ),
//   outlinedButtonTheme: OutlinedButtonThemeData(
//     style: kInverseElevatedButtonStyle,
//   ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     elevation: 10,
//     selectedItemColor: Colors.white,
//     unselectedItemColor: Colors.white54,
//   ),
//   bottomSheetTheme:
//       const BottomSheetThemeData(backgroundColor: Colors.transparent),
// );
// ThemeData klightTheme = ThemeData(
//   brightness: Brightness.light,
//   primarySwatch: _createMaterialColor(buttonColor),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: appBackgrondcolor,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: kElevatedButtonStyle,
//   ),
//   // outlinedButtonTheme: OutlinedButtonThemeData(
//   //   style: kInverseElevatedButtonStyle,
//   // ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     elevation: 10,
//     selectedItemColor: Colors.black,
//     unselectedItemColor: Colors.black45,
//   ),
//   bottomSheetTheme:
//       const BottomSheetThemeData(backgroundColor: Colors.transparent),
// );

// // font size constants
// const TextStyle kTextFieldLabelStyle = TextStyle(
//   fontSize: 14.0,
//   color: textInputFiledLabelColor,
// );
// const TextStyle kCardDetailTextStyle = TextStyle(
//   color: cardDetailTextColor,
//   fontSize: 17,
//   fontWeight: FontWeight.w500,
// );
// Align kAppVersion = Align(
//   alignment: Alignment.bottomRight,
//   child: FittedBox(
//     child: Text(
//       'Version ${SplashScreenService.appVersion}',
//       style: const TextStyle(color: copyRightTextColor, fontSize: 11.0),
//     ),
//   ),
// );

//  Align kAppCopyRight =  const Align(
//   alignment: Alignment.bottomLeft,
//   child: Row(
//     children: [
//       FittedBox(
//         child: Text(
//           'Powered by ',
//           style: TextStyle(color: copyRightTextColor, fontSize: 11.0),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.only(
//           top: 2.0,
//         ),
//         child: OneAppIcon(),
//       ),
//       FittedBox(
//         child: Text(
//           ' All Rights Reserved',
//           style: TextStyle(color: copyRightTextColor, fontSize: 11.0),
//         ),
//       ),
//     ],
//   ),
// );
// final Row kAppVersionCopyRightRow = Row(
//   children: [
//     Expanded(
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.5),
//         height: 17.0,
//         color: appBackgrondcolor,
//         child: Stack(
//           children: [
//             kAppVersion,
//             kAppCopyRight,
//           ],
//         ),
//       ),
//     ),
//   ],
// );
// final Stack kAppVersionCopyRight = Stack(
//   children: [
//     Align(
//       alignment: Alignment.bottomCenter,
//       child: kAppVersionCopyRightRow,
//     )
//   ],
// );
// const Divider kDivider = Divider(
//   height: 8.0,
// );

// Widget kBuildTopBar(double height) {
//   /// calculted height as std is 30.828167357744714
//   /// height / 10 * 3.244 =approx 10.0
//   /// logo height: (height/10) *6.812= 21 approx
//   /// font size = 17 and  will be (height/10) * 5.5145
//   return Container(
//     height: height,
//     color: appBackgrondcolor,
//     padding: EdgeInsets.symmetric(
//         horizontal: ((height / 10) * 3.244).roundToDouble()),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Expanded(
//           child: OneAppLogo(height: ((height / 10) * 7.51).roundToDouble()),
//         ),
//         const SizedBox(
//           width: 20,
//         ),
//         FittedBox(
//           child: Text(
//             '${AuthService.branchName}',
//             textAlign: TextAlign.end,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: ((height / 10) * 5.1145).roundToDouble(),
//               height: 1,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget getCopyRight(double rowHeight) {
//   /// height taken as std is 16.766196282282213
//   /// all height and font size repective percent of item
//   /// divide by 10 and multple by value
//   /// font size =11 ie:65.555
//   /// padding top:.11929
//   /// padding left :0.417515=7 as normal
//   /// padding bottom :0.089466= 1.5 as normal
//   /// logo height = 9 as default will (rowHeight/10)*5.368
//   /// padding top of version enrapped contaainer is 0.2088
//   Widget kAppCopyRight = Row(
//     children: [
//       Text(
//         'Powered by ',
//         style: TextStyle(
//           color: copyRightTextColor,
//           fontSize: (rowHeight * .56).roundToDouble(),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.only(
//           top: (rowHeight * .15).roundToDouble(),
//         ),
//         child: OneAppIcon(height: ((rowHeight / 10) * 5.368).roundToDouble()),
//       ),
//       Text(
//         ' All Rights Reserved',
//         style: TextStyle(
//           color: copyRightTextColor,
//           fontSize: (rowHeight * .56).roundToDouble(),
//         ),
//       ),
//     ],
//   );

//   Widget kAppVersion = Text(
//     'Version ${SplashScreenService.appVersion}',
//     style: TextStyle(
//       color: copyRightTextColor,
//       fontSize: (rowHeight * .56).roundToDouble(),
//     ),
//   );

//   return Container(
//     padding: EdgeInsets.fromLTRB(
//       (rowHeight * .417515).roundToDouble(),
//       0.0,
//       (rowHeight * .417515).roundToDouble(),
//       (rowHeight * .089466).roundToDouble(),
//     ),
//     height: rowHeight,
//     color: appBackgrondcolor,
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Expanded(
//           child: kAppCopyRight,
//         ),
//         const SizedBox(width: 10),
//         kAppVersion
//       ],
//     ),
//   );
// }

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

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/splash_services.dart';

/// certificate value
///
// ignore: constant_identifier_names
const String kISRG_X1 = """-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----""";

const String kExampleBranchDomainUrl = 'https://branch-domain.oneapp.life';

const String kNoPhoneStr = "k3JvgCljqW";


const Color appBackgrondcolor = Color(0xffEE413E);
const Color cardColor = Color(0x00ffffff);
const Color buttonColor = Color(0xff171f4c);
const Color buttonSelectedColor = Color(0xff575d7d);
const Color textInputFiledLabelColor = Color(0xffFFFFFF);
const Color loadingColor = Color(0xff3142a1);
const Color cardDetailTextColor = Color(0xffFFFFFF);
const Color activeFieldColor = Colors.white;
const Color inActiveFieldColor = Colors.white70;
const Color bottomsheetDarkcolor = Color.fromARGB(179, 103, 102, 102);
const Color copyRightTextColor = Colors.white;
const Color lowPriorityDark = Color(0xffcf6679);
const Color lowPriorityLight = Color(0xffb00020);
const Color warningDark = Color(0xffd89614);
const Color warningLight = Color(0xfffaad14);
const Color highPriorityDark = Color(0xff64fedc);
const Color materialIconButtonDark = Color(0xff52a18e);


ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: buttonColor,
  foregroundColor: Colors.white,
  minimumSize: const Size(10, 45),
);
ButtonStyle kInverseElevatedButtonStyle = ElevatedButton.styleFrom(
  elevation: 10,
  foregroundColor: buttonColor,
  backgroundColor: const Color.fromARGB(255, 3, 24, 63),
  minimumSize: const Size(10, 45),
);

ListView kListViewNoDataFound() {
  return ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            translate('No Data!'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      )
    ],
  );
}

///theme data
///dark theme
ThemeData kdarkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: _createMaterialColor(const Color(0xff52a18e)),

  ///
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: kElevatedButtonStyle,
  // ),
  // outlinedButtonTheme: OutlinedButtonThemeData(
  //   style: kInverseElevatedButtonStyle,
  // ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 10,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white54,
  ),
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: Colors.transparent),
);
ThemeData klightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: _createMaterialColor(buttonColor),
  appBarTheme: const AppBarTheme(
    backgroundColor: appBackgrondcolor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: kElevatedButtonStyle,
  ),
  // outlinedButtonTheme: OutlinedButtonThemeData(
  //   style: kInverseElevatedButtonStyle,
  // ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 10,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black45,
  ),
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: Colors.transparent),
);

// font size constants
const TextStyle kTextFieldLabelStyle = TextStyle(
  fontSize: 14.0,
  color: textInputFiledLabelColor,
);
const TextStyle kCardDetailTextStyle = TextStyle(
  color: cardDetailTextColor,
  fontSize: 17,
  fontWeight: FontWeight.w500,
);
Align kAppVersion = Align(
  alignment: Alignment.bottomRight,
  child: FittedBox(
    child: Text(
      'Version ${SplashScreenService.appVersion}',
      style: const TextStyle(color: copyRightTextColor, fontSize: 11.0),
    ),
  ),
);

const Align kAppCopyRight = Align(
  alignment: Alignment.bottomLeft,
  child: Row(
    children: [
      FittedBox(
        child: Text(
          'Powered by ',
          style: TextStyle(color: copyRightTextColor, fontSize: 11.0),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 2.0,
        ),
        child: OneAppIcon(),
      ),
      FittedBox(
        child: Text(
          ' All Rights Reserved',
          style: TextStyle(color: copyRightTextColor, fontSize: 11.0),
        ),
      ),
    ],
  ),
);
final Row kAppVersionCopyRightRow = Row(
  children: [
    Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.5),
        height: 17.0,
        color: appBackgrondcolor,
        child: Stack(
          children: [
            kAppVersion,
            kAppCopyRight,
          ],
        ),
      ),
    ),
  ],
);
final Stack kAppVersionCopyRight = Stack(
  children: [
    Align(
      alignment: Alignment.bottomCenter,
      child: kAppVersionCopyRightRow,
    )
  ],
);
const Divider kDivider = Divider(
  height: 8.0,
);

Widget kBuildTopBar(double height) {
  /// calculted height as std is 30.828167357744714
  /// height / 10 * 3.244 =approx 10.0
  /// logo height: (height/10) *6.812= 21 approx
  /// font size = 17 and  will be (height/10) * 5.5145
  return Container(
    height: height,
    color: appBackgrondcolor,
    padding: EdgeInsets.symmetric(
        horizontal: ((height / 10) * 3.244).roundToDouble()),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: OneAppLogo(height: ((height / 10) * 7.51).roundToDouble()),
        ),
        const SizedBox(
          width: 20,
        ),
        FittedBox(
          child: Text(
            '${AuthService.branchName}',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontSize: ((height / 10) * 5.1145).roundToDouble(),
              height: 1,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget getCopyRight(double rowHeight) {
  /// height taken as std is 16.766196282282213
  /// all height and font size repective percent of item
  /// divide by 10 and multple by value
  /// font size =11 ie:65.555
  /// padding top:.11929
  /// padding left :0.417515=7 as normal
  /// padding bottom :0.089466= 1.5 as normal
  /// logo height = 9 as default will (rowHeight/10)*5.368
  /// padding top of version enrapped contaainer is 0.2088
  Widget kAppCopyRight = Row(
    children: [
      Text(
        'Powered by ',
        style: TextStyle(
          color: copyRightTextColor,
          fontSize: (rowHeight * .56).roundToDouble(),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: (rowHeight * .15).roundToDouble(),
        ),
        child: OneAppIcon(height: ((rowHeight / 10) * 5.368).roundToDouble()),
      ),
      Text(
        ' All Rights Reserved',
        style: TextStyle(
          color: copyRightTextColor,
          fontSize: (rowHeight * .56).roundToDouble(),
        ),
      ),
    ],
  );

  Widget kAppVersion = Text(
    'Version ${SplashScreenService.appVersion}',
    style: TextStyle(
      color: copyRightTextColor,
      fontSize: (rowHeight * .56).roundToDouble(),
    ),
  );

  return Container(
    padding: EdgeInsets.fromLTRB(
      (rowHeight * .417515).roundToDouble(),
      0.0,
      (rowHeight * .417515).roundToDouble(),
      (rowHeight * .089466).roundToDouble(),
    ),
    height: rowHeight,
    color: appBackgrondcolor,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: kAppCopyRight,
        ),
        const SizedBox(width: 10),
        kAppVersion
      ],
    ),
  );
}

MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
