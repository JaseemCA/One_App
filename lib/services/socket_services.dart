// import 'dart:async';
// import 'package:laravel_echo/laravel_echo.dart';
// import 'package:oneappcounter/entity/countersetting_entity.dart';
// import 'package:oneappcounter/entity/queue_appointments_entity.dart';
// import 'package:oneappcounter/entity/queue_entity.dart';
// import 'package:oneappcounter/entity/service_entity.dart';
// import 'package:oneappcounter/entity/tocken_entity.dart';
// import 'package:oneappcounter/model/counter_settings_model.dart';
// import 'package:oneappcounter/model/queue_appointment_model.dart';
// import 'package:oneappcounter/model/queue_model.dart';
// import 'package:oneappcounter/model/service_model.dart';
// import 'package:oneappcounter/model/tocken_model.dart';
// import 'package:oneappcounter/services/auth_service.dart';
// import 'package:oneappcounter/services/counter_setting_service.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/local_notification_service.dart';
// import 'package:oneappcounter/services/networking_service.dart';
// import 'package:oneappcounter/services/set_device_service.dart';
// import 'package:socket_io_client/socket_io_client.dart' as i_o;

// class SocketService {
//   static bool _isDisposed = false;

//   static StreamController homePageRebuildRequiredController =
//       StreamController<bool>.broadcast();
//   static StreamController homePageAppBarRebuildRequiredController =
//       StreamController<bool>.broadcast();

//   static StreamController tokensPageRebuildRequiredController =
//       StreamController<bool>.broadcast();

//   static StreamController appointmentPageRebuildRequiredController =
//       StreamController<bool>.broadcast();

//   static StreamController settingsPageRebuildRequiredController =
//       StreamController<bool>.broadcast();

//   static StreamController eventReceivedController =
//       StreamController<int>.broadcast();

//   static List<int> listeningServices = [];

//   static i_o.Socket socket = i_o.io(
//     '${NetworkingService.domainUrl}:6001',
//     i_o.OptionBuilder()
//         .disableAutoConnect()
//         .setTransports(['websocket'])
//         .enableReconnection()
//         .setReconnectionDelay(1000)
//         .setReconnectionDelayMax(1000)
//         .build(),
//   );

//   static Echo echo =
//       Echo(broadcaster: EchoBroadcasterType.SocketIO, client: socket, options: {
//     'auth': {
//       'headers': {
//         'Authorization': 'Bearer ${NetworkingService.accessToken}',
//         'Accept': 'application/json',
//         'Tenant': '${AuthService.loginData?.systemBranch["website_id"]}',
//       },
//     }
//   });

//   // Future<void> initliseSocket() async {
//   //   LocalNotificationService().initNotificationSettings();

//   //   _isDisposed = false;

//   //   socket.onConnect((_) {
//   //     print('Socket connected');
//   //   });
//   //   // echo.connect();
//   //   socket.onDisconnect((data) {
//   //      print('Disconnected: $data');
//   //     if (_isDisposed == false) {
//   //       try {
//   //         _leaveChannels(leaveAll: true);
//   //       } catch (_) {}
//   //       echo.connect();
//   //       registerEvents(isAll: true);
//   //     }
//   //   });
//   // }

//   Future<void> initialiseSocket() async {
//     LocalNotificationService().initNotificationSettings();

//     _isDisposed = false;

//     socket.onConnect((_) {
//       print('Socket connected');
//     });

//     socket.onDisconnect((data) {
//       print('Disconnected: $data');
//       if (!_isDisposed) {
//         _leaveChannels(leaveAll: true);
//         echo.connect();
//         registerEvents(isAll: true);
//       }
//     });

//     socket.onError((error) {
//       print('Socket error: $error');
//     });

//     echo.connect();
//   }

