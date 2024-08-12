import 'package:flutter/cupertino.dart';
import 'package:oneappcounter/common/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:oneappcounter/presentation/auth/login/brach_domain.dart';
import 'package:oneappcounter/presentation/auth/login/loginpage.dart';
import 'package:oneappcounter/presentation/no_internet/no_internet_screen.dart';
import 'package:oneappcounter/presentation/splash/splash_screen.dart';

class Routes {
  static final Route splashScreen = Route('splash_screen');
  static final Route domainScreen = Route('domain_page');
  static final Route loginScreen = Route('login_page');
  static final Route bottomNavBar = Route('bottom_navbar');
  static final Route noInternetScreen = Route('no_internet_screen');

}

class Route {
  final String route;

  Route(this.route);
}

Map<String, Widget Function(BuildContext)> routes = {
  Routes.splashScreen.route: (context) => const SplashScreen(),
  Routes.domainScreen.route: (context) => const BranchDomainPage(),
  Routes.loginScreen.route: (context) => const Loginpage(),
  Routes.bottomNavBar.route: (context) => const BottomNavbar(),
  Routes.noInternetScreen.route: (context) => const NoInternetScreen()
};
