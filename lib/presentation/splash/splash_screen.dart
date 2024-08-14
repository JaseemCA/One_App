import 'package:flutter/material.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/model/splash_init_response.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/splash_services.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeApp());
  }

  Future<void> _initializeApp() async {
    // Get the shortest screen size
    int shortestScreenSize = MediaQuery.of(context).size.shortestSide.toInt();

    // Initialize the data using SplashScreenService
    SplashInitResponse response =
        await SplashScreenService.initData(shortestScreenSize);

    // Handle the navigation based on the response
    if (mounted) {
      _navigateBasedOnResponse(response);
    }
  }

  void _navigateBasedOnResponse(SplashInitResponse response) {
    switch (response.decideLocation) {
      case 'domain':
        {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.domainScreen,
            (route) => false,
          );
        }
        break;
      case 'login':
        {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.loginScreen,
            (route) => false,
          );
        }
        break;
      case 'home':
        {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.bottomNavBar,
            (route) => false,
          );
        }
        break;
      case 'no-internet':
        {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.noInternetScreen,
            (route) => false,
          );
        }
        break;
      default:
        {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.noInternetScreen,
            (route) => false,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.appBackgrondcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: const Color(0xff121212).withOpacity(.2),
              child: const OneAppLogo(height: 50),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Counter',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
