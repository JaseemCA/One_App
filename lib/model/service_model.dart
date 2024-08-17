import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/service_entity.dart';


class ServiceModel extends Equatable {
  final int id;
  final int serviceId;
  final String name;
  final String type;
  final bool tokenConfirm;
  final bool print;
  final bool status;
  final int? departmentId;
  final int? mainServiceId;
  final String displayName;
  final String color;
  final bool askNameForWalkin;
  final bool nameIsRequiredForWalkin;
  final bool askEmailForWalkin;
  final bool emailIsRequiredForWalkin;
  final bool askNameForAppt;
  final bool nameIsRequiredForAppt;
  final bool askEmailForAppt;
  final bool emailIsRequiredForAppt;
  final dynamic walkinDetails;
  final dynamic appointmentDetails;
  final bool isHold;
  const ServiceModel({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.type,
    required this.color,
    required this.tokenConfirm,
    required this.print,
    required this.status,
    required this.departmentId,
    required this.mainServiceId,
    required this.displayName,
    required this.askNameForWalkin,
    required this.nameIsRequiredForWalkin,
    required this.askEmailForWalkin,
    required this.emailIsRequiredForWalkin,
    required this.askNameForAppt,
    required this.nameIsRequiredForAppt,
    required this.askEmailForAppt,
    required this.emailIsRequiredForAppt,
    required this.walkinDetails,
    required this.appointmentDetails,
    required this.isHold,
  });

  @override
  List<Object?> get props => [
        id,
        serviceId,
        name,
        type,
        color,
        tokenConfirm,
        print,
        status,
        departmentId,
        mainServiceId,
        displayName,
        askNameForWalkin,
        nameIsRequiredForWalkin,
        askEmailForWalkin,
        emailIsRequiredForWalkin,
        askNameForAppt,
        nameIsRequiredForAppt,
        askEmailForAppt,
        emailIsRequiredForAppt,
        walkinDetails,
        appointmentDetails,
        isHold,
      ];
  static ServiceModel fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      serviceId: entity.serviceId,
      name: entity.name,
      type: entity.type,
      color: entity.color,
      tokenConfirm: entity.tokenConfirm,
      print: entity.print,
      status: entity.status,
      departmentId: entity.departmentId,
      mainServiceId: entity.mainServiceId,
      displayName: entity.displayName,
      askNameForWalkin: entity.askNameForWalkin,
      nameIsRequiredForWalkin: entity.nameIsRequiredForWalkin,
      askEmailForWalkin: entity.askEmailForWalkin,
      emailIsRequiredForWalkin: entity.emailIsRequiredForWalkin,
      askNameForAppt: entity.askNameForAppt,
      nameIsRequiredForAppt: entity.nameIsRequiredForAppt,
      askEmailForAppt: entity.askEmailForAppt,
      emailIsRequiredForAppt: entity.emailIsRequiredForAppt,
      walkinDetails: entity.walkinDetails,
      appointmentDetails: entity.appointmentDetails,
      isHold: entity.isHold,
    );
  }

  static ServiceModel fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      serviceId: json['serviceId'],
      name: json['name'],
      type: json['type'],
      color: json['color'],
      tokenConfirm: json['tokenConfirm'],
      print: json['print'],
      status: json['status'],
      departmentId: json['departmentId'],
      mainServiceId: json['mainServiceId'],
      displayName: json['displayName'],
      askNameForWalkin: json['askNameForWalkin'],
      nameIsRequiredForWalkin: json['nameIsRequiredForWalkin'],
      askEmailForWalkin: json['askEmailForWalkin'],
      emailIsRequiredForWalkin: json['emailIsRequiredForWalkin'],
      askNameForAppt: json['askNameForAppt'],
      nameIsRequiredForAppt: json['nameIsRequiredForAppt'],
      askEmailForAppt: json['askEmailForAppt'],
      emailIsRequiredForAppt: json['emailIsRequiredForAppt'],
      walkinDetails: json['walkinDetails'],
      appointmentDetails: json['appointment_details'],
      isHold: json['isHold'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'name': name,
      'type': type,
      'color': color,
      'tokenConfirm': tokenConfirm,
      'print': print,
      'status': status,
      'departmentId': departmentId,
      'mainServiceId': mainServiceId,
      'displayName': displayName,
      'askNameForWalkin': askNameForWalkin,
      'nameIsRequiredForWalkin': nameIsRequiredForWalkin,
      'askEmailForWalkin': askEmailForWalkin,
      'emailIsRequiredForWalkin': emailIsRequiredForWalkin,
      'askNameForAppt': askNameForAppt,
      'nameIsRequiredForAppt': nameIsRequiredForAppt,
      'askEmailForAppt': askEmailForAppt,
      'emailIsRequiredForAppt': emailIsRequiredForAppt,
      'walkinDetails': walkinDetails,
      'appointmentDetails': appointmentDetails,
      'isHold': isHold,
    };
  }
}