//   static Future<void> registerEvents({bool isAll = false}) async {
//     if (GeneralDataService.getTabs().isNotEmpty) {
//       for (var serviceCounterTab in GeneralDataService.getTabs()) {
//         for (var service in serviceCounterTab.services) {
//           if (!(listeningServices.contains(service.id))) {
//             listeningServices.add(service.id);
//             echo
//                 .channel(
//                     'call.${AuthService.loginData?.systemBranch["website_id"]}.${service.id}')
//                 .listen('TokenIssued', (event) async {
//               //data;
//               print('TokenIssued event received: $event');
//               QueueModel queue =
//                   QueueModel.fromEntity(QueueEntity.fromJson(event['data']));
//               if (GeneralDataService.getTabs()[
//                       GeneralDataService.currentServiceCounterTabIndex]
//                   .services
//                   .map((e) => e.id)
//                   .toList()
//                   .contains(queue.serviceId)) {
//                 if (CounterSettingService.counterSettings?.notification ==
//                     true) {
//                   LocalNotificationService.showNotification(
//                     message:
//                         'Token ${queue.tokenNumber} added to ${queue.service['name']}',
//                     title: 'New Token in ${queue.service['name']}',
//                     service: '${queue.serviceId}service',
//                   );
//                 }
//                 if (CounterSettingService.counterSettings?.notificationSound ==
//                     true) {
//                   LocalNotificationService.playNotificationSound();
//                 }
//                 await GeneralDataService.getTodayTokenDetails();
//                 homePageRebuildRequiredController.add(true);
//                 tokensPageRebuildRequiredController.add(true);
//                 appointmentPageRebuildRequiredController.add(true);
//               } else {
//                 GeneralDataService.updateChangeInTab(queue.serviceId).then(
//                     (value) => eventReceivedController.add(queue.serviceId));
//               }
//             }).listen('AppointmentIssued', (event) async {
//               //data;

//               QueueAppointmentModel queue = QueueAppointmentModel.fromEntity(
//                   QueueAppointmentEntity.fromJson(event['data']));
//               if (GeneralDataService.getTabs()[
//                       GeneralDataService.currentServiceCounterTabIndex]
//                   .services
//                   .map((e) => e.id)
//                   .toList()
//                   .contains(queue.serviceId)) {
//                 if (CounterSettingService.counterSettings?.notification ==
//                     true) {
//                   LocalNotificationService.showNotification(
//                     message:
//                         'Appointment ${queue.tokenNumber} added to ${queue.service['name']}',
//                     title: 'New Appointment in ${queue.service['name']}',
//                     service: '${queue.serviceId}appointment',
//                   );
//                 }

//                 if (CounterSettingService.counterSettings?.notificationSound ==
//                     true) {
//                   LocalNotificationService.playNotificationSound();
//                 }

//                 await GeneralDataService.getTodayTokenDetails();
//                 homePageRebuildRequiredController.add(true);
//                 appointmentPageRebuildRequiredController.add(true);
//               } else {
//                 GeneralDataService.updateChangeInTab(queue.serviceId).then(
//                     (value) => eventReceivedController.add(queue.serviceId));
//               }
//             }).listen('TokenSideMenuActions', (event) {
//               if (GeneralDataService.getTabs()[
//                       GeneralDataService.currentServiceCounterTabIndex]
//                   .services
//                   .map((e) => e.id)
//                   .toList()
//                   .contains(event['queue']['service_id'])) {
//                 if (event['queue'] is Map<String, dynamic> &&
//                     event['queue'].containsKey('appointment_id')) {
//                   QueueAppointmentModel queue =
//                       QueueAppointmentModel.fromEntity(
//                           QueueAppointmentEntity.fromJson(event['queue']));

