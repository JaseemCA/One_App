import 'dart:async';
import 'package:dio/dio.dart';

class NetworkInterceptorService extends Interceptor {
  static StreamController<bool> subscriptionEndedCheckStream =
      StreamController<bool>();
  static bool _isSubscriptionFired = false;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 450) {
      if (!_isSubscriptionFired) {
        _isSubscriptionFired = true;
        subscriptionEndedCheckStream.add(true);
      }
    } else {
      // subscriptionEndedCheckStream.add(false);
      _isSubscriptionFired = false;
    }
    if (response.statusCode == 201 || response.statusCode == 200) {
      response.statusCode = 200;
    }
    super.onResponse(response, handler);
  }
}
