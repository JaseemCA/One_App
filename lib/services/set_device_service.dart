// import 'dart:convert';
// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:oneappcounter/entity/device_entity.dart';
// import 'package:oneappcounter/model/device_model.dart';
// import 'package:oneappcounter/services/auth_service.dart';
// import 'package:oneappcounter/services/device_info_service.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/networking_service.dart';
// import 'package:oneappcounter/services/splash_services.dart';
// import 'package:oneappcounter/services/storage_service.dart';

// class SetDeviceService {
//   static DeviceModel? deviceSettingDetails;

//   static Future<bool> addCounterAppDetails() async {
//     log("start app details");
//     try {
//       String path = 'counter/counter-device-settings/create';
//       Map<String, dynamic> deviceDetails = {
//         'device_data': await DeviceInfoService.getDeviceInfo(),
//         'device_uid': deviceSettingDetails?.deviceUid,
//       };
//       log("start app details$deviceDetails");
//       Map<String, dynamic> data = {
//         ...deviceDetails,
//         'app_version': SplashScreenService.appVersion,
//         'user_id': AuthService.loginData?.user['id'],
//         'tab_settings': _generateTabSettingsMap(),
//         'username': DeviceInfoService.deviceName,
//       };

//       var response = await NetworkingService.postHttp(path: path, data: data);

//       if (response is Response &&
//           response.statusCode == 200 &&
//           response.data['data'] != null) {
//         DeviceModel deviceModelData = DeviceModel.fromEntity(
//             DeviceEntity.fromJson(response.data['data']));
//         deviceSettingDetails = deviceModelData;
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       log('Error adding counter app details: $e');
//       return false;
//     }
//   }

//   static List<dynamic> _generateTabSettingsMap() {
//     List<dynamic> val = [];
//     // ignore: no_leading_underscores_for_local_identifiers
//     for (var _item in GeneralDataService.getTabs()) {
//       Map<String, dynamic> mapOfItem = _item.counterSettings.toJsonEntity();
//       mapOfItem['name'] = '${_item.serviceString} | ${_item.counter.name}';
//       mapOfItem['services'] = _item.services.map((e) => e.id).toList();
//       mapOfItem['counter'] = _item.counter.id;
//       val.add(mapOfItem);
//     }
//     return val;
//   }

//   static Future<void> saveToLocal() async {
//     try {
//       await StorageService.saveValue(
//         key: 'device_setting_details',
//         value: json.encode(deviceSettingDetails?.toJson()),
//       );
//     } catch (e) {
//       log('Error saving to local storage: $e');
//     }
//   }

//   static Future<void> getFromLocal() async {
//     try {
//       var val =
//           await StorageService.getSavedValue(key: 'device_setting_details');
//       if (val != null) {
//         DeviceModel data = DeviceModel.fromJson(json.decode(val));
//         deviceSettingDetails = data;
//       }
//     } catch (e) {
//       log('Error retrieving from local storage: $e');
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:oneappcounter/entity/device_entity.dart';
import 'package:oneappcounter/model/device_model.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/device_info_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/splash_services.dart';
import 'package:oneappcounter/services/storage_service.dart';

class SetDeviceService {
  static DeviceModel? deviceSettingDetails;

  static Future<bool> addCounterAppDetails() async {
    log("start addCounterApp details");
    try {
      String path = 'counter/counter-device-settings/create';
      //  log("path $path");
      Map<String, dynamic> deviceDetails = {
        'device_data': await DeviceInfoService.getDeviceInfo(),
        if (deviceSettingDetails?.deviceUid != null)
          'device_uid': deviceSettingDetails?.deviceUid,
      };

      log("start app details $deviceDetails");

      Map<String, dynamic> data = {
        ...deviceDetails,
        'app_version': SplashScreenService.appVersion,
        if (AuthService.loginData?.user['id'] != null)
          'user_id': AuthService.loginData?.user['id'],
        'tab_settings': _generateTabSettingsMap(),
        'username': DeviceInfoService.deviceName,
      };

      var response = await NetworkingService.postHttp(path: path, data: data);

      if (response is Response &&
          response.statusCode == 200 &&
          response.data['data'] != null) {
        DeviceModel deviceModelData = DeviceModel.fromEntity(
            DeviceEntity.fromJson(response.data['data']));
        deviceSettingDetails = deviceModelData;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error adding counter app details: $e');
      return false;
    }
  }

  static List<dynamic> _generateTabSettingsMap() {
    List<dynamic> val = [];
    // ignore: no_leading_underscores_for_local_identifiers
    for (var _item in GeneralDataService.getTabs()) {
      Map<String, dynamic> mapOfItem = _item.counterSettings.toJsonEntity();
      mapOfItem['name'] = '${_item.serviceString} | ${_item.counter.name}';
      mapOfItem['services'] = _item.services.map((e) => e.id).toList();
      mapOfItem['counter'] = _item.counter.id;
      val.add(mapOfItem);
    }
    return val;
  }

  static Future<void> saveToLocal() async {
    try {
      await StorageService.saveValue(
        key: 'device_setting_details',
        value: json.encode(deviceSettingDetails?.toJson()),
      );
    } catch (e) {
      log('Error saving to local storage: $e');
    }
  }

  static Future<void> getFromLocal() async {
    try {
      var val =
          await StorageService.getSavedValue(key: 'device_setting_details');
      if (val != null) {
        DeviceModel data = DeviceModel.fromJson(json.decode(val));
        deviceSettingDetails = data;
      }
    } catch (e) {
      log('Error retrieving from local storage: $e');
    }
  }
}
