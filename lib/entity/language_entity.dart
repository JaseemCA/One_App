import 'package:equatable/equatable.dart';

class LanguageEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final String dir;
  final String nativeName;

  const LanguageEntity(
    this.id,
    this.code,
    this.name,
    this.dir,
    this.nativeName,
  );
  static LanguageEntity fromJson(Map<String, dynamic> json) {
    return LanguageEntity(
      json['id'],
      json['code'],
      json['name'],
      json['dir'],
      json['native_name'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        dir,
        nativeName,
      ];
}
