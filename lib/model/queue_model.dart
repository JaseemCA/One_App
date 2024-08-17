import 'package:equatable/equatable.dart';

import 'package:oneappcounter/entity/queue_entity.dart';

class QueueModel extends Equatable {
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

  const QueueModel({
    required this.byTransfer,
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
    required this.directTransferred,
    required this.formattedCheckedAt,
    required this.formattedDate,
    required this.formattedTime,
    required this.holdAt,
    required this.id,
    required this.isCancelled,
    required this.isConfirmed,
    required this.isHold,
    required this.isTransferred,
    required this.letter,
    required this.multiTransferReferenceNo,
    required this.name,
    required this.now,
    required this.number,
    required this.phone,
    required this.position,
    required this.priority,
    required this.priorityLabel,
    required this.referenceNo,
    required this.returnAfterTransferServices,
    required this.service,
    required this.serviceId,
    required this.sortingValue,
    required this.tokenNumber,
    required this.transferCallableAt,
    required this.transferFromId,
    required this.transferFromTable,
    required this.transferReferenceNo,
    required this.transferServices,
    required this.transferServicesLabel,
    required this.transferStartId,
    required this.transferToId,
    required this.transferToTable,
    required this.type,
    required this.unHoldAt,
    required this.waitingTime,
  });

  static QueueModel fromEntity(QueueEntity entity) {
    return QueueModel(
      byTransfer: entity.byTransfer,
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
      directTransferred: entity.directTransferred,
      formattedCheckedAt: entity.formattedCheckedAt,
      formattedDate: entity.formattedDate,
      formattedTime: entity.formattedTime,
      holdAt: entity.holdAt,
      id: entity.id,
      isCancelled: entity.isCancelled,
      isConfirmed: entity.isConfirmed,
      isHold: entity.isHold,
      isTransferred: entity.isTransferred,
      letter: entity.letter,
      multiTransferReferenceNo: entity.multiTransferReferenceNo,
      name: entity.name,
      now: entity.now,
      number: entity.number,
      phone: entity.phone,
      position: entity.position,
      priority: entity.priority,
      priorityLabel: entity.priorityLabel,
      referenceNo: entity.referenceNo,
      returnAfterTransferServices: entity.returnAfterTransferServices,
      service: entity.service,
      serviceId: entity.serviceId,
      sortingValue: entity.sortingValue,
      tokenNumber: entity.tokenNumber,
      transferCallableAt: entity.transferCallableAt,
      transferFromId: entity.transferFromId,
      transferFromTable: entity.transferFromTable,
      transferReferenceNo: entity.transferReferenceNo,
      transferServices: entity.transferServices,
      transferServicesLabel: entity.transferServicesLabel,
      transferStartId: entity.transferStartId,
      transferToId: entity.transferToId,
      transferToTable: entity.transferToTable,
      type: entity.type,
      unHoldAt: entity.unHoldAt,
      waitingTime: entity.waitingTime,
    );
  }

  static QueueModel fromJson(Map<String, dynamic> json) {
    return QueueModel(
      byTransfer: json['byTransfer'],
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
      directTransferred: json['directTransferred'],
      formattedCheckedAt: json['formattedCheckedAt'],
      formattedDate: json['formattedDate'],
      formattedTime: json['formattedTime'],
      holdAt: json['holdAt'],
      id: json['id'],
      isCancelled: json['isCancelled'],
      isConfirmed: json['isConfirmed'],
      isHold: json['isHold'],
      isTransferred: json['isTransferred'],
      letter: json['letter'],
      multiTransferReferenceNo: json['multiTransferReferenceNo'],
      name: json['name'],
      now: json['now'],
      number: json['number'],
      phone: json['phone'],
      position: json['position'],
      priority: json['priority'],
      priorityLabel: json['priorityLabel'],
      referenceNo: json['referenceNo'],
      returnAfterTransferServices: json['returnAfterTransferServices'],
      service: json['service'],
      serviceId: json['serviceId'],
      sortingValue: json['sortingValue'],
      tokenNumber: json['tokenNumber'],
      transferCallableAt: json['transferCallableAt'],
      transferFromId: json['transferFromId'],
      transferFromTable: json['transferFromTable'],
      transferReferenceNo: json['transferReferenceNo'],
      transferServices: json['transferServices'],
      transferServicesLabel: json['transferServicesLabel'],
      transferStartId: json['transferStartId'],
      transferToId: json['transferToId'],
      transferToTable: json['transferToTable'],
      type: json['type'],
      unHoldAt: json['unHoldAt'],
      waitingTime: json['waitingTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'byTransfer': byTransfer,
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
      'directTransferred': directTransferred,
      'formattedCheckedAt': formattedCheckedAt,
      'formattedDate': formattedDate,
      'formattedTime': formattedTime,
      'holdAt': holdAt,
      'id': id,
      'isCancelled': isCancelled,
      'isConfirmed': isConfirmed,
      'isHold': isHold,
      'isTransferred': isTransferred,
      'letter': letter,
      'multiTransferReferenceNo': multiTransferReferenceNo,
      'name': name,
      'now': now,
      'number': number,
      'phone': phone,
      'position': position,
      'priority': priority,
      'priorityLabel': priorityLabel,
      'referenceNo': referenceNo,
      'returnAfterTransferServices': returnAfterTransferServices,
      'service': service,
      'serviceId': serviceId,
      'sortingValue': sortingValue,
      'tokenNumber': tokenNumber,
      'transferCallableAt': transferCallableAt,
      'transferFromId': transferFromId,
      'transferFromTable': transferFromTable,
      'transferReferenceNo': transferReferenceNo,
      'transferServices': transferServices,
      'transferServicesLabel': transferServicesLabel,
      'transferStartId': transferStartId,
      'transferToId': transferToId,
      'transferToTable': transferToTable,
      'type': type,
      'unHoldAt': unHoldAt,
      'waitingTime': waitingTime
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
