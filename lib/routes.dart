import 'package:flutter/cupertino.dart';
import 'package:oneappcounter/common/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:oneappcounter/presentation/auth/login/brach_domain.dart';
import 'package:oneappcounter/presentation/auth/login/loginpage.dart';
import 'package:oneappcounter/presentation/no_internet/no_internet_screen.dart';
import 'package:oneappcounter/presentation/splash/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = 'splash_screen';
  static const String domainScreen = 'domain_page';
  static const String loginScreen = 'login_page';
  static const String bottomNavBar = 'bottom_navbar';
  
  static const String noInternetScreen = 'no_internet_screen';
}

Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes.splashScreen: (context) => const SplashScreen(),
  AppRoutes.domainScreen: (context) => const DomainScreen(),
  AppRoutes.loginScreen: (context) => const Loginpage(),
  AppRoutes.bottomNavBar: (context) => const BottomNavbar(),
  AppRoutes.noInternetScreen: (context) => const NoInternetScreen(),
};
