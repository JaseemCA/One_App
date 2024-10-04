import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/language_entity.dart';

class LanguageModel extends Equatable {
  final int id;
  final String code;
  final String name;
  final String dir;
  final String nativeName;

  const LanguageModel({
    required this.id,
    required this.code,
    required this.name,
    required this.dir,
    required this.nativeName,
  });
  static LanguageModel fromEntity(LanguageEntity entity) {
    return LanguageModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      dir: entity.dir,
      nativeName: entity.nativeName,
    );
  }

  Map<String, dynamic> toJsonEntity() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "dir": dir,
      "native_name": nativeName
    };
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
