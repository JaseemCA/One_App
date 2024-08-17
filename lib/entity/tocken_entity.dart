import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
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
  final bool? reportReady;
  final String? reportReadyt;
  final String? reportReadyTime;
  final String servedTime;
  final int serviceId;
  final String startedAt;
  final String endedAt;
  final String status;
  final String statusColor;
  final dynamic token;
  final String tokenNumber;
  final String turnroundTime;
  final dynamic user;
  final int userId;
  final String updatedt;
  final String voiceNumber;
  final String waitingTime;

  const TokenEntity(
    this.counterppDeviceUserId,
    this.counterId,
    this.id,
    this.isHold,
    this.now,
    this.queue,
    this.queueppointment,
    this.queueppointmentId,
    this.queueId,
    this.referenceId,
    this.reportReady,
    this.reportReadyt,
    this.reportReadyTime,
    this.servedTime,
    this.serviceId,
    this.startedAt,
    this.endedAt,
    this.status,
    this.statusColor,
    this.token,
    this.tokenNumber,
    this.turnroundTime,
    this.user,
    this.userId,
    this.updatedt,
    this.voiceNumber,
    this.waitingTime,
  );

  static TokenEntity fromJson(Map<String, dynamic> json) {
    return TokenEntity(
      json['counterpp_device_user_id'],
      json['counter_id'] ?? json['call']['counter_id'],
      json['id'],
      json['is_hold'] ?? false,
      json['now'],
      json['queue'],
      json['queue_appointment'],
      json['queue_appointment_id'],
      json['queue_id'],
      json['reference_id'] ?? json['call']['reference_id'],
      json['report_ready'],
      json['report_ready_at'],
      json['report_ready_time'],
      json['served_time'] ?? '',
      json['service_id'],
      json['started_at'] ?? '',
      json['ended_at'] ?? '',
      json['status'] is String
          ? json['status']
          : json['status'] == null
              ? json['is_hold'] == true
                  ? 'holded'
                  : 'serving'
              : '',
      json['status_color'] ?? '',
      json['token'],
      json['token_number'],
      json['turnround_time'] ?? '',
      json['user'],
      json['user_id'] ?? 1,
      json['updated_at'],
      json['voice_number'] ?? '',
      json['waiting_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counterpp_device_user_id': counterppDeviceUserId,
      'counter_id': counterId,
      'id': id,
      'is_hold': isHold,
      'now': now,
      'queue': queue,
      'queueppointment': queueppointment,
      'queueppointment_id': queueppointmentId,
      'queue_id': queueId,
      'reference_id': referenceId,
      'report_ready': reportReady,
      'report_ready_at': reportReadyt,
      'report_ready_time': reportReadyTime,
      'served_time': servedTime,
      'service_id': serviceId,
      'started_at': startedAt,
      'ended_at': endedAt,
      'status': status,
      'status_color': statusColor,
      'token': token,
      'token_number': tokenNumber,
      'turnround_time': turnroundTime,
      'user': user,
      'user_id': userId,
      'updated_at': updatedt,
      'voice_number': voiceNumber,
      'waiting_time': waitingTime,
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
