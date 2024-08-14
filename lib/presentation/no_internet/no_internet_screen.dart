import 'package:flutter/material.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/utility_services.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Appcolors.appBackgrondcolor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const OneAppLogo(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.cloud_off_outlined,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const Text(
                    "Can't connect to Server",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.1),
                    child: Text(
                      "Check your Internet Connection",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Check your device Date and Time",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  CustomElevatedButton(
                    text: 'Retry',
                    onPressed: () => _retryConnection(context),
                  ),
                ],
              ),
            ),
          ),
          // AppVersionCopyRight,
        ],
      ),
    );
  }

  Future<void> _retryConnection(BuildContext context) async {
    UtilityService.showLoadingAlert(context);

    bool isConnected = await NetworkingService.checkInternetConnection();

    if (isConnected) {
      Navigator.pushNamedAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        AppRoutes.splashScreen,
        (route) => false,
      );
    } else {
      UtilityService.toast(
        // ignore: use_build_context_synchronously
        context,
        'Not able to connect',
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
