// import 'package:flutter/material.dart';
// import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
// import 'package:oneappcounter/services/networking_service.dart';
// import 'package:shimmer/shimmer.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override

//   // ignore: library_private_types_in_public_api
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     // Check internet connection
//     bool isConnected = await NetworkingService.checkInternetConnection();
//     if (!isConnected) {
//       // Handle no internet connection (e.g., show an error message or retry)
//       // For simplicity, let's just print an error message here
//       // print('No internet connection');
//       return;
//     }

//     // Initialize saved values
//     bool isInitialized = await NetworkingService.setSavedValues();
//     if (!isInitialized) {
//       // Handle initialization failure (e.g., use default values or show an error message)
//       // print('Failed to initialize saved values');
//       return;
//     }

//     // Optionally check subscription status
//     bool isSubscribed = await NetworkingService.checkSubscription();
//     if (!isSubscribed) {
//       // Handle no subscription (e.g., redirect to a subscription page)
//       // print('No valid subscription');
//     }

//     // Navigate to the next screen (e.g., HomeScreen)
//     // Replace `HomeScreen` with your actual next screen
//     // Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Appcolors.appBackgrondcolor,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Shimmer.fromColors(
//               baseColor: Colors.white,
//               highlightColor: const Color(0xff121212).withOpacity(.2),
//               child: const OneAppLogo(height: 50),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'Counter',
//                 style: TextStyle(
//                   fontSize: 30,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/storage_service.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final networkingCubit = context.read<NetworkingCubit>();

    bool isConnected =
        await NetworkingService(networkingCubit).checkInternetConnection();
    if (!isConnected) {
      // Ensure the context is still valid before navigating
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.noInternetScreen.route,
          (route) => false,
        );
      }
      return;
    }

    bool isInitialized = await networkingCubit.setSavedValues();
    if (!isInitialized) {
      // Optionally handle initialization failure
      // e.g., show an error dialog or fallback
      return;
    }

    bool isSubscribed =
        await NetworkingService(networkingCubit).checkSubscription();
    if (!isSubscribed) {
      // Optionally handle subscription status
      // e.g., redirect to a subscription page
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.domainScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NetworkingCubit(),
      child: Scaffold(
        backgroundColor: Appcolors.appBackgrondcolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
