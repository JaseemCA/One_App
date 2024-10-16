import 'package:equatable/equatable.dart';

class DeviceInfo extends Equatable {
  final String systemManufacturer;
  final String systemModel;
  final String systemSerial;
  final String systemUuid;
  final String biosVendor;
  final String biosVersion;
  final String? biosReleaseDate;
  final String baseboardManufacturer;
  final String baseboardModel;
  final String? baseboardSerial;
  final String chassisManufacturer;
  final String chassisModel;
  final String chassisType;
  final String? chassisSerial;
  final String osPlatform;
  final String osDistro;
  final String osRelease;
  final String osArch;
  final String? osHostname;
  final String? osBuild;
  final String? osKernel;
  final String osSerial;
  final String uuidOs;
  final String cpuManufacturer;
  final String cpuBrand;
  final String? cpuSpeed;
  final String cpuCores;
  final String? cpuPhysicalCores;
  final String cpuVendor;
  final String? cpuSocket;

  const DeviceInfo({
    required this.systemManufacturer,
    required this.systemModel,
    required this.systemSerial,
    required this.systemUuid,
    required this.biosVendor,
    required this.biosVersion,
    this.biosReleaseDate,
    required this.baseboardManufacturer,
    required this.baseboardModel,
    this.baseboardSerial,
    required this.chassisManufacturer,
    required this.chassisModel,
    required this.chassisType,
    this.chassisSerial,
    required this.osPlatform,
    required this.osDistro,
    required this.osRelease,
    required this.osArch,
    this.osHostname,
    this.osBuild,
    this.osKernel,
    required this.osSerial,
    required this.uuidOs,
    required this.cpuManufacturer,
    required this.cpuBrand,
    this.cpuSpeed,
    required this.cpuCores,
    this.cpuPhysicalCores,
    required this.cpuVendor,
    this.cpuSocket,
  });

  @override
  List<Object?> get props => [
        systemManufacturer,
        systemModel,
        systemSerial,
        systemUuid,
        biosVendor,
        biosVersion,
        biosReleaseDate,
        baseboardManufacturer,
        baseboardModel,
        baseboardSerial,
        chassisManufacturer,
        chassisModel,
        chassisType,
        chassisSerial,
        osPlatform,
        osDistro,
        osRelease,
        osArch,
        osHostname,
        osBuild,
        osKernel,
        osSerial,
        uuidOs,
        cpuManufacturer,
        cpuBrand,
        cpuSpeed,
        cpuCores,
        cpuPhysicalCores,
        cpuVendor,
        cpuSocket,
      ];

  Map<String, Object?> toJson() {
    return {
      'systemManufacturer': systemManufacturer,
      'systemModel': systemModel,
      'systemSerial': systemSerial,
      'systemUuid': systemUuid,
      'biosVendor': biosVendor,
      'biosVersion': biosVersion,
      'biosReleaseDate': biosReleaseDate,
      'baseboardManufacturer': baseboardManufacturer,
      'baseboardModel': baseboardModel,
      'baseboardSerial': baseboardSerial,
      'chassisManufacturer': chassisManufacturer,
      'chassisModel': chassisModel,
      'chassisType': chassisType,
      'chassisSerial': chassisSerial,
      'osPlatform': osPlatform,
      'osDistro': osDistro,
      'osRelease': osRelease,
      'osArch': osArch,
      'osHostname': osHostname,
      'osBuild': osBuild,
      'osKernal': osKernel,
      'osSerial': osSerial,
      'uuidOs': uuidOs,
      'cpuManufacturer': cpuManufacturer,
      'cpuBrand': cpuBrand,
      'cpuSpeed': cpuSpeed,
      'cpuCores': cpuCores,
      'cpuPhysicalCores': cpuPhysicalCores,
      'cpuVendor': cpuVendor,
      'cpuSocket': cpuSocket,
    };
  }

  static DeviceInfo fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      systemManufacturer: json['systemManufacturer'],
      systemModel: json['systemModel'],
      systemSerial: json['systemSerial'],
      systemUuid: json['systemUuid'],
      biosVendor: json['biosVendor'],
      biosVersion: json['biosVersion'],
      biosReleaseDate: json['biosReleaseDate'],
      baseboardManufacturer: json['baseboardManufacturer'],
      baseboardModel: json['baseboardModel'],
      baseboardSerial: json['baseboardSerial'],
      chassisManufacturer: json['chassisManufacturer'],
      chassisModel: json['chassisModel'],
      chassisType: json['chassisType'],
      chassisSerial: json['chassisSerial'],
      osPlatform: json['osPlatform'],
      osDistro: json['osDistro'],
      osRelease: json['osRelease'],
      osArch: json['osArch'],
      osHostname: json['osHostname'],
      osBuild: json['osBuild'],
      osKernel: json['osKernal'],
      osSerial: json['osSerial'],
      uuidOs: json['uuidOs'],
      cpuManufacturer: json['cpuManufacturer'],
      cpuBrand: json['cpuBrand'],
      cpuSpeed: json['cpuSpeed'],
      cpuCores: json['cpuCores'],
      cpuPhysicalCores: json['cpuPhysicalCores'],
      cpuVendor: json['cpuVendor'],
      cpuSocket: json['cpuSocket'],
    );
  }
}
