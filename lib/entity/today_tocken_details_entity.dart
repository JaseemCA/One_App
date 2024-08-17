import 'package:equatable/equatable.dart';

class TodayTokenDetailsEntity extends Equatable {
  final dynamic cancelledAppointments;
  final dynamic holdedServingTokens;
  final dynamic holdedTokens;
  final dynamic lastCalledToken;
  final dynamic todaysAppointments;
  final dynamic todaysCalledTokens;
  final dynamic todaysCancelled;
  final dynamic todaysQueue;

  const TodayTokenDetailsEntity(
    this.cancelledAppointments,
    this.holdedServingTokens,
    this.holdedTokens,
    this.lastCalledToken,
    this.todaysAppointments,
    this.todaysCalledTokens,
    this.todaysCancelled,
    this.todaysQueue,
  );

  static TodayTokenDetailsEntity fromJson(Map<String, dynamic> json) {
    return TodayTokenDetailsEntity(
      json['cancelled_appointments'],
      json['holded_serving_tokens'],
      json['holded_tokens'],
      json['last_called_token'],
      json['todays_appointments'],
      json['todays_called_tokens'],
      json['todays_cancelled'],
      json['todays_queue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cancelled_appointments': cancelledAppointments,
      'holded_serving_tokens': holdedServingTokens,
      'holded_tokens': holdedTokens,
      'last_called_token': lastCalledToken,
      'todays_appointments': todaysAppointments,
      'todays_called_tokens': todaysCalledTokens,
      'todays_cancelled': todaysCancelled,
      'todays_queue': todaysQueue,
    };
  }

  @override
  List<Object?> get props => [
        cancelledAppointments,
        holdedServingTokens,
        holdedTokens,
        lastCalledToken,
        todaysAppointments,
        todaysCalledTokens,
        todaysCancelled,
        todaysQueue,
      ];
}
