import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneappcounter/common/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/textfield/custom_text_field.dart';
import 'package:oneappcounter/presentation/auth/login/loginpage.dart';

class BranchDomainPage extends StatelessWidget {
  const BranchDomainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.appcolor,
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
                const SizedBox(height: 5),
                const Text(
                  "ENTER YOUR BRANCH DOMAIN",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: CustomTextField(
                      hintText: "http://branch-..",
                      labelText: "Branch Domain",
                      prefixIcon: Icons.link,
                    )),
                CustomElevatedButton(
                    text: "CONNECT",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Loginpage()));
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
}
