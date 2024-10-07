// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:oneappcounter/services/storage_service.dart';

class NetworkingService {
  static String? domainUrl;
  static String? apiDomainUrl;
  static String? accessToken;
  static String defaultUrl = 'https://www.oneapp.life';
  static String defaultApiUrl = 'https://www.oneapp.life/api';

  static Future<dynamic> getHttp(
    String path, {
    bool useAsFullPath = false,
    Map<String, dynamic> data = const {},
  }) async {
    try {
      if (!useAsFullPath) {
        if (apiDomainUrl != null) {
          path = '${apiDomainUrl!}/$path';
        }
      }

      var response = await Dio().get(path,
          queryParameters: data,
          options: Options(
            headers: _getHeaders(token: accessToken),
          ));
      return response;
    } catch (e) {
      log("Error in GET request: $e");
      return null; 
    }
  }

  static Future<dynamic> postHttp(
      {required String path,
      required Map<String, dynamic> data,
      bool addToken = true}) async {
    try {
      String _path = '$apiDomainUrl/$path';
      return await Dio().post(_path,
          data: data,
          options: Options(
              headers: _getHeaders(token: addToken ? accessToken : null)));
    } catch (e) {
      return e;
    }
  }

  static Future<bool> setSavedValues() async {
    domainUrl = await StorageService.getSavedValue(key: 'domain_url');
    if (domainUrl != null) {
      apiDomainUrl = await StorageService.getSavedValue(key: 'api_domain_url');
      String? _accessToken =
          await StorageService.getSavedValue(key: 'access_token');
      if (_accessToken != null) {
        accessToken = _accessToken;
      }
      if (apiDomainUrl != null) {
        return true;
      } else {
        apiDomainUrl = '${domainUrl!}/api';
        return true;
      }
    }
    return false;
  }

  static Future<dynamic> deleteHttp({required String path}) async {
    try {
      if (apiDomainUrl != null) {
        path = '${apiDomainUrl!}/$path';
      }
      return await Dio().delete(path,
          options: Options(
            headers: _getHeaders(token: accessToken),
          ));
    } catch (e) {
      return e;
    }
  }

  static Future<bool> checkInternetConnection() async {
    try {
      Response response = await getHttp(
          'https://www.oneapp.life/api/check-internet',
          useAsFullPath: true);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  static Future<bool> checkSubscription() async {
    try {
      Response response = await getHttp('time');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Map<String, String> _getHeaders({String? token}) {
    if (token != null) {
      return {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
    }
    return {'Accept': 'application/json', 'Content-Type': 'application/json'};
  }
}
