
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OneAppLogo extends StatelessWidget {
  const OneAppLogo({
    super.key,
    this.height = 38.0,
  });

  final double height;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logoWhite.svg',
      height: height,
      alignment: Alignment.centerLeft,
    );
  }
}

class OneAppIcon extends StatelessWidget {
  const OneAppIcon({super.key, this.height = 9.0});
 
  // ignore: prefer_typing_uninitialized_variables
  final height;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo_white.svg',
      height: height,
    );
  }
}