//                   if (queue.isCancelled == false &&
//                       CounterSettingService.counterSettings?.notification ==
//                           true &&
//                       (GeneralDataService.todayCancelledAppointments
//                               .indexWhere((element) => element.id == queue.id) <
//                           0)) {
//                     LocalNotificationService.showNotification(
//                       message:
//                           'Appointment ${queue.tokenNumber} added to ${queue.service['name']}',
//                       title: 'New Appointment in ${queue.service['name']}',
//                       service: '${queue.serviceId}appointment',
//                     );
//                   }
//                   if (queue.isCancelled == false &&
//                       CounterSettingService
//                               .counterSettings?.notificationSound ==
//                           true &&
//                       (GeneralDataService.todayCancelledAppointments
//                               .indexWhere((element) => element.id == queue.id) <
//                           0)) {
//                     LocalNotificationService.playNotificationSound();
//                   }
//                   GeneralDataService.getTodayTokenDetails().then((value) {
//                     tokensPageRebuildRequiredController.add(true);
//                     appointmentPageRebuildRequiredController.add(true);
//                   });
//                 } else {
//                   QueueModel queue = QueueModel.fromEntity(
//                       QueueEntity.fromJson(event['queue']));
//                   if (queue.isHold == true && queue.isCancelled == false) {
//                     GeneralDataService.queueHolded(queue).then((value) {
//                       tokensPageRebuildRequiredController.add(true);
//                       appointmentPageRebuildRequiredController.add(true);
//                     });
//                   } else if (queue.isCancelled == true &&
//                       queue.isHold == false) {
//                     GeneralDataService.queueCancelled(queue).then((value) {
//                       tokensPageRebuildRequiredController.add(true);
//                       appointmentPageRebuildRequiredController.add(true);
//                     });
//                   } else if (queue.isCancelled == false &&
//                       queue.isHold == false) {
//                     ///if inside holded queue, then place to todays queue.
//                     GeneralDataService.getTodayTokenDetails().then((value) {
//                       tokensPageRebuildRequiredController.add(true);
//                       appointmentPageRebuildRequiredController.add(true);
//                     });
//                   }
//                 }
//               } else {
//                 GeneralDataService.updateChangeInTab(
//                         event['queue']['service_id'])
//                     .then((value) => eventReceivedController
//                         .add(event['queue']['service_id']));
//               }
//             }).listen('TokenTransferred', (event) async {
//               TokenModel token = TokenModel.fromEntity(
//                   TokenEntity.fromJson(event['data']['call']));
//               if (GeneralDataService.getTabs()[
//                       GeneralDataService.currentServiceCounterTabIndex]
//                   .services
//                   .map((e) => e.id)
//                   .toList()
//                   .contains(token.serviceId)) {
//                 await GeneralDataService.updateTransferTokenDetails(
//                   token,
//                   transferTO: event['data']['transfer_to'],
//                 );
//                 homePageRebuildRequiredController.add(true);
//               } else {
//                 GeneralDataService.updateChangeInTab(token.serviceId).then(
//                     (value) => eventReceivedController.add(token.serviceId));
//               }
//             }).listen('TokenTransferredCancel', (event) {
//               // log('token transferred cancelled:: ' + event.toString());

//               GeneralDataService.getTodayTokenDetails().then((value) {
//                 tokensPageRebuildRequiredController.add(true);
//                 appointmentPageRebuildRequiredController.add(true);
//               });
//             }).listen('ReportReady', (event) {
//               TokenModel token =
//                   TokenModel.fromEntity(TokenEntity.fromJson(event['data']));
//               if (GeneralDataService.getTabs()[
//                       GeneralDataService.currentServiceCounterTabIndex]
//                   .services
//                   .map((e) => e.id)
//                   .toList()
//                   .contains(token.serviceId)) {
//                 GeneralDataService.updateTodayCalledTokens(token).then(
//                     (value) => tokensPageRebuildRequiredController.add(true));
//               } else {
//                 GeneralDataService.updateChangeInTab(token.serviceId).then(
//                     (value) => eventReceivedController.add(token.serviceId));
//               }
//             });
//           }
//         }
//       }
//     }
//     if (isAll) {
//       echo
//           .channel(
//               'token_updates.${AuthService.loginData?.systemBranch["website_id"]}')
//           .listen('TokenStatusChanged', (event) async {
//         TokenModel token =
//             TokenModel.fromEntity(TokenEntity.fromJson(event['call_data']));

//         if (((GeneralDataService.lastCalledToken?.queueId != null &&
//                 GeneralDataService.lastCalledToken?.queueId == token.queueId) ||
//             (GeneralDataService.lastCalledToken?.queueppointmentId != null &&
//                 GeneralDataService.lastCalledToken?.queueppointmentId ==
//                     token.queueppointmentId))) {
//           await GeneralDataService.getLastToken(tokenModel: token);
//           await GeneralDataService.updateTokenDetails(token);
//           homePageRebuildRequiredController.add(true);

