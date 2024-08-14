import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/textfield/custom_text_field.dart';
import 'package:oneappcounter/common/widgets/bottomSheet/bottomsheet.dart';
import 'package:oneappcounter/routes.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.appBackgrondcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      backgroundColor: Appcolors.appBackgrondcolor,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/images/logoWhite.svg",
                    height: 50,
                    width: 50,
                  ),
                ),
                const Text(
                  " ",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: CustomTextField(
                        labelText: "Email",
                        hintText: "username@domain.com",
                        prefixIcon: Icons.mail)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: CustomTextField(
                      labelText: "Password",
                      hintText: "P@ssWorD",
                      obscureText: true,
                      prefixIcon: Icons.lock),
                ),
                CustomElevatedButton(
                    backgroundColor: Appcolors.buttonColor,
                    text: "LOGIN",
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.bottomNavBar);
                    }),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Powered by ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'one',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: 'app All Rights Reserved',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Version 1.1.3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const BottomSheetContent(),
    );
  }
}
