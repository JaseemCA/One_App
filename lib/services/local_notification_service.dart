import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oneappcounter/functions/general_functions.dart';

class LocalNotificationService {
  static bool notificationSoundPlaying = false;
  static final assetsAudioPlayer = AssetsAudioPlayer();
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  static String channelRandString = "";

  initNotificationSettings() async {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    channelRandString =
        List.generate(10, (index) => chars[rnd.nextInt(chars.length)])
            .join();
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required String message,
    required String title,
    required String service,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'oneapp_counter_$service:$channelRandString',
      'OneApp Counter Notification $service:$channelRandString',
      channelDescription:
          'Best counter solution for best queue management system',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: false,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().show(
      0,
      title,
      message,
      platformChannelSpecifics,
      payload: message,
    );
  }

  static Future<void> playNotificationSound() async {
    await waitWhile(() => notificationSoundPlaying);
    notificationSoundPlaying = true;
    assetsAudioPlayer
        .open(
          Audio("assets/sound/notification.mp3"),
          seek: Duration.zero,
        )
        .then((value) => notificationSoundPlaying = false);
  }
}
