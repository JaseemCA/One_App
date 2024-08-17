// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/textfield/custom_text_field.dart';
import 'package:oneappcounter/common/widgets/bottomSheet/bottomsheet.dart';
import 'package:oneappcounter/model/user_credential.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/utility_services.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.appBackgrondcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.domainScreen);
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
                const Align(alignment: Alignment.center, child: OneAppLogo()),
                const SizedBox(height: 10),
                Text(
                  NetworkingService.domainUrl ?? '',
                  style: const TextStyle(
                    color: Appcolors.activeFieldColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: CustomTextField(
                        labelText: "Email",
                        controller: _emailTextController,
                        hintText: "username@domain.com",
                        prefixIcon: Icons.mail)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: CustomTextField(
                      labelText: "Password",
                      controller: _passwordTextController,
                      hintText: "P@ssWorD",
                      obscureText: true,
                      onFieldSubmitted: (_) => loginUser(),
                      prefixIcon: Icons.lock),
                ),
                CustomElevatedButton(
                    backgroundColor: Appcolors.buttonColor,
                    text: "LOGIN",
                    onPressed: () {
                      loginUser();
                    })
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

  loginUser() async {
    UtilityService.showLoadingAlert(context);
    String email = (_emailTextController.text).trim();
    String password = (_passwordTextController.text).trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      bool loginSuccess = await AuthService.loginToDomain(
        userdata: UserCredential(email: email, password: password),
      );

      if (!mounted) return;

      Navigator.pop(context);

      if (loginSuccess) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.bottomNavBar,
          (route) => false,
        );
      } else {
        UtilityService.toast(context, "Can't authenticate user");
        // print("eroor occuerd");
      }
    } else {
      Navigator.pop(context);
      UtilityService.toast(context, 'All fields are required');
    }
  }
}
