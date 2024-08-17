import 'package:flutter/material.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';

class UtilityService {
  static bool isDarkTheme = false;

  // Show a toast message
  static void toast(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2, milliseconds: 500),
      Color? backgroundColor,
      Color? textColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.fromLTRB(7, 0, 7, 7),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
      ),
    );
  }

  // Show a loading alert
  static Future<void> showLoadingAlert(BuildContext context,
      [bool dismissible = false]) {
    return showDialog<void>(
      context: context,
      barrierDismissible: dismissible,
      // ignore: deprecated_member_use
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return dismissible;
        },
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                // color: Colors.black.withOpacity(
                //     0.7), // Added background color for better visibility
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkTheme
                            ? Appcolors.materialIconButtonDark
                            : Appcolors.loadingColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Loading...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Please wait',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Update theme information
  static void updateThemeInfo(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  }
}
