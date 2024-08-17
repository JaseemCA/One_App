import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:oneappcounter/entity/tocken_entity.dart';

class TokenModel extends Equatable {
  final int? counterppDeviceUserId;
  final int counterId;
  final int id;
  final bool isHold;
  final String now;
  final dynamic queue;
  final dynamic queueppointment;
  final int? queueppointmentId;
  final int? queueId;
  final String referenceId;
  final dynamic reportReady;
  final dynamic reportReadyt;
  final dynamic reportReadyTime;
  final String servedTime;
  final int serviceId;
  final String startedAt;
  final String endedAt;
  final String status;
  final Color statusColor;
  final dynamic token;
  final String tokenNumber;
  final String turnroundTime;
  final dynamic user;
  final int userId;
  final String updatedt;
  final String voiceNumber;
  final String waitingTime;

  const TokenModel({
    required this.counterppDeviceUserId,
    required this.counterId,
    required this.id,
    required this.isHold,
    required this.now,
    required this.queue,
    required this.queueppointment,
    required this.queueppointmentId,
    required this.queueId,
    required this.referenceId,
    required this.reportReady,
    required this.reportReadyt,
    required this.reportReadyTime,
    required this.servedTime,
    required this.serviceId,
    required this.startedAt,
    required this.endedAt,
    required this.status,
    required this.statusColor,
    required this.token,
    required this.tokenNumber,
    required this.turnroundTime,
    required this.user,
    required this.userId,
    required this.updatedt,
    required this.voiceNumber,
    required this.waitingTime,
  });
  static TokenModel fromEntity(TokenEntity entity) {
    return TokenModel(
      counterppDeviceUserId: entity.counterppDeviceUserId,
      counterId: entity.counterId,
      id: entity.id,
      isHold: entity.isHold,
      now: entity.now,
      queue: entity.queue,
      queueppointment: entity.queueppointment,
      queueppointmentId: entity.queueppointmentId,
      queueId: entity.queueId,
      referenceId: entity.referenceId,
      reportReady: entity.reportReady,
      reportReadyt: entity.reportReadyt,
      reportReadyTime: entity.reportReadyTime,
      servedTime: entity.servedTime,
      serviceId: entity.serviceId,
      startedAt: entity.startedAt,
      endedAt: entity.endedAt,
      status: entity.status,
      statusColor: entity.statusColor == 'green'
          ? Colors.green
          : entity.statusColor == 'orange'
              ? Colors.orange
              : Colors.red,
      token: entity.token,
      tokenNumber: entity.tokenNumber,
      turnroundTime: entity.turnroundTime,
      user: entity.user,
      userId: entity.userId,
      updatedt: entity.updatedt,
      voiceNumber: entity.voiceNumber,
      waitingTime: entity.waitingTime,
    );
  }

  static TokenModel fromJson(Map<String, dynamic> json) {
    return TokenModel(
      counterppDeviceUserId: json['counterppDeviceUserId'],
      counterId: json['counterId'],
      id: json['id'],
      isHold: json['isHold'],
      now: json['now'],
      queue: json['queue'],
      queueppointment: json['queueppointment'],
      queueppointmentId: json['queueppointmentId'],
      queueId: json['queueId'],
      referenceId: json['referenceId'],
      reportReady: json['reportReady'],
      reportReadyt: json['reportReadyt'],
      reportReadyTime: json['reportReadyTime'],
      servedTime: json['servedTime'],
      serviceId: json['serviceId'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      status: json['status'],
      statusColor: json['statusColor'] == 'green'
          ? Colors.green
          : json['statusColor'] == 'orange'
              ? Colors.orange
              : Colors.red,
      token: json['token'],
      tokenNumber: json['tokenNumber'],
      turnroundTime: json['turnroundTime'],
      user: json['user'],
      userId: json['userId'],
      updatedt: json['updatedt'],
      voiceNumber: json['voiceNumber'],
      waitingTime: json['waitingTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counterppDeviceUserId': counterppDeviceUserId,
      'counterId': counterId,
      'id': id,
      'isHold': isHold,
      'now': now,
      'queue': queue,
      'queueppointment': queueppointment,
      'queueppointmentId': queueppointmentId,
      'queueId': queueId,
      'referenceId': referenceId,
      'reportReady': reportReady,
      'reportReadyt': reportReadyt,
      'reportReadyTime': reportReadyTime,
      'servedTime': servedTime,
      'serviceId': serviceId,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'status': status,
      'statusColor': statusColor == Colors.green
          ? 'green'
          : statusColor == Colors.orange
              ? 'orange'
              : 'red',
      'token': token,
      'tokenNumber': tokenNumber,
      'turnroundTime': turnroundTime,
      'user': user,
      'userId': userId,
      'updatedt': updatedt,
      'voiceNumber': voiceNumber,
      'waitingTime': waitingTime,
    };
  }

  @override
  List<Object?> get props => [
        counterppDeviceUserId,
        counterId,
        id,
        isHold,
        now,
        queue,
        queueppointment,
        queueppointmentId,
        queueId,
        referenceId,
        reportReady,
        reportReadyt,
        reportReadyTime,
        servedTime,
        serviceId,
        startedAt,
        endedAt,
        status,
        statusColor,
        token,
        tokenNumber,
        turnroundTime,
        user,
        userId,
        updatedt,
        voiceNumber,
        waitingTime,
      ];
}
