import 'package:oneappcounter/model/splash_init_response.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/clock_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreenService {
  static int shortestScreenSize = 0;
  static String appVersion = '0.0.1';

  static Future<SplashInitResponse> initData(int screenSize) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;

      shortestScreenSize = screenSize;
      SplashInitResponse splashInitResponse = SplashInitResponse(
        processed: true,
        decideLocation: 'domain', // default value, will be overwritten
      );

      if (await NetworkingService.checkInternetConnection()) {
        // Uncomment and adjust the following lines if needed:
        if (await NetworkingService.setSavedValues()) {
          splashInitResponse = SplashInitResponse(
            processed: true,
            decideLocation: 'login',
          );
          await AuthService.getSavedData();
          if (AuthService.loginData != null &&
              AuthService.loginData!.accessToken.isNotEmpty) {
            await AuthService.updateBranchDetails();
            await ClockService.updateDateTime();

            splashInitResponse = SplashInitResponse(
              processed: true,
              decideLocation: 'home',
            );
          }
        }
      } else {
        splashInitResponse = SplashInitResponse(
          processed: false,
          decideLocation: 'no-internet',
        );
      }

      return splashInitResponse;
    } catch (e) {
      // Handle errors appropriately
      return SplashInitResponse(
        processed: false,
        decideLocation: 'error',
      );
    }
  }
}
