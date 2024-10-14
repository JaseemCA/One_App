// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:oneappcounter/model/language_model.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';

class LanguageService {
  static String languageCode = "en";

  static List<LanguageModel> languageList = [
    const LanguageModel(
        id: 1, code: "en", name: "English", dir: "ltr", nativeName: "English"),
    const LanguageModel(
        id: 2, code: "ar", name: "Arabic", dir: "rtl", nativeName: "عربي"),
    const LanguageModel(
        id: 3, code: "fr", name: "French", dir: "ltr", nativeName: "Français"),
    const LanguageModel(
        id: 4, code: "ml", name: "Malayalam", dir: "ltr", nativeName: "മലയാളം"),
    const LanguageModel(
        id: 5,
        code: "pt",
        name: "Portuguese",
        dir: "ltr",
        nativeName: "Português"),
  ];

  static Future<void> changeLocaleFn(BuildContext context) async {
    languageCode = CounterSettingService.counterSettings?.language != null &&
            CounterSettingService.counterSettings?.language.isNotEmpty
        ? CounterSettingService.counterSettings?.language[0]['code']
        : AuthService.loginData?.systemBranch['language'] != null
            ? AuthService.loginData?.systemBranch['language']['code'] ?? 'en'
            : 'en';
    try {
      await changeLocale(
        context,
        languageCode,
      );
    } catch (_) {
      await changeLocale(context, 'en');
    }
  }

  static LanguageModel getCurrentLanguage() {
    return languageList.firstWhere((element) => element.code == languageCode);
  }
}
