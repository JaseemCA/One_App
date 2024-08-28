import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:oneappcounter/entity/countersetting_entity.dart';
import 'package:oneappcounter/model/counter_settings_model.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/local_notification_service.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/services/set_device_service.dart';
import 'package:oneappcounter/services/storage_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:wakelock/wakelock.dart';

class CounterSettingService {
  static CounterSettingsModel? counterSettings;
  static bool fullScreenEnabled = false;

  static Future<Map<String, dynamic>> initSettingsData() async {
    var data = await StorageService.getSavedValue(key: 'counter_settings');
    Map<String, dynamic> val;
    if (data == null) {
      var defaultSettings = CounterSettingsModel.generateDefaultSettings();
      data = json.encode(defaultSettings.toJson());
      await StorageService.saveValue(key: 'counter_settings', value: data);
    }
    val = json.decode(data);
    counterSettings = CounterSettingsModel.fromJson(val);
    await applyCurrentSettings();
    return val;
  }

  static Future<bool> updateSettingsLocaly(
      Map<String, dynamic> currentSettingsJson,
      {bool callAPi = true}) async {
    await StorageService.saveValue(
      key: 'counter_settings',
      value: json.encode(currentSettingsJson),
    );

    await initSettingsData();

    await GeneralDataService.updateTab(
      services: GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .services,
      counter: GeneralDataService.getTabs()[
              GeneralDataService.currentServiceCounterTabIndex]
          .counter,
      index: GeneralDataService.currentServiceCounterTabIndex,
      settings: counterSettings,
      updateData: callAPi,
    );
    if (callAPi) {
      await SetDeviceService.addCounterAppDetails();
    }

    return true;
  }

  static Future<void> updateCounterSettings() async {
    counterSettings = GeneralDataService.getTabs().isNotEmpty &&
            GeneralDataService.getTabs()
                .asMap()
                .containsKey(GeneralDataService.currentServiceCounterTabIndex)
        ? GeneralDataService.getTabs()[
                GeneralDataService.currentServiceCounterTabIndex]
            .counterSettings
        : null;
    if (counterSettings != null) {
      await StorageService.saveValue(
        key: 'counter_settings',
        value: json.encode(counterSettings!.toJson()),
      );
    }
  }

  static Future<void> clearSettingsData() async {
    await StorageService.removedSavedValue(key: 'counter_settings');
  }

  static Future<dynamic> updateCounterWithUid({required int uid}) async {
    final String path = "counter/counter-settings/$uid";
    var response = await NetworkingService.getHttp(path);
    if (response is Response &&
        response.statusCode == 200 &&
        response.data['status']) {
      CounterSettingsModel counterSettings = CounterSettingsModel.fromEntity(
          CounterSettingsEntity.fromJson(response.data['data']));
      await updateSettingsLocaly(counterSettings.toJson());
      return counterSettings;
    }
    return false;
  }

  static Future<void> applyCurrentSettings() async {
    if (counterSettings?.alwaysOnTop == true &&
        await getKioskMode() == KioskMode.disabled) {
      await startKioskMode();
    } else if (counterSettings?.alwaysOnTop != true) {
      // KioskMode.enabled or KioskMode.disabled
      if (await getKioskMode() == KioskMode.enabled) {
        await stopKioskMode();
      }
      LocalNotificationService().initNotificationSettings();
    }

    if (counterSettings?.enableFullScreen == true && !fullScreenEnabled) {
      fullScreenEnabled = true;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else if (counterSettings?.enableFullScreen != true) {
      fullScreenEnabled = false;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }

    if (counterSettings?.wakeLockEnabled == true) {
      WakelockPlus.enable();
    } else if (counterSettings?.wakeLockEnabled != true) {
      WakelockPlus.disable();
    }
  }
}
