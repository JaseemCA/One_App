// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
// import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oneappcounter/model/formated_time.dart';
import 'package:oneappcounter/services/networking_service.dart';

class ClockService {
  static StreamController<FormattedTime> dateTimeController =
      StreamController<FormattedTime>.broadcast();
  static StreamController<String> lastStopWatchTimerController =
      StreamController<String>.broadcast();

  static StreamController<bool> dataResetAlertController =
      StreamController<bool>();

  static String? now;
  static String? dateFormat;
  static bool? timeFormat;
  static String? timeString;
  static DateTime? _time;
  static Timer? _timer;
  static bool _reseted = false;
  static Timer? _timerStopWatch;

  // Call this before any formatting
  static Future<void> initializeLocale() async {
    await initializeDateFormatting('en'); // <-- Initialize locale here
  }

  static Future<void> _emitTime() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      try {
        DateTime? _now = _time?.add(const Duration(seconds: 1));
        _time = _now;
        late String formattedTime;
        late FormattedTime formattedTimeModel;
        now = DateFormat('yyyy-M-dd H:m:s').format(_now!);
        if (timeFormat == true) {
          formattedTime = DateFormat?.jm().format(_now).trim();
          List times = formattedTime.split(':');
          formattedTimeModel = FormattedTime(
              hour: times[0],
              minutes: times[1],
              ticker: (timer.tick % 2) == 0 ? ':' : ' ',
              time: formattedTime);
          if (formattedTime == '12:10 AM') {
            if (!_reseted) {
              dataResetAlertController.add(true);
              _reseted = true;
            }
          } else {
            _reseted = false;
          }
        } else {
          formattedTime = DateFormat?.Hm().format(_now);
          List times = formattedTime.split(':');
          formattedTimeModel = FormattedTime(
              hour: times[0],
              minutes: times[1],
              ticker: (timer.tick % 2) == 0 ? ':' : ' ',
              time: formattedTime);
          if (formattedTime == '00:10') {
            if (!_reseted) {
              dataResetAlertController.add(true);
              _reseted = true;
            }
          } else {
            _reseted = false;
          }
        }
        dateTimeController.add(formattedTimeModel);
      } catch (_) {}
    });
  }

  static _cancelTimer() {
    try {
      _timer?.cancel();
    } catch (_) {}
  }

  static setThisTime(DateTime now) {
    timeString = now.toString();
    _time = now;
    _cancelTimer();
    _emitTime();
  }

  static DateTime time() {
    return _time ?? DateTime.now();
  }

  static Future<void> updateDateTime() async {
    // log("Updating date and time...");
    try {
      await initializeLocale();

      var response = await NetworkingService.getHttp('time');
      if (response is Response &&
          response.statusCode == 200 &&
          response.data != null) {
        now = response.data['now'];
        dateFormat = response.data['data']?['date_format_js'];
        timeFormat = response.data['data']?['time_format_js'];

        if (now != null) {
          // log("Parsed 'now': $now");
          setThisTime(Intl.withLocale(
            'en',
            () => DateFormat('yyyy-M-dd H:m:s').parse(now!),
          ));
        } else {
          // log("Error: 'now' is null in the API response.");
        }
      } else {
        // log("Error: Invalid response from NetworkingService.");
      }
    } catch (e) {
      // log("Error in updateDateTime: $e");
    }
  }

  static String getFlutterFormat() {
    String flutterFormat = '';
    if (dateFormat != null && dateFormat == 'yyyy-mm-dd') {
      flutterFormat = 'yyyy-MM-dd';
    } else if (dateFormat != null && dateFormat == 'mm-dd-yyyy') {
      flutterFormat = 'MM-dd-yyyy';
    } else if (dateFormat != null && dateFormat == 'dd-mm-yyyy') {
      flutterFormat = 'dd-MM-yyyy';
    } else if (dateFormat != null && dateFormat == 'dd mmm, yyyy') {
      flutterFormat = 'dd MMM, yyyy';
    } else if (dateFormat != null && dateFormat == 'dd mmmm, yyyy') {
      flutterFormat = 'dd MMMM, yyyy';
    } else if (dateFormat != null && dateFormat == 'mmm dd, yyyy') {
      flutterFormat = 'MMM dd, yyyy';
    } else if (dateFormat != null && dateFormat == 'mmmm dd, yyyy') {
      flutterFormat = 'MMMM dd, yyyy';
    }
    return flutterFormat;
  }

  static String formattedDate({
    String? date,
    String format = 'yyyy-M-dd H:m:s',
  }) {
    date = date ?? now;
    DateFormat parsableDateFormat = DateFormat(format);
    DateTime parsedDate = parsableDateFormat.parse(date!);
    DateFormat dateP = DateFormat(getFlutterFormat());
    String dateString = dateP.format(parsedDate);
    return dateString;
  }

  static String formattedTime({
    String? dateTime,
    String format = 'yyyy-M-dd H:m:s',
  }) {
    dateTime = dateTime ?? now;
    DateFormat parsableDateFormat = DateFormat(format);
    DateTime parsedDate = parsableDateFormat.parse(dateTime!);
    DateFormat dateP = timeFormat == true ? DateFormat.jm() : DateFormat.Hm();
    String dateString = dateP.format(parsedDate);
    return dateString;
  }

  static String getTimeDifference(
      {String? nowPassed, required String startedAt}) {
    var format = DateFormat('yyyy-M-dd H:m:s');

    return format
        .parse(nowPassed ?? now ?? DateTime.now().toString())
        .difference(format.parse(startedAt))
        .toString()
        .split('.')[0];
  }

  static Future<void> _emitStopwatchTimer({required String startedAt}) async {
    try {
      _timerStopWatch?.cancel();
    } catch (_) {}

    _timerStopWatch = Timer.periodic(const Duration(seconds: 1), (timer) {
      lastStopWatchTimerController.add(getTimeDifference(startedAt: startedAt));
    });
  }

  static String initaiateTimeDiffreneceEmitting({required String startedAt}) {
    _emitStopwatchTimer(startedAt: startedAt);
    return getTimeDifference(startedAt: startedAt);
  }
}
