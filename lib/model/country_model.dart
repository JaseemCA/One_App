import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/country_entity.dart';

class CountryModel extends Equatable {
  final int id;
  final String name;
  final String callingCode;
  final String iso31662;

  const CountryModel({
    required this.id,
    required this.name,
    required this.callingCode,
    required this.iso31662,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        callingCode,
        iso31662,
      ];

  static CountryModel fromEntity(CountryEntity entity) {
    return CountryModel(
      id: entity.id,
      name: entity.name,
      callingCode: entity.callingCode,
      iso31662: entity.iso31662,
    );
  }

  static CountryModel fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      name: json['name'],
      callingCode: json['callingCode'],
      iso31662: json['iso31662'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'callingCode': callingCode,
      'iso31662': iso31662,
    };
  }
}
