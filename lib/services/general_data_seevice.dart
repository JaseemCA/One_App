import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oneappcounter/entity/counter_entity.dart';
import 'package:oneappcounter/entity/queue_appointments_entity.dart';
import 'package:oneappcounter/entity/queue_entity.dart';
import 'package:oneappcounter/entity/service_entity.dart';
import 'package:oneappcounter/entity/tocken_entity.dart';
import 'package:oneappcounter/entity/today_tocken_details_entity.dart';
import 'package:oneappcounter/model/counter_model.dart';
import 'package:oneappcounter/model/counter_settings_model.dart';
import 'package:oneappcounter/model/queue_appointment_model.dart';
import 'package:oneappcounter/model/queue_model.dart';
import 'package:oneappcounter/model/service_counter_tab_model.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/model/theme_modal.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/model/today_tocken_details_model.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/set_device_service.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/storage_service.dart';

class GeneralDataService {
  static List<ServiceModel> activeServices = [];
  static List<CounterModel> activeCounters = [];

  static final List<ServiceCounterTabModel> _allServiceCounterTabs = [];
  static int currentServiceCounterTabIndex = 0;
  static ServiceCounterTabModel? currentServiceCounterTab;
  static ThemeModeModel themeModeVar =
      const ThemeModeModel(themeMode: ThemeMode.system);

  ///token and calls
  static TokenModel? lastCalledToken;
  static List<QueueModel> todaysQueue = [];
  static List<QueueModel> todaysQueueCancelled = [];
  static List<QueueModel> holdedQueue = [];

  static List<QueueAppointmentModel> todayAppointments = [];
  static List<QueueAppointmentModel> todayCancelledAppointments = [];

  static List<TokenModel> todayCalledTokens = [];
  static List<TokenModel> todayCalledNotTransferred = [];
  static List<TokenModel> todayCalledNoShow = [];
  static List<TokenModel> todayCalledHolded = [];

  static Future<void> initVals() async {
    await _getThemeModeData();
    await initServiceAndCounterData();
    await _getTabDetailsFromStorage();
    await resetIndex();
    await getLastToken();
    await getTodayTokenDetails();
    await SocketService().initliseSocket();
    await SocketService.registerEvents(isAll: true);
  }

  static Future<void> _getThemeModeData() async {
    themeModeVar = ThemeModeModel.fromJson(json
        .decode(await StorageService.getSavedValue(key: 'themeMode') ?? "{}"));
  }

  static List<ServiceCounterTabModel> getTabs() {
    return _allServiceCounterTabs;
  }

  static StreamController<bool> reloadingDataController =
      StreamController<bool>.broadcast();

  static List<ServiceModel> getActiveServices() {
    return activeServices;
  }

  static Future<void> updateValsFromStorage() async {
    await _getTabDetailsFromStorage();
  }

  static List<CounterModel> getActiveCounters() {
    return activeCounters;
  }

  static Future<void> createNewServiceAndCounterTab({
    required List<ServiceModel> services,
    required CounterModel counter,
  }) async {
    String counterString = counter.name;
    String servicesString = services
        .map<String?>((service) {
          String? ser;
          try {
            ser = service.name;
          } catch (e) {
            ser = null;
          }
          return ser;
        })
        .toList()
        .where((element) => (element != null))
        .toList()
        .join(', ');
    int lengthOfArray = _allServiceCounterTabs.length;
    ServiceCounterTabModel newTab = ServiceCounterTabModel(
      services: services,
      counter: counter,
      counterSettings: CounterSettingsModel.generateDefaultSettings(),
      selected: _allServiceCounterTabs.isEmpty ? true : false,
      serviceString: servicesString,
      counterString: counterString,
    );
    _allServiceCounterTabs.add(newTab);
    if (_allServiceCounterTabs.length == 1) {
      currentServiceCounterTabIndex = 0;
      currentServiceCounterTab = _allServiceCounterTabs[0];
      await CounterSettingService.updateCounterSettings();
    }

    await _saveTabDetailsToStorage();
    await selectThisTab(
        index: lengthOfArray >= 0 ? lengthOfArray : 0, thisTab: newTab);
  }

