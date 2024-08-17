import 'package:equatable/equatable.dart';

class QueueAppointmentEntity extends Equatable {
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

  const QueueAppointmentEntity(
    this.appointmentId,
    this.byReserved,
    this.callable,
    this.called,
    this.call,
    this.callingCode,
    this.callingOrderBy,
    this.city,
    this.concurrentTransferred,
    this.country,
    this.countryCode,
    this.customer,
    this.customerId,
    this.formattedCheckedAt,
    this.formattedDate,
    this.formattedTimeSlot,
    this.id,
    this.isCancelled,
    this.isConfirmed,
    this.isTransferred,
    this.letter,
    this.name,
    this.now,
    this.number,
    this.phone,
    this.referenceNo,
    this.returnAfterTransferServices,
    this.serviceId,
    this.sortingValue,
    this.tokenNumber,
    this.transferReferenceNo,
    this.transferServices,
    this.transferServicesLabel,
    this.transferStartId,
    this.transferToId,
    this.service,
  );

  static QueueAppointmentEntity fromJson(Map<String, dynamic> json) {
    return QueueAppointmentEntity(
      json['appointment_id'],
      json['by_reserved'],
      json['callable'],
      json['called'] is int
          ? json['called'] == 1
              ? true
              : false
          : json['called'] ?? false,
      json['call'],
      json['calling_code'],
      json['calling_order_by'],
      json['city'],
      json['concurrent_transferred'] ?? false,
      json['country'],
      json['country_code'],
      json['customer'],
      json['customer_id'],
      json['formatted_checked_at'],
      json['formatted_date'],
      json['formatted_time_slot'],
      json['id'],
      json['is_cancelled'] is int
          ? json['is_cancelled'] == 1
              ? true
              : false
          : json['is_cancelled'] ?? false,
      json['is_confirmed'] is int
          ? json['is_confirmed'] == 1
              ? true
              : false
          : json['is_confirmed'] ?? false,
      json['is_transferred'] ?? false,
      json['letter'],
      json['name'] ??
              json['customer'] != null && json['customer']['name'] != null
          ? json['customer']['name']
          : null,
      json['now'],
      json['number'],
      // ignore: prefer_if_null_operators
      json['phone_with_calling_code'] != null
          ? json['phone_with_calling_code']
          : json['customer'] != null && json['customer']['phone'] != null
              ? '+${json['country_code']} ${json['customer']['phone']}'
              : null,
      json['reference_no'] is int
          ? json['reference_no'].toString()
          : json['reference_no'],
      json['return_after_transfer_services'],
      json['service_id'],
      json['sorting_value'],
      json['token_number'],
      json['transfer_reference_no'],
      json['transfer_services'],
      json['transfer_services_label'],
      json['transfer_start_id'],
      json['transfer_to_id'],
      json['service'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'by_reserved': byReserved,
      'callable': callable,
      'called': called,
      'call': call,
      'calling_code': callingCode,
      'calling_order_by': callingOrderBy,
      'city': city,
      'concurrent_transferred': concurrentTransferred,
      'country': country,
      'country_code': countryCode,
      'customer': customer,
      'customer_id': customerId,
      'formatted_checked_at': formattedCheckedAt,
      'formatted_date': formattedDate,
      'formatted_time_slot': formattedTimeSlot,
      'id': id,
      'is_cancelled': isCancelled,
      'is_confirmed': isConfirmed,
      'is_transferred': isTransferred,
      'letter': letter,
      'name': name,
      'now': now,
      'number': number,
      'phone_with_calling_code': phone,
      'reference_no': referenceNo,
      'return_after_transfer_services': returnAfterTransferServices,
      'service_id': serviceId,
      'sorting_value': sortingValue,
      'token_number': tokenNumber,
      'transfer_reference_no': transferReferenceNo,
      'transfer_services': transferServices,
      'transfer_services_label': transferServicesLabel,
      'transfer_start_id': transferStartId,
      'transfer_to_id': transferToId,
      'service': service
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
