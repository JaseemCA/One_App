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

    try {
      if (kIsWeb) {
        // deviceData =
        //     _readWebBrowserInfo(await DeviceInfoPlugin().webBrowserInfo);
        // _deviceInfo = const DeviceInfo(
        //   deviceOs: 'Web Browser',
        //   deviceName: 'unknown',
        //   hardWareArch: 'hardWareArch',
        //   platform: 'platform',
        //   uniqueID: 'uniqueID',
        //   brand: 'brand',
        //   buildId: 'buildId',
        //   isPhysicalDevice: false,
        //   deviceSpecs: 'deviceSpecs',
        //   manufacturer: 'manufacturer',
        //   deviceType: 'deviceType',
        //   macAddress: 'macAddress',
        // );
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await DeviceInfoPlugin().androidInfo);

          List systemfeatures = deviceData['systemFeatures'];

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
            // ignore: prefer_interpolation_to_compose_strings
            osDistro: 'Android ' + deviceData['version.release'],
            osRelease: deviceData['version.release'],
            osArch: deviceData['hardware'],
            osHostname: '${deviceData['brand']} ${deviceData['model']}',
            osBuild: deviceData['supportedAbis'].join(', '),
            osSerial: deviceData['androidId'],
            uuidOs: deviceData['androidId'],
            cpuManufacturer: deviceData['manufacturer'],
            cpuBrand: deviceData['board'],
            cpuCores: Platform.numberOfProcessors.toString(),
            cpuVendor: deviceData['manufacturer'],
          );
        } else {
          // deviceInfo = const DeviceInfo(
          //   deviceOs: 'Unsupported os device/ios/windows/Linux',
          //   deviceName: 'unknown',
          //   hardWareArch: 'hardWareArch',
          //   platform: 'platform',
          //   uniqueID: 'uniqueID',
          //   brand: 'brand',
          //   buildId: 'buildId',
          //   isPhysicalDevice: false,
          //   deviceSpecs: 'deviceSpecs',
          //   manufacturer: 'manufacturer',
          //   deviceType: 'deviceType',
          //   macAddress: null,
          // );
        }
    
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
      // _deviceInfo = const DeviceInfo(
      //   deviceOs: 'Error',
      //   deviceName: 'unknown',
      //   hardWareArch: 'hardWareArch',
      //   platform: 'platform',
      //   uniqueID: 'uniqueID',
      //   brand: 'brand',
      //   buildId: 'buildId',
      //   isPhysicalDevice: false,
      //   deviceSpecs: 'deviceSpecs',
      //   manufacturer: 'manufacturer',
      //   deviceType: 'deviceType',
      //   macAddress: null,
      // );
    }

    return _formatServerSpecificData(deviceInfo);
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    deviceName = build.model;
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      // 'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      // 'version.previewSdkInt': build.version.previewSdkInt,
      // 'version.incremental': build.version.incremental,
      // 'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      // 'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      // 'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      // 'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      // 'tags': build.tags,
      // 'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      // 'androidId': build.androidId, //reset when factory reset.
      'systemFeatures':
          build.systemFeatures, //there is  posiblity for changes if mod changes
    };
  }

  // Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  //   return <String, dynamic>{
  //     // 'name': data.name,
  //     // 'systemName': data.systemName,
  //     // 'systemVersion': data.systemVersion,
  //     'model': data.model,
  //     'localizedModel': data.localizedModel,
  //     'identifierForVendor': data.identifierForVendor,
  //     'isPhysicalDevice': data.isPhysicalDevice,
  //     // 'utsname.sysname:': data.utsname.sysname,
  //     // 'utsname.nodename:': data.utsname.nodename,
  //     // 'utsname.release:': data.utsname.release,
  //     // 'utsname.version:': data.utsname.version,
  //     'utsname.machine:': data.utsname.machine,
  //   };
  // }

  // Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     // 'version': data.version,
  //     'id': data.id,
  //     'idLike': data.idLike,
  //     'versionCodename': data.versionCodename,
  //     // 'versionId': data.versionId,
  //     // 'prettyName': data.prettyName,
  //     // 'buildId': data.buildId,
  //     'variant': data.variant,
  //     'variantId': data.variantId,
  //     'machineId': data.machineId,
  //   };
  // }

  // Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  //   return <String, dynamic>{
  //     'browserName': describeEnum(data.browserName),
  //     // 'appCodeName': data.appCodeName,
  //     // 'appName': data.appName,
  //     // 'appVersion': data.appVersion,
  //     'deviceMemory': data.deviceMemory,
  //     // 'language': data.language,
  //     // 'languages': data.languages,
  //     // 'platform': data.platform,
  //     // 'product': data.product,
  //     // 'productSub': data.productSub,
  //     // 'userAgent': data.userAgent,
  //     'vendor': data.vendor,
  //     // 'vendorSub': data.vendorSub,
  //     'hardwareConcurrency': data.hardwareConcurrency,
  //     'maxTouchPoints': data.maxTouchPoints,
  //   };
  // }

  // Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  //   return <String, dynamic>{
  //     // 'computerName': data.computerName,
  //     'hostName': data.hostName,
  //     'arch': data.arch,
  //     'model': data.model,
  //     'kernelVersion': data.kernelVersion,
  //     // 'osRelease': data.osRelease,
  //     'activeCPUs': data.activeCPUs,
  //     'memorySize': data.memorySize,
  //     'cpuFrequency': data.cpuFrequency,
  //     'systemGUID': data.systemGUID,
  //   };
  // }

  // Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  //   return <String, dynamic>{
  //     'numberOfCores': data.numberOfCores,
  //     'computerName': data.computerName,
  //     'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
  //   };
  // }

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
        'kernal': data?.osKernal,
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