  static Future<void> selectThisTab({
    required int index,
    required ServiceCounterTabModel thisTab,
    bool switchToSameTab = false,
  }) async {
    int currentIndex =
        _allServiceCounterTabs.indexWhere((element) => element.selected);

    if (currentIndex >= 0) {
      _allServiceCounterTabs[currentIndex] = ServiceCounterTabModel(
        services: _allServiceCounterTabs[currentIndex].services,
        counter: _allServiceCounterTabs[currentIndex].counter,
        counterSettings: _allServiceCounterTabs[currentIndex].counterSettings,
        selected: false,
        serviceString: _allServiceCounterTabs[currentIndex]
            .serviceString
            .replaceAll("*", ""),
        counterString: _allServiceCounterTabs[currentIndex].counterString,
      );
    }

    ServiceCounterTabModel tab = await checkTabValidity(thisTab: thisTab);

    ///refactor with new values;
    _allServiceCounterTabs[index] = tab;

    currentServiceCounterTabIndex = index;
    currentServiceCounterTab = ServiceCounterTabModel(
      services: tab.services,
      counter: tab.counter,
      counterSettings: tab.counterSettings,
      selected: true,
      serviceString: tab.serviceString,
      counterString: tab.counterString,
    );
    _allServiceCounterTabs[index] = currentServiceCounterTab!;
    await _saveTabDetailsToStorage();
    await CounterSettingService.updateCounterSettings();
    await getLastToken();
    await getTodayTokenDetails();
    await reloadData();
  }

  static Future<void> _saveTabDetailsToStorage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    var _json =
        json.encode(_allServiceCounterTabs.map((e) => e.toJson()).toList());
    await StorageService.saveValue(key: 'allServiceCounterTabs', value: _json);
  }

  static Future<ServiceCounterTabModel> checkTabValidity(
      {required ServiceCounterTabModel thisTab}) async {
    List<int> availableServices = activeServices.map((e) => e.id).toList();
    List<ServiceModel> newTabServices = [];
    for (var item in thisTab.services) {
      if (availableServices.contains(item.id)) {
        newTabServices
            .add(activeServices.firstWhere((element) => element.id == item.id));
      }
    }
    ServiceCounterTabModel newTab = ServiceCounterTabModel(
      services: newTabServices,
      counter: thisTab.counter,
      counterSettings: thisTab.counterSettings,
      selected: thisTab.selected,
      serviceString: newTabServices
          .map<String?>((service) {
            String? ser;
            try {
              ser = service.name;
            } catch (e) {
              ser = null;
            }
            return ser;
          })
          .toList()
          .where((element) => (element != null))
          .toList()
          .join(', '),
      counterString: thisTab.counterString,
    );
    return newTab;
  }

  static Future<bool> initServiceAndCounterData() async {
    activeServices.clear();
    activeCounters.clear();
    String path = 'get/call/page';
    var response = await NetworkingService.getHttp(path);
    if (response is Response &&
        response.statusCode == 200 &&
        response.data['data'] != null) {
      var services =
          ServiceEntity.fromJsonList(response.data['data']['services']);
      for (var service in services) {
        if (service.status) {
          activeServices.add(ServiceModel.fromEntity(service));
        }
      }
      var counters =
          CounterEntity.fromJsonList(response.data['data']['counters']);
      for (var counter in counters) {
        if (counter.status) {
          activeCounters.add(CounterModel.fromEntity(counter));
        }
      }
      return true;
    }
    return false;
  }

  static Future<void> deleteServiceTab({required int index}) async {
    _allServiceCounterTabs.removeAt(index);
    await _saveTabDetailsToStorage();
    await initVals();
    // await SetDeviceService.addCounterAppDetails();
    // await SocketService.leaveOnly();
  }

  static Future<void> _getTabDetailsFromStorage() async {
    var counterTabsString =
        await StorageService.getSavedValue(key: 'allServiceCounterTabs');
    if (counterTabsString != null) {
      _allServiceCounterTabs.clear();
      // ignore: no_leading_underscores_for_local_identifiers
      for (var _item in json.decode(counterTabsString)) {
        var tab =
            ServiceCounterTabModel.fromJson(_item as Map<String, dynamic>);
        _allServiceCounterTabs.add(tab);
        if (tab.selected) {
          currentServiceCounterTab = tab;
        }
        currentServiceCounterTabIndex = _allServiceCounterTabs
                    .indexWhere((element) => element.selected) >=
                0
            ? _allServiceCounterTabs.indexWhere((element) => element.selected)
            : 0;
      }
      await CounterSettingService.updateCounterSettings();
    }
  }

  static Future<void> resetIndex() async {
    currentServiceCounterTabIndex = 0;
    if (_allServiceCounterTabs.isNotEmpty &&
        _allServiceCounterTabs
            .asMap()
            .containsKey(currentServiceCounterTabIndex)) {
      await selectThisTab(
        index: 0,
        thisTab: _allServiceCounterTabs[currentServiceCounterTabIndex],
        switchToSameTab: true,
      );
    }
  }

  static Future<dynamic> getLastToken({TokenModel? tokenModel}) async {
    ///if token model is not null the it will update last token value to passed value

    lastCalledToken = null;
    if (tokenModel != null) {
      lastCalledToken = tokenModel;
      return true;
    } else {
      if (_allServiceCounterTabs.isNotEmpty &&
          _allServiceCounterTabs
              .asMap()
              .containsKey(currentServiceCounterTabIndex)) {
        const String path = 'call/get/last_token';
        var response = await NetworkingService.postHttp(path: path, data: {
          'counter':
              _allServiceCounterTabs[currentServiceCounterTabIndex].counter.id,
          'services': _allServiceCounterTabs[currentServiceCounterTabIndex]
              .services
              .map((e) => e.id)
              .toList(),
        });
        if (response is Response && response.statusCode == 200) {
          if (response.data['data'] != null) {
            TokenModel lastCalledToken = TokenModel.fromEntity(
                TokenEntity.fromJson(response.data['data']));
            lastCalledToken = lastCalledToken;
          }
        }
      }
      return false;
    }
  }

