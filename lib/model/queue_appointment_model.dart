import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/queue_appointments_entity.dart';

class QueueAppointmentModel extends Equatable {
  final int appointmentId;
  final bool byReserved;
  final bool callable;
  final bool called;
  final dynamic call;
  final dynamic callingCode;
  final int callingOrderBy;
  final dynamic city;
  final bool concurrentTransferred;
  final dynamic country;
  final dynamic countryCode;
  final dynamic customer;
  final int? customerId;
  final String formattedCheckedAt;
  final String formattedDate;
  final String formattedTimeSlot;
  final int id;
  final bool isCancelled;
  final bool isConfirmed;
  final bool isTransferred;
  final String letter;
  final String? name;
  final String now;
  final int number;
  final String? phone;
  final String referenceNo;
  final bool? returnAfterTransferServices;
  final int serviceId;
  final String sortingValue;
  final String tokenNumber;
  final String transferReferenceNo;
  final dynamic transferServices;
  final dynamic transferServicesLabel;
  final int? transferStartId;
  final int? transferToId;
  final dynamic service;

  const QueueAppointmentModel({
    required this.appointmentId,
    required this.byReserved,
    required this.callable,
    required this.called,
    required this.call,
    required this.callingCode,
    required this.callingOrderBy,
    required this.city,
    required this.concurrentTransferred,
    required this.country,
    required this.countryCode,
    required this.customer,
    required this.customerId,
    required this.formattedCheckedAt,
    required this.formattedDate,
    required this.formattedTimeSlot,
    required this.id,
    required this.isCancelled,
    required this.isConfirmed,
    required this.isTransferred,
    required this.letter,
    required this.name,
    required this.now,
    required this.number,
    required this.phone,
    required this.referenceNo,
    required this.returnAfterTransferServices,
    required this.serviceId,
    required this.sortingValue,
    required this.tokenNumber,
    required this.transferReferenceNo,
    required this.transferServices,
    required this.transferServicesLabel,
    required this.transferStartId,
    required this.transferToId,
    required this.service,
  });

  static QueueAppointmentModel fromEntity(QueueAppointmentEntity entity) {
    return QueueAppointmentModel(
      appointmentId: entity.appointmentId,
      byReserved: entity.byReserved,
      callable: entity.callable,
      called: entity.called,
      call: entity.call,
      callingCode: entity.callingCode,
      callingOrderBy: entity.callingOrderBy,
      city: entity.city,
      concurrentTransferred: entity.concurrentTransferred,
      country: entity.country,
      countryCode: entity.countryCode,
      customer: entity.customer,
      customerId: entity.customerId,
      formattedCheckedAt: entity.formattedCheckedAt,
      formattedDate: entity.formattedDate,
      formattedTimeSlot: entity.formattedTimeSlot,
      id: entity.id,
      isCancelled: entity.isCancelled,
      isConfirmed: entity.isConfirmed,
      isTransferred: entity.isTransferred,
      letter: entity.letter,
      name: entity.name,
      now: entity.now,
      number: entity.number,
      phone: entity.phone,
      referenceNo: entity.referenceNo,
      returnAfterTransferServices: entity.returnAfterTransferServices,
      serviceId: entity.serviceId,
      sortingValue: entity.sortingValue,
      tokenNumber: entity.tokenNumber,
      transferReferenceNo: entity.transferReferenceNo,
      transferServices: entity.transferServices,
      transferServicesLabel: entity.transferServicesLabel,
      transferStartId: entity.transferStartId,
      transferToId: entity.transferToId,
      service: entity.service,
    );
  }

  static QueueAppointmentModel fromJson(Map<String, dynamic> json) {
    return QueueAppointmentModel(
      appointmentId: json['appointmentId'],
      byReserved: json['byReserved'],
      callable: json['callable'],
      called: json['called'],
      call: json['call'],
      callingCode: json['callingCode'],
      callingOrderBy: json['callingOrderBy'],
      city: json['city'],
      concurrentTransferred: json['concurrentTransferred'],
      country: json['country'],
      countryCode: json['countryCode'],
      customer: json['customer'],
      customerId: json['customerId'],
      formattedCheckedAt: json['formattedCheckedAt'],
      formattedDate: json['formattedDate'],
      formattedTimeSlot: json['formattedTimeSlot'],
      id: json['id'],
      isCancelled: json['isCancelled'],
      isConfirmed: json['isConfirmed'],
      isTransferred: json['isTransferred'],
      letter: json['letter'],
      name: json['name'],
      now: json['now'],
      number: json['number'],
      phone: json['phone'],
      referenceNo: json['referenceNo'],
      returnAfterTransferServices: json['returnAfterTransferServices'],
      serviceId: json['serviceId'],
      sortingValue: json['sortingValue'],
      tokenNumber: json['tokenNumber'],
      transferReferenceNo: json['transferReferenceNo'],
      transferServices: json['transferServices'],
      transferServicesLabel: json['transferServicesLabel'],
      transferStartId: json['transferStartId'],
      transferToId: json['transferToId'],
      service: json['service'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'byReserved': byReserved,
      'callable': callable,
      'called': called,
      'call': call,
      'callingCode': callingCode,
      'callingOrderBy': callingOrderBy,
      'city': city,
      'concurrentTransferred': concurrentTransferred,
      'country': country,
      'countryCode': countryCode,
      'customer': customer,
      'customerId': customerId,
      'formattedCheckedAt': formattedCheckedAt,
      'formattedDate': formattedDate,
      'formattedTimeSlot': formattedTimeSlot,
      'id': id,
      'isCancelled': isCancelled,
      'isConfirmed': isConfirmed,
      'isTransferred': isTransferred,
      'letter': letter,
      'name': name,
      'now': now,
      'number': number,
      'phone': phone,
      'referenceNo': referenceNo,
      'returnAfterTransferServices': returnAfterTransferServices,
      'serviceId': serviceId,
      'sortingValue': sortingValue,
      'tokenNumber': tokenNumber,
      'transferReferenceNo': transferReferenceNo,
      'transferServices': transferServices,
      'transferServicesLabel': transferServicesLabel,
      'transferStartId': transferStartId,
      'transferToId': transferToId,
      'service': service,
    };
  }

  @override
  List<Object?> get props => [
        appointmentId,
        byReserved,
        callable,
        called,
        call,
        callingCode,
        callingOrderBy,
        city,
        concurrentTransferred,
        country,
        countryCode,
        customer,
        customerId,
        formattedCheckedAt,
        formattedDate,
        formattedTimeSlot,
        id,
        isCancelled,
        isConfirmed,
        isTransferred,
        letter,
        name,
        now,
        number,
        phone,
        referenceNo,
        returnAfterTransferServices,
        serviceId,
        sortingValue,
        tokenNumber,
        transferReferenceNo,
        transferServices,
        transferServicesLabel,
        transferStartId,
        transferToId,
        service
      ];
}
