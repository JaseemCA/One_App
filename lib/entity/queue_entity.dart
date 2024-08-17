import 'package:equatable/equatable.dart';

class QueueEntity extends Equatable {
  final bool byTransfer;
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
  final bool directTransferred;
  final String formattedCheckedAt;
  final String formattedDate;
  final String formattedTime;
  final dynamic holdAt;
  final int id;
  final bool isCancelled;
  final bool isConfirmed;
  final bool isHold;
  final bool isTransferred;
  final String letter;
  final dynamic multiTransferReferenceNo;
  final String? name;
  final String now;
  final int number;
  final String? phone;
  final int position;
  final int priority;
  final String priorityLabel;
  final String referenceNo;
  final bool? returnAfterTransferServices;
  final dynamic service;
  final int serviceId;
  final String sortingValue;
  final String tokenNumber;
  final bool? transferCallableAt;
  final int? transferFromId;
  final dynamic transferFromTable;
  final String transferReferenceNo;
  final dynamic transferServices;
  final dynamic transferServicesLabel;
  final int? transferStartId;
  final int? transferToId;
  final String transferToTable;
  final String type;
  final String? unHoldAt;
  final String waitingTime;

  const QueueEntity(
    this.byTransfer,
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
    this.directTransferred,
    this.formattedCheckedAt,
    this.formattedDate,
    this.formattedTime,
    this.holdAt,
    this.id,
    this.isCancelled,
    this.isConfirmed,
    this.isHold,
    this.isTransferred,
    this.letter,
    this.multiTransferReferenceNo,
    this.name,
    this.now,
    this.number,
    this.phone,
    this.position,
    this.priority,
    this.priorityLabel,
    this.referenceNo,
    this.returnAfterTransferServices,
    this.service,
    this.serviceId,
    this.sortingValue,
    this.tokenNumber,
    this.transferCallableAt,
    this.transferFromId,
    this.transferFromTable,
    this.transferReferenceNo,
    this.transferServices,
    this.transferServicesLabel,
    this.transferStartId,
    this.transferToId,
    this.transferToTable,
    this.type,
    this.unHoldAt,
    this.waitingTime,
  );

  static QueueEntity fromJson(Map<String, dynamic> json) {
    return QueueEntity(
      json['by_transfer'] is int
          ? json['by_transfer'] == 0
              ? false
              : true
          : json['by_transfer'] ?? false,
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
      json['direct_transferred'] ?? false,
      json['formatted_checked_at'],
      json['formatted_date'],
      json['formatted_time'] ?? '',
      json['hold_at'],
      json['id'],
      json['is_cancelled'] == 1 || json['is_cancelled'] == true ? true : false,
      json['is_confirmed'] is int
          ? json['is_confirmed'] == 1
              ? true
              : false
          : json['is_confirmed'] ?? false,
      json['is_hold'] ?? false,
      json['is_transferred'] is int
          ? json['is_transferred'] == 1
              ? true
              : false
          : json['is_transferred'] ?? false,
      json['letter'],
      json['multi_transfer_reference_no'],
      json['name'],
      json['now'],
      json['number'] is String ? int.parse(json['number']) : json['number'],
      json['phone'] != null && json['phone'].toString().isNotEmpty
          ? "+${json['calling_code']} ${json['phone']}"
          : null,
      json['position'],
      json['priority'] is String
          ? int.parse(json['priority'])
          : json['priority'],
      json['priority_label'],
      json['reference_no'] is int
          ? json['reference_no'].toString()
          : json['reference_no'],
      json['return_after_transfer_services'],
      json['service'],
      json['service_id'],
      json['sorting_value'],
      json['token_number'],
      json['transfer_callable_at'],
      json['transfer_from_id'],
      json['transfer_from_table'],
      json['transfer_reference_no'],
      json['transfer_services'],
      json['transfer_services_label'],
      json['transfer_start_id'],
      json['transfer_to_id'],
      json['transfer_to_table'] ?? '',
      json['type'],
      json['un_hold_at'],
      json['waiting_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'by_transfer': byTransfer,
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
      'direct_transferred': directTransferred,
      'formatted_checked_at': formattedCheckedAt,
      'formatted_date': formattedDate,
      'formatted_time': formattedTime,
      'hold_at': holdAt,
      'id': id,
      'is_cancelled': isCancelled,
      'is_confirmed': isConfirmed,
      'is_hold': isHold,
      'is_transferred': isTransferred,
      'letter': letter,
      'multi_transfer_reference_no': multiTransferReferenceNo,
      'name': name,
      'now': now,
      'number': number,
      'phone': phone,
      'position': position,
      'priority': priority,
      'priority_label': priorityLabel,
      'reference_no': referenceNo,
      'return_after_transfer_services': returnAfterTransferServices,
      'service': service,
      'service_id': serviceId,
      'sorting_value': sortingValue,
      'token_number': tokenNumber,
      'transfer_callable_at': transferCallableAt,
      'transfer_from_id': transferFromId,
      'transfer_from_table': transferFromTable,
      'transfer_reference_no': transferReferenceNo,
      'transfer_services': transferServices,
      'transfer_services_label': transferServicesLabel,
      'transfer_start_id': transferStartId,
      'transfer_to_id': transferToId,
      'transfer_to_table': transferToTable,
      'type': type,
      'un_hold_at': unHoldAt,
      'waiting_time': waitingTime,
    };
  }

  @override
  List<Object?> get props => [
        byTransfer,
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
        directTransferred,
        formattedCheckedAt,
        formattedDate,
        formattedTime,
        holdAt,
        id,
        isCancelled,
        isConfirmed,
        isHold,
        isTransferred,
        letter,
        multiTransferReferenceNo,
        name,
        now,
        number,
        phone,
        position,
        priority,
        priorityLabel,
        referenceNo,
        returnAfterTransferServices,
        service,
        serviceId,
        sortingValue,
        tokenNumber,
        transferCallableAt,
        transferFromId,
        transferFromTable,
        transferReferenceNo,
        transferServices,
        transferServicesLabel,
        transferStartId,
        transferToId,
        transferToTable,
        type,
        unHoldAt,
        waitingTime,
      ];
}
