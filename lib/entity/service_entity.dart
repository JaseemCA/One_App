import 'package:equatable/equatable.dart';
import '../services/language_service.dart';

class ServiceEntity extends Equatable {
  final int id;
  final int serviceId;
  final String name;
  final String type;
  final String color;
  final bool tokenConfirm;
  final bool print;
  final bool status;
  final int? departmentId;
  final int? mainServiceId;
  final String displayName;
  final bool askNameForWalkin;
  final bool nameIsRequiredForWalkin;
  final bool askEmailForWalkin;
  final bool emailIsRequiredForWalkin;
  final bool askNameForAppt;
  final bool nameIsRequiredForAppt;
  final bool askEmailForAppt;
  final bool emailIsRequiredForAppt;
  final dynamic appointmentDetails;
  final dynamic walkinDetails;
  final bool isHold;
  final String? remarks;

  const ServiceEntity(
      this.id,
      this.serviceId,
      this.name,
      this.type,
      this.color,
      this.tokenConfirm,
      this.print,
      this.status,
      this.departmentId,
      this.mainServiceId,
      this.displayName,
      this.askNameForWalkin,
      this.nameIsRequiredForWalkin,
      this.askEmailForWalkin,
      this.emailIsRequiredForWalkin,
      this.askNameForAppt,
      this.nameIsRequiredForAppt,
      this.askEmailForAppt,
      this.emailIsRequiredForAppt,
      this.appointmentDetails,
      this.walkinDetails,
      this.isHold,
      this.remarks);

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
        appointmentDetails,
        walkinDetails,
        isHold,
        remarks
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': id,
      'name': name,
      'type': type,
      'color': color,
      'token_confirm': tokenConfirm,
      'print': print,
      'status': status,
      'department_id': departmentId,
      'mainService_id': mainServiceId,
      'display_name': displayName,
      "ask_name_for_walkin": askNameForWalkin,
      "name_is_required_for_walkin": nameIsRequiredForWalkin,
      "ask_email_for_walkin": askEmailForWalkin,
      "email_is_required_for_walkin": emailIsRequiredForWalkin,
      "ask_name_for_appt": askNameForAppt,
      "name_is_required_for_appt": nameIsRequiredForAppt,
      "ask_email_for_appt": askEmailForAppt,
      "email_is_required_for_appt": emailIsRequiredForAppt,
      'appointment_details': appointmentDetails,
      'walkin_details': walkinDetails,
      'is_hold': isHold,
      'remarks': remarks
    };
  }

  static ServiceEntity fromJson(Map<String, dynamic> json) {
    return ServiceEntity(
        json['id'],
        json['service_id'] is String
            ? int.parse(json['service_id'])
            : json['service_id'] ?? json['id'],
        _serviceTranslations(json, 'name') ??
            _serviceTranslations(json['service'], 'name') ??
            '',
        json['type'] ?? json['service']['type'] ?? 'simple',
        json['color'],
        json['token_confirm'] is String &&
                (json['token_confirm'] == '1' ||
                    json['token_confirm'].toString().toLowerCase() == 'true')
            ? true
            : json['token_confirm'] is String &&
                    (json['token_confirm'] == '0' ||
                        json['token_confirm'].toString().toLowerCase() ==
                            'false')
                ? false
                : json['token_confirm'] ?? false,
        json['print'] is String &&
                (json['print'] == '1' ||
                    json['print'].toString().toLowerCase() == 'true')
            ? true
            : json['print'] is String &&
                    (json['print'] == '0' ||
                        json['print'].toString().toLowerCase() == 'false')
                ? false
                : json['print'] ?? false,
        json['status'] is String &&
                (json['status'] == '1' ||
                    json['status'].toString().toLowerCase() == 'true')
            ? true
            : json['status'] is String &&
                    (json['status'] == '0' ||
                        json['status'].toString().toLowerCase() == 'false')
                ? false
                : json['status'] ?? false,
        json['service'] != null
            ? json['service']['department_id'] ?? json['department_id']
            : json['department_id'],
        json['mainService_id'],
        _serviceTranslations(json, 'display_name') ??
            json['name'] ??
            json['service']['display_name'] ??
            json['service']['name'] ??
            '',
        json['ask_name_for_walkin'] is String &&
                (json['ask_name_for_walkin'] == '1' ||
                    json['ask_name_for_walkin'].toString().toLowerCase() ==
                        'true')
            ? true
            : json['ask_name_for_walkin'] is String &&
                    (json['ask_name_for_walkin'] == '0' ||
                        json['ask_name_for_walkin'].toString().toLowerCase() ==
                            'false')
                ? false
                : json["ask_name_for_walkin"] ?? false,
        json['name_is_required_for_walkin'] is String &&
                (json['name_is_required_for_walkin'] == '1' ||
                    json['name_is_required_for_walkin'].toString().toLowerCase() ==
                        'true')
            ? true
            : json['name_is_required_for_walkin'] is String &&
                    (json['name_is_required_for_walkin'] == '0' ||
                        json['name_is_required_for_walkin'].toString().toLowerCase() ==
                            'false')
                ? false
                : json["name_is_required_for_walkin"] ?? false,
        json['ask_email_for_walkin'] is String &&
                (json['ask_email_for_walkin'] == '1' ||
                    json['ask_email_for_walkin'].toString().toLowerCase() ==
                        'true')
            ? true
            : json['ask_email_for_walkin'] is String &&
                    (json['ask_email_for_walkin'] == '0' ||
                        json['ask_email_for_walkin'].toString().toLowerCase() ==
                            'false')
                ? false
                : json["ask_email_for_walkin"] ?? false,
        json['email_is_required_for_walkin'] is String &&
                (json['email_is_required_for_walkin'] == '1' ||
                    json['email_is_required_for_walkin'].toString().toLowerCase() ==
                        'true')
            ? true
            : json['email_is_required_for_walkin'] is String &&
                    (json['email_is_required_for_walkin'] == '0' ||
                        json['email_is_required_for_walkin'].toString().toLowerCase() ==
                            'false')
                ? false
                : json["email_is_required_for_walkin"] ?? false,
        json['ask_name'] is String &&
                (json['ask_name'] == '1' ||
                    json['ask_name'].toString().toLowerCase() == 'true')
            ? true
            : json['ask_name'] is String &&
                    (json['ask_name'] == '0' ||
                        json['ask_name'].toString().toLowerCase() == 'false')
                ? false
                : json["ask_name"] ?? false,
        json['name_is_required'] is String &&
                (json['name_is_required'] == '1' ||
                    json['name_is_required'].toString().toLowerCase() == 'true')
            ? true
            : json['name_is_required'] is String &&
                    (json['name_is_required'] == '0' ||
                        json['name_is_required'].toString().toLowerCase() == 'false')
                ? false
                : json["name_is_required"] ?? false,
        json['ask_email'] is String && (json['ask_email'] == '1' || json['ask_email'].toString().toLowerCase() == 'true')
            ? true
            : json['ask_email'] is String && (json['ask_email'] == '0' || json['ask_email'].toString().toLowerCase() == 'false')
                ? false
                : json["ask_email"] ?? false,
        json['email_is_required'] is String && (json['email_is_required'] == '1' || json['email_is_required'].toString().toLowerCase() == 'true')
            ? true
            : json['email_is_required'] is String && (json['email_is_required'] == '0' || json['email_is_required'].toString().toLowerCase() == 'false')
                ? false
                : json["email_is_required"] ?? false,
        json['service'] != null ? json['service']['appointment_details'] : json['appointment_details'],
        json['walkin_details'],
        json['is_hold'] ?? false,
        json['remarks']);
  }

  static List<ServiceEntity> fromJsonList(List<dynamic> jsonList) {
    List<ServiceEntity> list = [];
    for (var item in jsonList) {
      ServiceEntity _service = fromJson(item);
      list.add(_service);
    }
    return list;
  }

  static _serviceTranslations(service, property) {
    final Map<String, dynamic>? trans = service['translations'].firstWhere(
        (e) => e['language']['code'] == LanguageService.languageCode,
        orElse: () => null);
    if (trans != null && trans.isNotEmpty) {
      if (trans[property] != null && trans[property].isNotEmpty) {
        return trans[property];
      } else if (trans['name'] != null && trans['name'].isNotEmpty) {
        return trans['name'];
      }
    }

    if (service[property] != null && service[property].isNotEmpty) {
      return service[property];
    }
    return service['name'];
  }
}
