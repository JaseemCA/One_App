// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:oneappcounter/model/login_response.dart';
// import 'package:oneappcounter/model/user_credential.dart';
// import 'package:oneappcounter/services/counter_setting_service.dart';
// import 'package:oneappcounter/services/networking_service.dart';
// import 'package:oneappcounter/services/storage_service.dart';

// class AuthService {
//   static LoginResponse? loginData;
//   static String? branchName;
//   static int? countryId;
//   static String? countryName;
//   static String? countryCallingCode;
//   static String? countryIso31662;

//   static Future<bool> validateDomain(String url) async {
//     url = '$url/api/check-domain';
//     var response = await NetworkingService.getHttp(url, useAsFullPath: true);
//     if (response is Response) {
//       if (response.statusCode == 200) {
//         return true;
//       }
//     }
//     return false;
//   }

//   static Future<bool> loginToDomain({required UserCredential userdata}) async {
//     dynamic response = await NetworkingService.postHttp(
//       path: 'login',
//       data: userdata.toJson(),
//       addToken: false,
//     );

//     if (response is Response && response.statusCode == 200) {
//       LoginResponse data = LoginResponse.fromJson(response.data['data']);
//       await saveValueToStorage(data);
//       await getSavedData();
//       return true;
//     }
//     return false;
//   }

//   static Future<void> saveValueToStorage(LoginResponse data) async {
//     await StorageService.saveValue(
//       key: 'access_token',
//       value: data.accessToken,
//     );
//     await StorageService.saveValue(
//       key: 'login_data',
//       value: json.encode(data.toJson()),
//     );
//   }

//   static Future<void> getSavedData() async {
//     var val = await StorageService.getSavedValue(key: 'login_data');
//     if (val != null) {
//       loginData = LoginResponse.fromJson(
//         jsonDecode(val.toString()),
//       );
//       branchName =
//           '${loginData?.systemBranch["name"]}, ${loginData?.systemBranch["location"]}';
//       countryId = loginData?.systemBranch.containsKey('country_id')
//           ? loginData?.systemBranch['country_id']
//           : loginData?.systemBranch.containsKey('country')
//               ? loginData?.systemBranch['country']['id']
//               : 0;
//       countryName = loginData?.systemBranch.containsKey('country') &&
//               loginData?.systemBranch['country'].containsKey('name')
//           ? loginData?.systemBranch['country']['name'] ?? ''
//           : '';
//       countryCallingCode = loginData?.systemBranch.containsKey('country_code')
//           ? loginData?.systemBranch['country_code']
//           : loginData?.systemBranch.containsKey('country') &&
//                   loginData?.systemBranch['country'].containsKey('calling_code')
//               ? loginData?.systemBranch['country']['calling_code']
//               : '';
//       countryIso31662 = loginData?.systemBranch.containsKey('country') &&
//               loginData?.systemBranch['country'].containsKey('iso_3166_2')
//           ? loginData?.systemBranch['country']['iso_3166_2']
//           : '';
//     }
//     await NetworkingService.setSavedValues();
//   }

//   static Future<void> clearLoginToken() async {
//     await StorageService.removedSavedValue(key: 'access_token');
//     await StorageService.removedSavedValue(key: 'login_data');
//   }

//   static Future<bool> logoutUser() async {
//     String url = 'auth/logout';

