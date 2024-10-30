// import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:oneappcounter/model/device_info_model.dart';
import 'package:oneappcounter/services/splash_services.dart';

class DeviceInfoService {
  static DeviceInfo? deviceInfo;
  static String deviceName = '';

  static Future<dynamic> getDeviceInfo() async {
    var deviceData = <String, dynamic>{};
    // log('Starting to get device info...');

    try {
      if (kIsWeb) {
        // log('Running on the Web - Currently, web platform is not supported for detailed device info');
        return <String, dynamic>{
          // 'error': 'Web platform not supported for this service'
        };
      } else {
        if (Platform.isAndroid) {
          // log('Running on Android');
          deviceData =
              _readAndroidBuildData(await DeviceInfoPlugin().androidInfo);
          // log('Android device data retrieved: $deviceData');

          List systemfeatures = deviceData['systemFeatures'];
          // log('System features: $systemfeatures');

          // deviceInfo = DeviceInfo(
          //   systemManufacturer: deviceData['brand'],
          //   systemModel: deviceData['model'],
          //   systemSerial: deviceData['device'],
          //   systemUuid: deviceData['product'],
          //   biosVendor: deviceData['manufacturer'],
          //   biosVersion: deviceData['id'],
          //   baseboardManufacturer: deviceData['manufacturer'],
          //   baseboardModel: deviceData['board'],
          //   chassisManufacturer: deviceData['manufacturer'],
          //   chassisModel: deviceData['model'],
          //   chassisType:
          //       systemfeatures.contains('android.software.leanback_only')
          //           ? 'TV'
          //           : SplashScreenService.shortestScreenSize < 550
          //               ? 'Mobile'
          //               : 'Tablet', // Or 'Tablet', 'TV' based on the logic
          //   osPlatform: Platform.operatingSystem,
          //   osDistro:
          //       'Android ${deviceData['version.release']}', // Assume a dummy Android version
          //   osRelease: deviceData['version.release'],
          //   osArch: deviceData['hardware'], // Dummy architecture
          //   osHostname: '${deviceData['brand']} ${deviceData['model']}',
          //   osBuild: deviceData['supportedAbis'].join(', '),
          //   osSerial: deviceData['androidId'],
          //   uuidOs: 'DummyAndroidId',
          //   cpuManufacturer: deviceData['manufacturer'],
          //   cpuBrand: deviceData['board'],
          //   cpuCores: Platform.numberOfProcessors.toString(),
          //   cpuVendor: deviceData['manufacturer'],
          // );

          deviceInfo = DeviceInfo(
            systemManufacturer: deviceData['brand'],
            systemModel: deviceData['model'],
            systemSerial: deviceData['device'],
            systemUuid: deviceData['product'],
            biosVendor: deviceData['manufacturer'],
            biosVersion: deviceData['id'],
            baseboardManufacturer: deviceData['manufacturer'],
            baseboardModel: deviceData['board'],
            chassisManufacturer: deviceData['manufacturer'],
            chassisModel: deviceData['model'],
            chassisType:
                systemfeatures.contains('android.software.leanback_only')
                    ? 'TV'
                    : SplashScreenService.shortestScreenSize < 550
                        ? 'Mobile'
                        : 'Tablet',
            osPlatform: Platform.operatingSystem,
            osDistro: 'Android ${deviceData['version.release']}',
            osRelease: deviceData['version.release'],
            osArch: deviceData['hardware'],
            osHostname: '${deviceData['brand']} ${deviceData['model']}',
            osBuild: deviceData['supportedAbis'].join(','),
            osSerial: "dummy", //error
            uuidOs: "dummy", //error
            cpuManufacturer: deviceData['manufacturer'],
            cpuBrand: deviceData['board'],
            cpuCores: Platform.numberOfProcessors.toString(),
            cpuVendor: deviceData['manufacturer'],
          );
          // log('Device Info: $deviceInfo');
        } else {
          // log('Not an Android device, or unsupported platform');
        }
      }
    } on PlatformException catch (e) {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version. Error: ${e.message}'
      };
      // log('Error retrieving device info: ${e.message}');
      return deviceData;
    }

    // log('Formatted device info: ${_formatServerSpecificData(deviceInfo)}');
    return _formatServerSpecificData(deviceInfo);
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    deviceName = build.model;
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.release': build.version.release,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'brand': build.brand,
      'device': build.device,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'isPhysicalDevice': build.isPhysicalDevice,
      // 'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  static Map<String, dynamic> _formatServerSpecificData(DeviceInfo? data) {
    return <String, dynamic>{
      'system': {
        'manufacturer': data?.systemManufacturer,
        'model': data?.systemModel,
        'serial': data?.systemSerial,
        'uuid': data?.systemUuid,
      },
      'bios': {
        'vendor': data?.biosVendor,
        'version': data?.biosVersion,
        'release_date': data?.biosReleaseDate,
      },
      'baseboard': {
        'manufacturer': data?.baseboardManufacturer,
        'model': data?.baseboardModel,
        'serial': data?.baseboardSerial,
      },
      'chassis': {
        'manufacturer': data?.chassisManufacturer,
        'model': data?.chassisModel,
        'type': data?.chassisType,
        'serial': data?.chassisSerial,
      },
      'os': {
        'platform': data?.osPlatform,
        'distro': data?.osDistro,
        'release': data?.osRelease,
        'arch': data?.osArch,
        'hostname': data?.osHostname,
        'build': data?.osBuild,
        'kernel': data?.osKernal,
        'serial': data?.osSerial,
      },
      'uuid': {
        'os': data?.uuidOs,
      },
      'cpu': {
        'manufacturer': data?.cpuManufacturer,
        'brand': data?.cpuBrand,
        'speed': data?.cpuSpeed,
        'cores': data?.cpuCores,
        'physical_cores': data?.cpuPhysicalCores,
        'vendor': data?.cpuVendor,
        'socket': data?.cpuSocket,
      },
      'graphics': [],
      'networks': [],
      'memories': [],
      'disks': [],
    };
  }
}
