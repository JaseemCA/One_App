import 'package:dio/dio.dart';
import 'package:oneappcounter/entity/queue_appointments_entity.dart';
import 'package:oneappcounter/entity/queue_entity.dart';
import 'package:oneappcounter/entity/tocken_entity.dart';
import 'package:oneappcounter/model/queue_appointment_model.dart';
import 'package:oneappcounter/model/queue_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/set_device_service.dart';

class CallService {
  static Future<dynamic> callNextToken() async {
    String path = 'call/next';
    Map<String, dynamic> data = {
      'counter': GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .counter
          .id,
      'services': GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .services
          .map((e) => e.id)
          .toList(),
      'device_user_id': SetDeviceService.deviceSettingDetails?.deviceUserId,
    };
    var response = await NetworkingService.postHttp(path: path, data: data);

    if (response is Response && response.statusCode == 200) {
      TokenModel tokenModel =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.getLastToken(tokenModel: tokenModel);
      GeneralDataService.getTodayTokenDetails();
      return tokenModel;
    } else if (response is DioException) {
      return response.response?.data['message'];
    }
    return false;
  }

  static Future<dynamic> serveToken() async {
    final String path = 'call/${GeneralDataService.lastCalledToken?.id}/serve';

    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      TokenModel tokenModel =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.getLastToken(tokenModel: tokenModel);
      await GeneralDataService.getTodayTokenDetails();
      return tokenModel;
    }
    return false;
  }

  static Future<dynamic> recallToken({required int id}) async {
    final String path = "call/$id/recall";

    var response = await NetworkingService.postHttp(path: path, data: {
      'device_user_id': SetDeviceService.deviceSettingDetails?.deviceUserId
    });

    if (response is Response && response.statusCode == 200) {
      TokenModel tokenModel =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.getLastToken(tokenModel: tokenModel);
      await GeneralDataService.getTodayTokenDetails();
      return tokenModel;
    }
    return false;
  }

  static Future<dynamic> markTokenNoShow() async {
    final String path =
        "call/${GeneralDataService.lastCalledToken?.id}/no-show";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      TokenModel tokenModel =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.getLastToken(tokenModel: tokenModel);
      await GeneralDataService.getTodayTokenDetails();
      return tokenModel;
    }
    return false;
  }

  static Future<dynamic> holdToken() async {
    final String path = "call/${GeneralDataService.lastCalledToken?.id}/hold";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      TokenModel tokenModel =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.getLastToken(tokenModel: tokenModel);
      await GeneralDataService.getTodayTokenDetails();
      return tokenModel;
    }
    return false;
  }

  static Future<dynamic> unholdToken({required int id}) async {
    final String path = "call/$id/unhold/true";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      TokenModel tokenModel =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.getLastToken(tokenModel: tokenModel);
      await GeneralDataService.getTodayTokenDetails();
      return tokenModel;
    }
    return false;
  }

  static Future<dynamic> transferService({
    required Map<String, dynamic> data,
    required TokenModel token,
  }) async {
    String path = "";
    if (token.queueId != null) {
      path = "transfer/${token.queueId}/${data['transfer_service_ids'][0]}";
    } else if (token.queueppointmentId != null) {
      path =
          "transfer/appointment/${token.queueppointmentId}/${data['transfer_service_ids'][0]}";
    }
    data['transfer_service_ids[]'] = data['transfer_service_ids'];
    data.remove('transfer_service_ids');
    var response = await NetworkingService.getHttp(path, data: data);
    if (response is Response && response.statusCode == 200) {
      await GeneralDataService.getLastToken();
      await GeneralDataService.getTodayTokenDetails();
      return true;
    }
    return false;
  }

  static Future<dynamic> undoTransferService(
      {required TokenModel token}) async {
    String path = "";
    if (token.queueId != null) {
      path = "undo/transfer/token/${token.queueId}";
    } else if (token.queueppointmentId != null) {
      path = "undo/transfer/appointment/${token.queueppointmentId}";
    }
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      await GeneralDataService.getLastToken();
      await GeneralDataService.getTodayTokenDetails();
      return true;
    }
    return false;
  }

  static Future<dynamic> callTokenFromQueue({required int queueId}) async {
    final String path = 'kiosk/$queueId/call';
    Map<String, dynamic> data = {
      'counter': GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .counter
          .id,
      'services': GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .services
          .map((e) => e.id)
          .toList(),
      'device_user_id': SetDeviceService.deviceSettingDetails?.deviceUserId,
    };
    var response = await NetworkingService.postHttp(path: path, data: data);
    if (response is Response && response.statusCode == 200) {
      TokenModel tokenModel =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.getLastToken(tokenModel: tokenModel);
      GeneralDataService.getTodayTokenDetails();
      return tokenModel;
    }
    return false;
  }

  static Future<dynamic> holdQueueItem({required int queueId}) async {
    final String path = "queue/$queueId/hold";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      GeneralDataService.queueHolded(
          QueueModel.fromEntity(QueueEntity.fromJson(response.data['data'])));
      return true;
    }
    return false;
  }

  static Future<dynamic> cancelQueueItem({required int queueId}) async {
    final String path = "queue/$queueId/cancel";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      if (await GeneralDataService.getTodayTokenDetails()) return true;
    }
    return false;
  }

  static Future<dynamic> addCancelledTokenToQueue(
      {required int queueId}) async {
    final String path = 'queue/$queueId/add';
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      if (await GeneralDataService.getTodayTokenDetails()) return true;
    }
    return false;
  }

  static Future<dynamic> unholdQueueToken({required int queueId}) async {
    final String path = "queue/$queueId/unhold";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      if (await GeneralDataService.getTodayTokenDetails()) return true;
    }
    return false;
  }

  static Future<dynamic> callAppointmentToken(
      {required int queueAppointmentId}) async {
    final String path = "queue/$queueAppointmentId/appointment/call";
    Map<String, dynamic> data = {
      'counter': GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .counter
          .id,
      'services': GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .services
          .map((e) => e.id)
          .toList(),
      'device_user_id': SetDeviceService.deviceSettingDetails?.deviceUserId,
    };
    var response = await NetworkingService.postHttp(path: path, data: data);
    if (response is Response && response.statusCode == 200) {
      TokenModel token =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      GeneralDataService.getLastToken(tokenModel: token);
      return token;
    }
    return false;
  }

  static Future<bool> cancelAppointment(
      {required int queueAppointmentId}) async {
    final String path = "queue/$queueAppointmentId/appointment/cancel";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      if (await GeneralDataService.getTodayTokenDetails()) return true;
    }
    return false;
  }

  static Future<bool> addToAppointmentQueue(
      {required int queueAppointmentId}) async {
    final String path = "queue/$queueAppointmentId/appointment/add";
    var response = await NetworkingService.postHttp(path: path, data: {});
    if (response is Response && response.statusCode == 200) {
      if (await GeneralDataService.getTodayTokenDetails()) return true;
    }
    return false;
  }

  static Future<bool> markReportReady(
      {required int callId, bool showOnDisplay = false}) async {
    final String path = "make/report/$callId";
    var response = await NetworkingService.postHttp(
        path: path, data: {'show_on_display': showOnDisplay});
    if (response is Response && response.statusCode == 200) {
      TokenModel token =
          TokenModel.fromEntity(TokenEntity.fromJson(response.data['data']));
      await GeneralDataService.updateTodayCalledTokens(token);
      return true;
    }
    return false;
  }

  static Future<dynamic> getCustomerFlow({
    required int id,
    bool isQueue = true,
  }) async {
    String path = "";
    if (isQueue) {
      path = "token/$id/customer-flow/queue";
    } else {
      path = "token/$id/customer-flow/appointment";
    }
    var response = await NetworkingService.getHttp(path);
    if (response is Response && response.statusCode == 200) {
      var data = response.data['data'];
      List<QueueModel> listOfQueue = [];
      List<QueueAppointmentModel> listOfAppointmentQueue = [];

      if (isQueue) {
        for (var item in data) {
          listOfQueue.add(QueueModel.fromEntity(QueueEntity.fromJson(item)));
        }
        return listOfQueue;
      } else {
        for (var item in data) {
          listOfAppointmentQueue.add(QueueAppointmentModel.fromEntity(
              QueueAppointmentEntity.fromJson(item)));
        }
        return listOfAppointmentQueue;
      }
    }
    return false;
  }

  static Future<bool> saveQueueRemark(
      {required int id, required remarks, bool isAppointment = false}) async {
    String path = 'queue/$id/remarks';

    if (isAppointment == true) {
      path = 'appointment-queue/$id/remarks';
    }

    var response = await NetworkingService.postHttp(
        path: path, data: {"remarks": remarks});

    if (response is Response && response.statusCode == 200) {
      GeneralDataService.getLastToken();
      return true;
    }
    return false;
  }
}