//           GeneralDataService.getTodayTokenDetails().then((value) {
//             tokensPageRebuildRequiredController.add(true);
//             appointmentPageRebuildRequiredController.add(true);
//           });
//         }
//       });
//       echo
//           .channel(
//               'display.${AuthService.loginData?.systemBranch["website_id"]}')
//           .listen('TokenCalledV2', (event) async {
//         ///call
//         TokenModel token =
//             TokenModel.fromEntity(TokenEntity.fromJson(event['call']));
//         if ((GeneralDataService.getTabs()[
//                         GeneralDataService.currentServiceCounterTabIndex]
//                     .services
//                     .map((e) => e.id)
//                     .toList())
//                 .contains(token.serviceId) &&
//             (GeneralDataService.getTabs()[
//                         GeneralDataService.currentServiceCounterTabIndex]
//                     .counter
//                     .id ==
//                 token.counterId)) {
//           await GeneralDataService.getLastToken(tokenModel: token);
//         }
//         homePageRebuildRequiredController.add(true);
//         GeneralDataService.getTodayTokenDetails().then((value) {
//           homePageRebuildRequiredController.add(true);
//           tokensPageRebuildRequiredController.add(true);
//           appointmentPageRebuildRequiredController.add(true);
//         });
//       });
//       echo
//           .channel(
//               'service_updated.${AuthService.loginData?.systemBranch["website_id"]}')
//           .listen('ServiceHolded', (event) async {
//         ServiceModel service =
//             ServiceModel.fromEntity(ServiceEntity.fromJson(event['service']));
//         await GeneralDataService.updateServiceDetails(service);
//         homePageRebuildRequiredController.add(true);
//         homePageAppBarRebuildRequiredController.add(true);
//       });
//       echo
//           .channel(
//               'counter_app_settings_apply.${AuthService.loginData?.systemBranch["website_id"]}')
//           .listen('CounterAppSettingsApply', (event) {
//         List<dynamic> counterAppUserIds = event['counter_app_user_ids'];
//         if (counterAppUserIds
//             .map((e) => int.parse(e))
//             .toList()
//             .contains(SetDeviceService.deviceSettingDetails?.deviceUserId)) {
//           CounterSettingsModel counterSetting = CounterSettingsModel.fromEntity(
//               CounterSettingsEntity.fromJson(event['counter_app_settings']));
//           CounterSettingService.updateSettingsLocaly(counterSetting.toJson())
//               .then((value) => settingsPageRebuildRequiredController.add(true));
//         }
//       });
//     }
//   }

//   static Future<void> _leaveChannels({bool leaveAll = false}) async {
//     listeningServices.clear();
//     if (leaveAll) {
//       echo.leaveChannel(
//           'token_updates.${AuthService.loginData?.systemBranch["website_id"]}');
//       echo.leaveChannel(
//           'display.${AuthService.loginData?.systemBranch["website_id"]}');

//       echo.leaveChannel(
//           'service_updated.${AuthService.loginData?.systemBranch["website_id"]}');

//       echo.leaveChannel(
//           'counter_app_settings_apply.${AuthService.loginData?.systemBranch["website_id"]}');
//     }
//     if (GeneralDataService.getTabs().isNotEmpty) {
//       for (var serviceCounterTab in GeneralDataService.getTabs()) {
//         for (var service in serviceCounterTab.services) {
//           echo.leaveChannel(
//               'call.${AuthService.loginData?.systemBranch["website_id"]}.${service.id}');
//         }
//       }
//     }
//   }

//   static Future<void> connectAfterSwitch() async {
//     registerEvents(isAll: false);
//   }

//   static Future<void> destorySocket() async {
//     try {
//       _isDisposed = true;
//       _leaveChannels(leaveAll: true);
//       echo.disconnect();
//     } catch (_) {}
//   }
// }

