import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  final int deviceId;
  final String deviceUid;
  final int deviceUserId;
  final dynamic device;

  const DeviceEntity(
    this.deviceId,
    this.deviceUid,
    this.deviceUserId,
    this.device,
  );

  static DeviceEntity fromJson(Map<String, dynamic> json) {
    return DeviceEntity(
      json['app_device']['id'],
      json['app_device']['device_uid'],
      json['device_user']['id'],
      json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_device': {
        'id': deviceId,
        'device_uid': deviceUid,
      },
      'device_user': {
        'id': deviceUserId,
      },
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
