// import 'package:oneappcounter/model/splash_init_response.dart';
// import 'package:oneappcounter/services/auth_service.dart';
// import 'package:oneappcounter/services/clock_service.dart';
// import 'package:oneappcounter/services/counter_setting_service.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/networking_service.dart';
// import 'package:oneappcounter/services/set_device_service.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// class SplashScreenService {
//   static int shortestScreenSize = 0;
//   static String appVersion = '0.0.1';

//   static Future<SplashInitResponse> initData(int screenSize) async {
//     try {
//       PackageInfo packageInfo = await PackageInfo.fromPlatform();
//       appVersion = packageInfo.version;

//       shortestScreenSize = screenSize;
//       SplashInitResponse splashInitResponse = SplashInitResponse(
//         processed: true,
//         decideLocation: 'domain', // default value, will be overwritten
//       );

//       if (await NetworkingService.checkInternetConnection()) {
//         // Uncomment and adjust the following lines if needed:
//         if (await NetworkingService.setSavedValues()) {
//           splashInitResponse = SplashInitResponse(
//             processed: true,
//             decideLocation: 'login',
//           );
//           await AuthService.getSavedData();
//           if (AuthService.loginData != null &&
//               AuthService.loginData!.accessToken.isNotEmpty) {
//             await AuthService.updateBranchDetails();
//             await ClockService.updateDateTime();
//             await CounterSettingService.initSettingsData();
//             await GeneralDataService.initVals();
//             await GeneralDataService.initServiceAndCounterData();
//             await CounterSettingService.initSettingsData();
//             await SetDeviceService.getFromLocal();
//             await SetDeviceService.addCounterAppDetails();

//             splashInitResponse = SplashInitResponse(
//               processed: true,
//               decideLocation: 'home',
//             );
//           }
//         }
//       } else {
//         splashInitResponse = SplashInitResponse(
//           processed: false,
//           decideLocation: 'no-internet',
//         );
//       }

// ignore_for_file: use_build_context_synchronously

//       return splashInitResponse;
//     } catch (e) {
//       // Handle errors appropriately
//       return SplashInitResponse(
//         processed: false,
//         decideLocation: 'sub',
//       );
//     }
//   }
// }
import 'dart:async';
import 'dart:developer';
// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:oneappcounter/model/splash_init_response.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/clock_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/language_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/set_device_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreenService {
  static StreamController<String> splashScreenEvents =
      StreamController<String>.broadcast();
  static int shortestScreenSize = 0;
  static String appVersion = '0.0.1';

  static Future<SplashInitResponse> initData(
      BuildContext context, int screenSize) async {
    // log("Initializing Splash Screen Service...");

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    // log("App Version: $appVersion");

    shortestScreenSize = screenSize;
    SplashInitResponse spalshinitResponse = SplashInitResponse(
      processed: true,
      decideLocation: 'domain',
    );

    splashScreenEvents.add('Checking network');
    // log("Checking network connection...");
    if (await NetworkingService.checkInternetConnection()) {
      splashScreenEvents.add('Validating user');
      // log("Network connected. Validating user...");

      if (await NetworkingService.setSavedValues()) {
        spalshinitResponse = SplashInitResponse(
          processed: true,
          decideLocation: 'login',
        );

        log("Fetching saved user data...");
        await AuthService.getSavedData();
        if (AuthService.loginData != null &&
            AuthService.loginData!.accessToken.isNotEmpty) {
          splashScreenEvents.add('Fetching');
          log("User logged in. AccessToken found.");

          await AuthService.updateBranchDetails();
          splashScreenEvents.add('Validating device');
          log("Updated branch details.");

          await ClockService.updateDateTime();
          splashScreenEvents.add('Fetching');
          await CounterSettingService.initSettingsData();
          log("Counter settings initialized.");

          splashScreenEvents.add('Validating details');
          await GeneralDataService.initVals();
          splashScreenEvents.add('Fetching');
          await LanguageService.changeLocaleFn(context);
          await GeneralDataService.initServiceAndCounterData();
          await GeneralDataService.selectThisTab(
            index: GeneralDataService.currentServiceCounterTabIndex,
            thisTab: GeneralDataService.getTabs()[
                GeneralDataService.currentServiceCounterTabIndex],
          );

          splashScreenEvents.add('Updating');
          await CounterSettingService.initSettingsData();
          splashScreenEvents.add('Validating settings');
          await SetDeviceService.getFromLocal();
          splashScreenEvents.add('Setting up');
          await SetDeviceService.addCounterAppDetails();
          splashScreenEvents.add('');

          log("All services initialized. Navigating to Home.");
          spalshinitResponse = SplashInitResponse(
            processed: true,
            decideLocation: 'home',
          );
        }
      }
    } else {
      // log("No internet connection.");
      spalshinitResponse = SplashInitResponse(
        processed: false,
        decideLocation: 'no-internet',
      );
    }

    return spalshinitResponse;
  }
}