static Future<dynamic> lockService(Map<String, dynamic> data) async {
    final String path = "service/hold/${data['service']}";
    var response = await NetworkingService.postHttp(path: path, data: data);
    if (response is Response &&
        response.statusCode == 200 &&
        response.data['status']) {
      ServiceModel holdedService = ServiceModel.fromEntity(
          ServiceEntity.fromJson(response.data['data']));
      int exisitngIndex = activeServices
          .indexWhere((element) => element.id == holdedService.id);
      if (exisitngIndex >= 0) {
        activeServices[exisitngIndex] = holdedService;
        ServiceCounterTabModel tab = await checkTabValidity(
            thisTab: _allServiceCounterTabs[currentServiceCounterTabIndex]);
        _allServiceCounterTabs[currentServiceCounterTabIndex] = tab;
        return true;
      }
    }
    return false;
  }

  static Future<dynamic> unlockService(Map<String, dynamic> data) async {
    final String path = "service/unhold/${data['service']}";
    var response = await NetworkingService.postHttp(path: path, data: data);
    if (response is Response &&
        response.statusCode == 200 &&
        response.data['status']) {
      ServiceModel holdedService = ServiceModel.fromEntity(
          ServiceEntity.fromJson(response.data['data']));
      int exisitngIndex = activeServices
          .indexWhere((element) => element.id == holdedService.id);
      if (exisitngIndex >= 0) {
        activeServices[exisitngIndex] = holdedService;
        ServiceCounterTabModel tab = await checkTabValidity(
            thisTab: _allServiceCounterTabs[currentServiceCounterTabIndex]);
        _allServiceCounterTabs[currentServiceCounterTabIndex] = tab;
        return true;
      }
    }
    return false;
  }


  static Future<bool> getTodayTokenDetails() async {
    String path = 'call/today-token-details';
    if (_allServiceCounterTabs.isNotEmpty &&
        _allServiceCounterTabs
            .asMap()
            .containsKey(currentServiceCounterTabIndex)) {
      var response = await NetworkingService.postHttp(path: path, data: {
        'counter':
            _allServiceCounterTabs[currentServiceCounterTabIndex].counter.id,
        'services': _allServiceCounterTabs[currentServiceCounterTabIndex]
            .services
            .map((e) => e.id)
            .toList(),
      });
      if (response is Response && response.statusCode == 200) {
        TodayTokenDetailsModel todayTokenDetails =
            TodayTokenDetailsModel.fromEntity(
          TodayTokenDetailsEntity.fromJson(response.data['data']),
        );

        todaysQueue.clear();
        todayCalledTokens.clear();
        todayCalledNotTransferred.clear();
        todayCalledNoShow.clear();
        todayCalledHolded.clear();
        todaysQueueCancelled.clear();
        holdedQueue.clear();
        todayAppointments.clear();
        todayCancelledAppointments.clear();

        if (todayTokenDetails.todaysQueue is List &&
            todayTokenDetails.todaysQueue.isNotEmpty) {
          for (var queue in todayTokenDetails.todaysQueue) {
            QueueModel tQueue =
                QueueModel.fromEntity(QueueEntity.fromJson(queue));
            todaysQueue.add(tQueue);
          }
        }

        if (todayTokenDetails.todaysCalledTokens is List &&
            todayTokenDetails.todaysCalledTokens.isNotEmpty) {
          for (var token in todayTokenDetails.todaysCalledTokens) {
            TokenModel calledToken =
                TokenModel.fromEntity(TokenEntity.fromJson(token));
            todayCalledTokens.add(calledToken);
            if (((calledToken.queueId != null &&
                        calledToken.queue['is_transferred'] != true) ||
                    (calledToken.queueppointmentId != null &&
                        calledToken.queueppointment['is_transferred'] !=
                            true)) &&
                (calledToken.status != "no-show" &&
                    calledToken.isHold != true)) {
              todayCalledNotTransferred.add(calledToken);
            } else if (calledToken.status == "no-show" &&
                calledToken.isHold != true) {
              todayCalledNoShow.add(calledToken);
            }
          }
        }

        if (todayTokenDetails.holdedServingTokens is List &&
            todayTokenDetails.holdedServingTokens.isNotEmpty) {
          for (var token in todayTokenDetails.holdedServingTokens) {
            TokenModel calledToken =
                TokenModel.fromEntity(TokenEntity.fromJson(token));
            if (calledToken.isHold == true) {
              todayCalledHolded.add(calledToken);
            }
          }
        }

        if (todayTokenDetails.todaysCancelled is List &&
            todayTokenDetails.todaysCancelled.isNotEmpty) {
          for (var cancelledQueue in todayTokenDetails.todaysCancelled) {
            QueueModel tQueue =
                QueueModel.fromEntity(QueueEntity.fromJson(cancelledQueue));
            todaysQueueCancelled.add(tQueue);
          }
        }

        if (todayTokenDetails.holdedTokens is List &&
            todayTokenDetails.holdedTokens.isNotEmpty) {
          for (var queue in todayTokenDetails.holdedTokens) {
            QueueModel tQueue =
                QueueModel.fromEntity(QueueEntity.fromJson(queue));
            holdedQueue.add(tQueue);
          }
        }

        if (todayTokenDetails.todaysAppointments is List &&
            todayTokenDetails.todaysAppointments.isNotEmpty) {
          for (var appoint in todayTokenDetails.todaysAppointments) {
            QueueAppointmentModel appointment =
                QueueAppointmentModel.fromEntity(
                    QueueAppointmentEntity.fromJson(appoint));
            todayAppointments.add(appointment);
          }
        }

        if (todayTokenDetails.cancelledAppointments is List &&
            todayTokenDetails.cancelledAppointments.isNotEmpty) {
          for (var cancelled in todayTokenDetails.cancelledAppointments) {
            QueueAppointmentModel appointment =
                QueueAppointmentModel.fromEntity(
                    QueueAppointmentEntity.fromJson(cancelled));
            todayCancelledAppointments.add(appointment);
          }
        }

        return true;
      }
    }
    return false;
  }

  static Future<Map<String, dynamic>> checkTabAlreadyFound({
    required List<ServiceModel> services,
    required CounterModel counter,
  }) async {
    List selectedServices = services.map((e) => e.id).toList();
    selectedServices.sort();
    int index = _allServiceCounterTabs.indexWhere((element) {
      List currentElementServices = element.services.map((e) => e.id).toList();
      currentElementServices.sort();
      return listEquals(currentElementServices, selectedServices);
    });
    if (index >= 0 && _allServiceCounterTabs[index].counter.id == counter.id) {
      return {'status': true, 'index': index};
    }
    return {'status': false, 'index': -1};
  }

  static Future<void> updateTab({
    required List<ServiceModel> services,
    required CounterModel counter,
    CounterSettingsModel? settings,
    int? index,
    bool updateData = true,
  }) async {
    index ??= currentServiceCounterTabIndex;
    _allServiceCounterTabs[index] = ServiceCounterTabModel(
      services: services,
      counter: counter,
      selected: index == currentServiceCounterTabIndex ? true : false,
      counterSettings:
          settings ?? _allServiceCounterTabs[index].counterSettings,
      serviceString: services
          .map<String?>((service) {
            String? ser;
            try {
              ser = service.name;
            } catch (e) {
              ser = null;
            }
            return ser;
          })
          .toList()
          .where((element) => (element != null))
          .toList()
          .join(', '),
      counterString: counter.name,
    );
    if (index == currentServiceCounterTabIndex) {
      currentServiceCounterTab = _allServiceCounterTabs[index];
    }
    await _saveTabDetailsToStorage();

    if (updateData) {
      await SetDeviceService.addCounterAppDetails();
      await getLastToken();
      await getTodayTokenDetails();
    }
    // await SocketService.connectAfterSwitch();
  }

  static Future<void> reloadData({bool sendEvents = false}) async {
    if (sendEvents == true) {
      reloadingDataController.add(true);
    }

    await initServiceAndCounterData();
    await getLastToken();
    await getTodayTokenDetails();

    if (sendEvents == true) {
      reloadingDataController.add(false);
    }
  }

  static Future<void> queueHolded(QueueModel queue) async {
    int index = todaysQueue.indexWhere((element) => element.id == queue.id);
    if (index >= 0) {
      todaysQueue.removeAt(index);
    }
    int indexOfHolded =
        holdedQueue.indexWhere((element) => element.id == queue.id);
    if (indexOfHolded < 0) {
      holdedQueue.add(queue);
    }
  }

  static Future<void> updateTodayCalledTokens(TokenModel token) async {
    int index =
        todayCalledTokens.indexWhere((element) => element.id == token.id);
    if (index >= 0) {
      todayCalledTokens[index] = token;
    }
  }

  static Future<void> updateChangeInTab(int serviceId) async {
    for (var i = 0; i < _allServiceCounterTabs.length; i++) {
      ServiceCounterTabModel currentTab = _allServiceCounterTabs[i];
      if (!currentTab.selected &&
          currentTab.services.map((e) => e.id).toList().contains(serviceId)) {
        String title = currentTab.serviceString.replaceAll("*", "");
        ServiceCounterTabModel newTab = ServiceCounterTabModel(
          services: currentTab.services,
          counter: currentTab.counter,
          counterSettings: currentTab.counterSettings,
          selected: currentTab.selected,
          serviceString: "* $title",
          counterString: currentTab.counterString,
        );
        _allServiceCounterTabs[i] = newTab;
      }
    }
  }

  static Future<void> queueCancelled(QueueModel queue) async {
    try {
      todaysQueue.removeAt(
          todaysQueue.indexWhere((element) => element.id == queue.id));
    } catch (_) {}
    try {
      todaysQueueCancelled.removeAt(
          todaysQueueCancelled.indexWhere((element) => element.id == queue.id));
    } catch (_) {}

    try {
      holdedQueue.removeAt(
          holdedQueue.indexWhere((element) => element.id == queue.id));
    } catch (_) {}
    todaysQueueCancelled.add(queue);
  }

  static Future<void> updateTransferTokenDetails(TokenModel token,
      {Map<String, dynamic>? transferTO}) async {
    if (transferTO != null) {
      Map<String, dynamic> queueData = {};
      if (token.queueId != null) {
        queueData = token.queue!;
        queueData['transfer_to'] = transferTO;
      } else if (token.queueppointmentId != null) {
        queueData = token.queueppointment;
        queueData['transfer_to'] = transferTO;
      }

      TokenModel updateToken = TokenModel(
        counterppDeviceUserId: token.counterppDeviceUserId,
        counterId: token.counterId,
        id: token.id,
        isHold: token.isHold,
        now: token.now,
        queue: token.queueId != null ? queueData : null,
        queueppointment: token.queueppointmentId != null ? queueData : null,
        queueppointmentId: token.queueppointmentId,
        queueId: token.queueId,
        referenceId: token.referenceId,
        reportReady: token.reportReady,
        reportReadyt: token.reportReadyt,
        reportReadyTime: token.reportReadyTime,
        servedTime: token.servedTime,
        serviceId: token.serviceId,
        startedAt: token.startedAt,
        endedAt: token.endedAt,
        status: token.status,
        statusColor: token.statusColor,
        token: token.token,
        tokenNumber: token.tokenNumber,
        turnroundTime: token.turnroundTime,
        userId: token.userId,
        updatedt: token.updatedt,
        voiceNumber: token.voiceNumber,
        waitingTime: token.waitingTime,
        user: token.user,
      );
      await updateTokenDetails(updateToken);
      return;
    }
    await updateTokenDetails(token);
    return;
  }

  static Future<void> updateTokenDetails(TokenModel token) async {
    int index =
        todayCalledTokens.indexWhere((element) => element.id == token.id);
    if (index >= 0) {
      todayCalledTokens[index] = token;
    }
    if (lastCalledToken?.id == token.id) {
      lastCalledToken = token;
    }
  }

  static Future<void> updateServiceDetails(ServiceModel service) async {
    int index =
        activeServices.indexWhere((element) => element.id == service.id);
    if (index >= 0) {
      activeServices[index] = service;
      await selectThisTab(
        index: currentServiceCounterTabIndex,
        thisTab: _allServiceCounterTabs[currentServiceCounterTabIndex],
        switchToSameTab: true,
      );
    }
  }
}
