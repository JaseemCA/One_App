import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final int id;
  final String name;
  final String callingCode;
  final String iso31662;

  const CountryEntity(
    this.id,
    this.name,
    this.callingCode,
    this.iso31662,
  );

  @override
  List<Object?> get props => [
        id,
        name,
        callingCode,
        iso31662,
      ];
  static CountryEntity fromJson(Map<String, dynamic> json) {
    return CountryEntity(
      json["id"],
      json["name"],
      json["calling_code"],
      json["iso_3166_2"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "calling_code": callingCode,
      "iso_3166_2": iso31662
    };
  }

  static List<CountryEntity> fromJson2List(List data) {
    List<CountryEntity> countries = [];
    for (Map<String, dynamic> item in data) {
      CountryEntity ce = fromJson(item);
      countries.add(ce);
    }
    return countries;
  }
}
