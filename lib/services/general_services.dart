import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oneappcounter/modal/theme_modal.dart';
import 'package:oneappcounter/services/storage_services.dart';

class GeneralDataService {
  static StreamController<bool> themeModeController =
      StreamController<bool>.broadcast();

  static ThemeModeModel themeModeVar =
      const ThemeModeModel(themeMode: ThemeMode.system);

  static Future<void> initVals() async {
    await _getThemeModeData();
  }

  static Future<void> themeModeUpdate(ThemeMode themeMode) async {
    themeModeVar = ThemeModeModel(themeMode: themeMode);
    await StorageService.saveValue(
        key: 'themeMode', value: json.encode(themeModeVar.toJson()));
    themeModeController.add(true);
  }

  static Future<void> _getThemeModeData() async {
    themeModeVar = ThemeModeModel.fromJson(json
        .decode(await StorageService.getSavedValue(key: 'themeMode') ?? "{}"));
  }
}
