import 'package:flutter/material.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/core/config/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final double? textSize;
  final Widget? child;

  const CustomElevatedButton({
    super.key,
    this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 17,
    this.textSize,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Keep this for light theme
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? kmaterialIconButtonDark
            : buttonColor,
        textStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? textInputFiledLabelColor
              : inActiveFieldColor,
        ),
        minimumSize: const Size(10, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
        child: child ??
            Text(
              text ?? '',
              style: TextStyle(
                  fontSize: textSize ?? fontSize,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : textInputFiledLabelColor),
            ),
      ),
    );
  }
}
