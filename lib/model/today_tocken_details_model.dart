import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/today_tocken_details_entity.dart';

class TodayTokenDetailsModel extends Equatable {
  final dynamic cancelledAppointments;
  final dynamic holdedServingTokens;
  final dynamic holdedTokens;
  final dynamic lastCalledToken;
  final dynamic todaysAppointments;
  final dynamic todaysCalledTokens;
  final dynamic todaysCancelled;
  final dynamic todaysQueue;

  const TodayTokenDetailsModel({
    required this.cancelledAppointments,
    required this.holdedServingTokens,
    required this.holdedTokens,
    required this.lastCalledToken,
    required this.todaysAppointments,
    required this.todaysCalledTokens,
    required this.todaysCancelled,
    required this.todaysQueue,
  });

  static TodayTokenDetailsModel fromEntity(TodayTokenDetailsEntity entity) {
    return TodayTokenDetailsModel(
      cancelledAppointments: entity.cancelledAppointments,
      holdedServingTokens: entity.holdedServingTokens,
      holdedTokens: entity.holdedTokens,
      lastCalledToken: entity.lastCalledToken,
      todaysAppointments: entity.todaysAppointments,
      todaysCalledTokens: entity.todaysCalledTokens,
      todaysCancelled: entity.todaysCancelled,
      todaysQueue: entity.todaysQueue,
    );
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
