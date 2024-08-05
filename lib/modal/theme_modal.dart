import 'package:flutter/material.dart';

class ThemeModeModel {
  final ThemeMode themeMode;
  const ThemeModeModel({required this.themeMode});

  static ThemeModeModel fromJson(Map<String, dynamic> json) {
    return ThemeModeModel(
      themeMode: json['themeMode'] != null && json['themeMode'] == 'light'
          ? ThemeMode.light
          : json['themeMode'] == 'dark'
              ? ThemeMode.dark
              : ThemeMode.system,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "themeMode": themeMode == ThemeMode.light
          ? 'light'
          : themeMode == ThemeMode.dark
              ? 'dark'
              : 'system',
    };
  }
}
