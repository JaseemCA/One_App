import 'package:equatable/equatable.dart';

import 'package:oneappcounter/entity/device_entity.dart';

class DeviceModel extends Equatable {
  final int deviceId;
  final String deviceUid;
  final int deviceUserId;
  final dynamic device;

  const DeviceModel({
    required this.deviceId,
    required this.deviceUid,
    required this.deviceUserId,
    required this.device,
  });

  static DeviceModel fromEntity(DeviceEntity entity) {
    return DeviceModel(
      deviceId: entity.deviceId,
      deviceUid: entity.deviceUid,
      deviceUserId: entity.deviceUserId,
      device: entity.device,
    );
  }

  static DeviceModel fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceId'],
      deviceUid: json['deviceUid'],
      deviceUserId: json['deviceUserId'],
      device: json['device'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceUid': deviceUid,
      'deviceUserId': deviceUserId,
      'device': device,
    };
  }

  @override
  List<Object?> get props => [
        deviceId,
        deviceUid,
        deviceUserId,
        device,
      ];
}