// ignore_for_file: library_prefixes

import 'dart:async';
// import 'dart:developer';
import 'package:oneappcounter/entity/countersetting_entity.dart';
import 'package:oneappcounter/entity/queue_appointments_entity.dart';
import 'package:oneappcounter/entity/queue_entity.dart';
import 'package:oneappcounter/entity/service_entity.dart';
import 'package:oneappcounter/entity/tocken_entity.dart';
import 'package:oneappcounter/model/counter_settings_model.dart';
import 'package:oneappcounter/model/queue_appointment_model.dart';
import 'package:oneappcounter/model/queue_model.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/local_notification_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/set_device_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:laravel_echo/laravel_echo.dart';

class SocketService {
  static bool _isDisposed = false;

  static StreamController homePageRebuildRequiredController =
      StreamController<bool>.broadcast();
  static StreamController homePageAppBarRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController tokensPageRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController appointmentPageRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController settingsPageRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController eventReceivedController =
      StreamController<int>.broadcast();

  static List<int> listeningServices = [];

  static IO.Socket socket = IO.io(
    '${NetworkingService.domainUrl}:6001',
    IO.OptionBuilder()
        .disableAutoConnect()
        .setTransports(['websocket'])
        .enableReconnection()
        .setReconnectionDelay(1000)
        .setReconnectionDelayMax(1000)
        .build(),
  );

  // static IO.Socket socket = IO.io(
  //   'https://kozhikode-hospital.oneapp.life:6001',
  //   IO.OptionBuilder()
  //       .disableAutoConnect()
  //       .setTransports(['websocket'])
  //       .enableReconnection()
  //       .setReconnectionDelay(1000)
  //       .setReconnectionDelayMax(1000)
  //       .build(),
  // );
  static Echo echo =
      Echo(broadcaster: EchoBroadcasterType.SocketIO, client: socket, options: {
    'auth': {
      'headers': {
        'Authorization': 'Bearer ${NetworkingService.accessToken}',
        'Accept': 'application/json',
        'Tenant': '${AuthService.loginData?.systemBranch["website_id"]}',
      },
    }
  });

  Future<void> initialiseSocket() async {
    LocalNotificationService().initNotificationSettings();
    // log("initialisesocket");
    // log(' ${NetworkingService.domainUrl}:6001');
    // log('${NetworkingService.accessToken}');

    _isDisposed = false;
    echo.connect();
    socket.onDisconnect((data) {
      // log('Socket disconnected');
      if (_isDisposed == false) {
        try {
          _leaveChannels(leaveAll: true);
        } catch (_) {}
        echo.connect();
        // log("reconnect");
        registerEvents(isAll: true);
      }
    });
  }

