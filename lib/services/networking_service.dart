

import 'package:dio/dio.dart';
import 'package:oneappcounter/services/storage_service.dart';
 // Import your cubit

class NetworkingService {
  final NetworkingCubit networkingCubit;

  NetworkingService(this.networkingCubit);

  Future<dynamic> getHttp(
    String path, {
    bool useAsFullPath = false,
    Map<String, dynamic> data = const {},
  }) async {
    try {
      String? apiDomainUrl = networkingCubit.state.apiDomainUrl;
      if (!useAsFullPath) {
        if (apiDomainUrl != null) {
          path = '$apiDomainUrl/$path';
        }
      }

      var response = await Dio().get(path,
          queryParameters: data,
          options: Options(
            headers: _getHeaders(token: networkingCubit.state.accessToken),
          ));
      return response;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> postHttp(
      {required String path,
      required Map<String, dynamic> data,
      bool addToken = true}) async {
    try {
      String? apiDomainUrl = networkingCubit.state.apiDomainUrl;
      String path0 = '$apiDomainUrl/$path';
      return await Dio().post(path0,
          data: data,
          options: Options(
              headers: _getHeaders(token: addToken ? networkingCubit.state.accessToken : null)));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> deleteHttp({required String path}) async {
    try {
      String? apiDomainUrl = networkingCubit.state.apiDomainUrl;
      if (apiDomainUrl != null) {
        path = '$apiDomainUrl/$path';
      }
      return await Dio().delete(path,
          options: Options(
            headers: _getHeaders(token: networkingCubit.state.accessToken),
          ));
    } catch (e) {
      return e;
    }
  }

  Future<bool> checkInternetConnection() async {
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

  Future<bool> checkSubscription() async {
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

  Map<String, String> _getHeaders({String? token}) {
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