//     try {
//       final response = await NetworkingService.postHttp(
//         path: url,
//         data: {'': ''},
//       );
//       if (response is Response && response.statusCode == 200) {
//         await clearLoginToken();
//         await CounterSettingService.clearSettingsData();
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<bool> updateBranchDetails() async {
//     String path = 'system_branch/${loginData?.systemBranch['id']}';
//     var res = await NetworkingService.getHttp(path);
//     if (res is Response && res.statusCode == 200 && res.data != null) {
//       if (loginData != null) {
//         String? accessToken = loginData?.accessToken;
//         LoginResponse loginResponse = LoginResponse(
//           accessToken!,
//           loginData?.user,
//           loginData?.branch,
//           res.data['data'],
//         );
//         await saveValueToStorage(loginResponse);
//         await getSavedData();
//       }
//       return true;
//     }
//     return false;
//   }

//   // static void updateCountryData(List<CountryModel> countries) {
//   //   int _index = countries.indexWhere((element) => element.id == countryId);
//   //   if (_index >= 0) {
//   //     CountryModel country = countries[_index];
//   //     countryName = country.name;
//   //     countryIso31662 = country.iso31662;
//   //   }
//   // }
// }

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:oneappcounter/model/country_model.dart';
import 'package:oneappcounter/model/login_response.dart';
import 'package:oneappcounter/model/user_credential.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/storage_service.dart';

class AuthService {
  static LoginResponse? loginData;
  static String? branchName;
  static int? countryId;
  static String? countryName;
  static String? countryCallingCode;
  static String? countryIso31662;

  static Future<bool> validateDomain(String url) async {
    url = url + '/api/check-domain';
    var response = await NetworkingService.getHttp(url, useAsFullPath: true);
    if (response is Response) {
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> loginToDomain({required UserCredential userdata}) async {
    dynamic response = await NetworkingService.postHttp(
      path: 'login',
      data: userdata.toJson(),
      addToken: false,
    );

    if (response is Response && response.statusCode == 200) {
      LoginResponse data = LoginResponse.fromJson(response.data['data']);
      await saveValueToStorage(data);
      await getSavedData();
      return true;
    }
    return false;
  }

  static Future<void> saveValueToStorage(LoginResponse data) async {
    await StorageService.saveValue(
      key: 'access_token',
      value: data.accessToken,
    );
    await StorageService.saveValue(
      key: 'login_data',
      value: json.encode(data.toJson()),
    );
  }

  static Future<void> getSavedData() async {
    var _val = await StorageService.getSavedValue(key: 'login_data');
    if (_val != null) {
      loginData = LoginResponse.fromJson(
        jsonDecode(_val.toString()),
      );
      branchName =
          '${loginData?.systemBranch["name"]}, ${loginData?.systemBranch["location"]}';
      countryId = loginData?.systemBranch.containsKey('country_id')
          ? loginData?.systemBranch['country_id']
          : loginData?.systemBranch.containsKey('country')
              ? loginData?.systemBranch['country']['id']
              : 0;
      countryName = loginData?.systemBranch.containsKey('country') &&
              loginData?.systemBranch['country'].containsKey('name')
          ? loginData?.systemBranch['country']['name'] ?? ''
          : '';
      countryCallingCode = loginData?.systemBranch.containsKey('country_code')
          ? loginData?.systemBranch['country_code']
          : loginData?.systemBranch.containsKey('country') &&
                  loginData?.systemBranch['country'].containsKey('calling_code')
              ? loginData?.systemBranch['country']['calling_code']
              : '';
      countryIso31662 = loginData?.systemBranch.containsKey('country') &&
              loginData?.systemBranch['country'].containsKey('iso_3166_2')
          ? loginData?.systemBranch['country']['iso_3166_2']
          : '';
    }
    await NetworkingService.setSavedValues();
  }

  static Future<void> clearLoginToken() async {
    await StorageService.removedSavedValue(key: 'access_token');
    await StorageService.removedSavedValue(key: 'login_data');
  }

  static Future<bool> logoutUser() async {
    String _url = 'auth/logout';

    try {
      final response = await NetworkingService.postHttp(
        path: _url,
        data: {'': ''},
      );
      if (response is Response && response.statusCode == 200) {
        await clearLoginToken();
        await CounterSettingService.clearSettingsData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateBranchDetails() async {
    String _path = 'system_branch/${loginData?.systemBranch['id']}';
    var res = await NetworkingService.getHttp(_path);
    if (res is Response && res.statusCode == 200 && res.data != null) {
      if (loginData != null) {
        String? _accessToken = loginData?.accessToken;
        LoginResponse _loginResponse = LoginResponse(
          _accessToken!,
          loginData?.user,
          loginData?.branch,
          res.data['data'],
        );
        await saveValueToStorage(_loginResponse);
        await getSavedData();
      }
      return true;
    }
    return false;
  }

  static void updateCountryData(List<CountryModel> countries) {
    int _index = countries.indexWhere((element) => element.id == countryId);
    if (_index >= 0) {
      CountryModel country = countries[_index];
      countryName = country.name;
      countryIso31662 = country.iso31662;
    }
  }
}