  static Future<void> registerEvents({bool isAll = false}) async {
    // log('registerEvents called');
    if (GeneralDataService.getTabs().isNotEmpty) {
      // log('Tabs found: ${GeneralDataService.getTabs().length}');

      for (var serviceCounterTab in GeneralDataService.getTabs()) {
        // log('Registering services for tab: ${serviceCounterTab.services}');
        for (var service in serviceCounterTab.services) {
          // log('Checking if service ${service.id} is already registered');
          if (!(listeningServices.contains(service.id))) {
            // log('Registering service: ${service.id}');
            // log('sdfsdfsdsdfyyyyyyyyy: call.${AuthService.loginData?.systemBranch["website_id"]}.${service.id}');
            listeningServices.add(service.id);
            echo
                .channel(
                    'call.${AuthService.loginData?.systemBranch["website_id"]}.${service.id}')
                .listen('TokenIssued', (event) async {
              // log('TokenIssued event received for service: ${service.id}');

              QueueModel queue =
                  QueueModel.fromEntity(QueueEntity.fromJson(event['data']));
              if (GeneralDataService.getTabs()[
                      GeneralDataService.currentServiceCounterTabIndex]
                  .services
                  .map((e) => e.id)
                  .toList()
                  .contains(queue.serviceId)) {
                if (CounterSettingService.counterSettings?.notification ==
                    true) {
                  LocalNotificationService.showNotification(
                    message:
                        'Token ${queue.tokenNumber} added to ${queue.service['name']}',
                    title: 'New Token in ${queue.service['name']}',
                    service: '${queue.serviceId}service',
                  );
                }
                if (CounterSettingService.counterSettings?.notificationSound ==
                    true) {
                  LocalNotificationService.playNotificationSound();
                }
                await GeneralDataService.getTodayTokenDetails();
                homePageRebuildRequiredController.add(true);

                // log('homePageRebuildRequiredController updated');

                tokensPageRebuildRequiredController.add(true);
                appointmentPageRebuildRequiredController.add(true);
              } else {
                GeneralDataService.updateChangeInTab(queue.serviceId).then(
                    (value) => eventReceivedController.add(queue.serviceId));
              }
            }).listen('AppointmentIssued', (event) async {
              //data;
              // log('AppointmentIssued event received for service: ${service.id}');
              QueueAppointmentModel queue = QueueAppointmentModel.fromEntity(
                  QueueAppointmentEntity.fromJson(event['data']));
              if (GeneralDataService.getTabs()[
                      GeneralDataService.currentServiceCounterTabIndex]
                  .services
                  .map((e) => e.id)
                  .toList()
                  .contains(queue.serviceId)) {
                if (CounterSettingService.counterSettings?.notification ==
                    true) {
                  LocalNotificationService.showNotification(
                    message:
                        'Appointment ${queue.tokenNumber} added to ${queue.service['name']}',
                    title: 'New Appointment in ${queue.service['name']}',
                    service: '${queue.serviceId}appointment',
                  );
                }

                if (CounterSettingService.counterSettings?.notificationSound ==
                    true) {
                  LocalNotificationService.playNotificationSound();
                }

                await GeneralDataService.getTodayTokenDetails();
                homePageRebuildRequiredController.add(true);
                appointmentPageRebuildRequiredController.add(true);
              } else {
                GeneralDataService.updateChangeInTab(queue.serviceId).then(
                    (value) => eventReceivedController.add(queue.serviceId));
              }
            }).listen('TokenSideMenuActions', (event) {
              if (GeneralDataService.getTabs()[
                      GeneralDataService.currentServiceCounterTabIndex]
                  .services
                  .map((e) => e.id)
                  .toList()
                  .contains(event['queue']['service_id'])) {
                if (event['queue'] is Map<String, dynamic> &&
                    event['queue'].containsKey('appointment_id')) {
                  QueueAppointmentModel queue =
                      QueueAppointmentModel.fromEntity(
                          QueueAppointmentEntity.fromJson(event['queue']));

                  if (queue.isCancelled == false &&
                      CounterSettingService.counterSettings?.notification ==
                          true &&
                      (GeneralDataService.todayCancelledAppointments
                              .indexWhere((element) => element.id == queue.id) <
                          0)) {
                    LocalNotificationService.showNotification(
                      message:
                          'Appointment ${queue.tokenNumber} added to ${queue.service['name']}',
                      title: 'New Appointment in ${queue.service['name']}',
                      service: '${queue.serviceId}appointment',
                    );
                  }
                  if (queue.isCancelled == false &&
                      CounterSettingService
                              .counterSettings?.notificationSound ==
                          true &&
                      (GeneralDataService.todayCancelledAppointments
                              .indexWhere((element) => element.id == queue.id) <
                          0)) {
                    LocalNotificationService.playNotificationSound();
                  }
                  GeneralDataService.getTodayTokenDetails().then((value) {
                    tokensPageRebuildRequiredController.add(true);
                    appointmentPageRebuildRequiredController.add(true);
                  });
                } else {
                  QueueModel queue = QueueModel.fromEntity(
                      QueueEntity.fromJson(event['queue']));
                  if (queue.isHold == true && queue.isCancelled == false) {
                    GeneralDataService.queueHolded(queue).then((value) {
                      tokensPageRebuildRequiredController.add(true);
                      appointmentPageRebuildRequiredController.add(true);
                    });
                  } else if (queue.isCancelled == true &&
                      queue.isHold == false) {
                    GeneralDataService.queueCancelled(queue).then((value) {
                      tokensPageRebuildRequiredController.add(true);
                      appointmentPageRebuildRequiredController.add(true);
                    });
                  } else if (queue.isCancelled == false &&
                      queue.isHold == false) {
                    GeneralDataService.getTodayTokenDetails().then((value) {
                      tokensPageRebuildRequiredController.add(true);
                      appointmentPageRebuildRequiredController.add(true);
                    });
                  }
                }
              } else {
                GeneralDataService.updateChangeInTab(
                        event['queue']['service_id'])
                    .then((value) => eventReceivedController
                        .add(event['queue']['service_id']));
              }

              // log('Token side menu actions :: $event');
            }).listen('TokenTransferred', (event) async {
              TokenModel token = TokenModel.fromEntity(
                  TokenEntity.fromJson(event['data']['call']));
              if (GeneralDataService.getTabs()[
                      GeneralDataService.currentServiceCounterTabIndex]
                  .services
                  .map((e) => e.id)
                  .toList()
                  .contains(token.serviceId)) {
                await GeneralDataService.updateTransferTokenDetails(
                  token,
                  transferTO: event['data']['transfer_to'],
                );
                homePageRebuildRequiredController.add(true);
              } else {
                GeneralDataService.updateChangeInTab(token.serviceId).then(
                    (value) => eventReceivedController.add(token.serviceId));
              }
            }).listen('TokenTransferredCancel', (event) {
              // log('token transferred cancelled:: $event');

              GeneralDataService.getTodayTokenDetails().then((value) {
                tokensPageRebuildRequiredController.add(true);
                appointmentPageRebuildRequiredController.add(true);
              });
            }).listen('ReportReady', (event) {
              TokenModel token =
                  TokenModel.fromEntity(TokenEntity.fromJson(event['data']));
              if (GeneralDataService.getTabs()[
                      GeneralDataService.currentServiceCounterTabIndex]
                  .services
                  .map((e) => e.id)
                  .toList()
                  .contains(token.serviceId)) {
                GeneralDataService.updateTodayCalledTokens(token).then(
                    (value) => tokensPageRebuildRequiredController.add(true));
              } else {
                GeneralDataService.updateChangeInTab(token.serviceId).then(
                    (value) => eventReceivedController.add(token.serviceId));
              }
              // log('report ready ::$event');
            });
          }
        }
      }
    }
    if (isAll) {
      // log('Registering global token and service events');
      echo
          .channel(
              'token_updates.${AuthService.loginData?.systemBranch["website_id"]}')
          .listen('TokenStatusChanged', (event) async {
        // log('TokenStatusChanged event received');
        TokenModel token =
            TokenModel.fromEntity(TokenEntity.fromJson(event['call_data']));

        if (((GeneralDataService.lastCalledToken?.queueId != null &&
                GeneralDataService.lastCalledToken?.queueId == token.queueId) ||
            (GeneralDataService.lastCalledToken?.queueppointmentId != null &&
                GeneralDataService.lastCalledToken?.queueppointmentId ==
                    token.queueppointmentId))) {
          await GeneralDataService.getLastToken(tokenModel: token);
          await GeneralDataService.updateTokenDetails(token);
          homePageRebuildRequiredController.add(true);

          GeneralDataService.getTodayTokenDetails().then((value) {
            tokensPageRebuildRequiredController.add(true);
            appointmentPageRebuildRequiredController.add(true);
          });
        }
      });
      echo
          .channel(
              'display.${AuthService.loginData?.systemBranch["website_id"]}')
          .listen('TokenCalledV2', (event) async {
        TokenModel token =
            TokenModel.fromEntity(TokenEntity.fromJson(event['call']));
        if ((GeneralDataService.getTabs()[
                        GeneralDataService.currentServiceCounterTabIndex]
                    .services
                    .map((e) => e.id)
                    .toList())
                .contains(token.serviceId) &&
            (GeneralDataService.getTabs()[
                        GeneralDataService.currentServiceCounterTabIndex]
                    .counter
                    .id ==
                token.counterId)) {
          await GeneralDataService.getLastToken(tokenModel: token);
        }
        homePageRebuildRequiredController.add(true);
        GeneralDataService.getTodayTokenDetails().then((value) {
          homePageRebuildRequiredController.add(true);
          tokensPageRebuildRequiredController.add(true);
          appointmentPageRebuildRequiredController.add(true);
        });
      });
      echo
          .channel(
              'service_updated.${AuthService.loginData?.systemBranch["website_id"]}')
          .listen('ServiceHolded', (event) async {
        ServiceModel service =
            ServiceModel.fromEntity(ServiceEntity.fromJson(event['service']));
        await GeneralDataService.updateServiceDetails(service);
        homePageRebuildRequiredController.add(true);
        homePageAppBarRebuildRequiredController.add(true);
      });
      echo
          .channel(
              'counter_app_settings_apply.${AuthService.loginData?.systemBranch["website_id"]}')
          .listen('CounterAppSettingsApply', (event) {
        List<dynamic> counterAppUserIds = event['counter_app_user_ids'];
        if (counterAppUserIds
            .map((e) => int.parse(e))
            .toList()
            .contains(SetDeviceService.deviceSettingDetails?.deviceUserId)) {
          CounterSettingsModel counterSetting = CounterSettingsModel.fromEntity(
              CounterSettingsEntity.fromJson(event['counter_app_settings']));
          CounterSettingService.updateSettingsLocaly(counterSetting.toJson())
              .then((value) => settingsPageRebuildRequiredController.add(true));
        }
      });
    }
  }

