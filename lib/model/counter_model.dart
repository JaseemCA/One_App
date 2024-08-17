import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/counter_entity.dart';

class CounterModel extends Equatable {
  final int id;
  final String name;
  final bool status;
  final String displayName;
  final String voiceReadOut;
  final bool isHold;

  const CounterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.displayName,
    required this.voiceReadOut,
    required this.isHold,
  });

  static CounterModel fromEntity(CounterEntity entity) {
    return CounterModel(
      id: entity.id,
      name: entity.name,
      status: entity.status,
      displayName: entity.displayName,
      voiceReadOut: entity.voiceReadOut,
      isHold: entity.isHold,
    );
  }

  static CounterModel fromJson(Map<String, dynamic> json) {
    return CounterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      displayName: json['displayName'],
      voiceReadOut: json['voiceReadOut'],
      isHold: json['isHold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'displayName': displayName,
      'voiceReadOut': voiceReadOut,
      'isHold': isHold,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        displayName,
        voiceReadOut,
        isHold,
      ];
}
