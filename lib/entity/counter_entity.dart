import 'package:equatable/equatable.dart';

class CounterEntity extends Equatable {
  final int id;
  final String name;
  final bool status;
  final String displayName;
  final String voiceReadOut;
  final bool isHold;

  const CounterEntity(
    this.id,
    this.name,
    this.status,
    this.displayName,
    this.voiceReadOut,
    this.isHold,
  );

  static CounterEntity fromJson(Map<String, dynamic> json) {
    return CounterEntity(
      json['id'],
      json['name'],
      json['status'],
      json['display_name'] ?? json['name'],
      json['voice_read_out'] ?? '',
      json['is_hold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'display_name': displayName,
      'voice_read_out': voiceReadOut,
      'is_hold': isHold
    };
  }

  static List<CounterEntity> fromJsonList(List<dynamic> jsonList) {
    List<CounterEntity> list = [];
    for (var item in jsonList) {
      CounterEntity service = fromJson(item);
      list.add(service);
    }
    return list;
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