  static Future<void> _leaveChannels({bool leaveAll = false}) async {
    listeningServices.clear();
    // log('Cleared listening services.');

    if (leaveAll) {
      // log('Leaving all channels...');
      echo.leaveChannel(
          'token_updates.${AuthService.loginData?.systemBranch["website_id"]}');
      // log('Left token_updates channel.');

      echo.leaveChannel(
          'display.${AuthService.loginData?.systemBranch["website_id"]}');
      // log('Left display channel.');

      echo.leaveChannel(
          'service_updated.${AuthService.loginData?.systemBranch["website_id"]}');
      // log('Left service_updated channel.');

      echo.leaveChannel(
          'counter_app_settings_apply.${AuthService.loginData?.systemBranch["website_id"]}');
      // log('Left counter_app_settings_apply channel.');
    }

    if (GeneralDataService.getTabs().isNotEmpty) {
      // log('Leaving service channels...');
      for (var serviceCounterTab in GeneralDataService.getTabs()) {
        for (var service in serviceCounterTab.services) {
          echo.leaveChannel(
              'call.${AuthService.loginData?.systemBranch["website_id"]}.${service.id}');
          // log('Left call.${AuthService.loginData?.systemBranch["website_id"]}.${service.id} channel.');
        }
      }
    }
  }

  static Future<void> disconnectOnTabSwitch() async {
    _leaveChannels(leaveAll: false);
  }

  static Future<void> leaveOnly() async {
    List<int> allServices = [];
    List<int> nonRemovedIds = [];
    if (GeneralDataService.getTabs().isNotEmpty) {
      for (var serviceCounterTab in GeneralDataService.getTabs()) {
        for (var service in serviceCounterTab.services) {
          allServices.add(service.id);
        }
      }
      for (var serviceId in listeningServices) {
        if (!(allServices.contains(serviceId))) {
          echo.leaveChannel(
              'call.${AuthService.loginData?.systemBranch["website_id"]}.$serviceId');
        } else {
          nonRemovedIds.add(serviceId);
        }
      }
      listeningServices.clear();
      listeningServices = nonRemovedIds;
    }
  }

  static Future<void> connectAfterSwitch() async {
    // log("Connect after switch");

    registerEvents(isAll: false);
  }

  static Future<void> destorySocket() async {
    // log("Destroy  Socket");

    try {
      _isDisposed = true;
      _leaveChannels(leaveAll: true);
      echo.disconnect();
    } catch (_) {}
  }
}
