import 'package:equatable/equatable.dart';
import 'package:oneappcounter/model/counter_model.dart';
import 'package:oneappcounter/model/counter_settings_model.dart';
import 'package:oneappcounter/model/service_model.dart';

class ServiceCounterTabModel extends Equatable {
  final List<ServiceModel> services;
  final CounterModel counter;
  final CounterSettingsModel counterSettings;
  final bool selected;
  final String serviceString;
  final String counterString;

  const ServiceCounterTabModel({
    required this.services,
    required this.counter,
    required this.counterSettings,
    required this.selected,
    required this.serviceString,
    required this.counterString,
  });

  static ServiceCounterTabModel fromJson(Map<String, dynamic> json) {
    List<ServiceModel> servicesList = [];
    for (var value in (json['services'] as List<dynamic>)) {
      servicesList.add(ServiceModel.fromJson(value as Map<String, dynamic>));
    }

    return ServiceCounterTabModel(
      services: servicesList,
      counter: CounterModel.fromJson(json['counter']),
      counterSettings: CounterSettingsModel.fromJson(json['counterSettings']),
      selected: json['selected'],
      serviceString: json['serviceString'],
      counterString: json['counterString'],
    );
  }

  Map<String, dynamic> toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Map<String, dynamic>> _services =
        services.map((e) => e.toJson()).toList();
    return {
      'services': _services,
      'counter': counter.toJson(),
      'counterSettings': counterSettings.toJson(),
      'selected': selected,
      'serviceString': serviceString,
      'counterString': counterString,
    };
  }

  @override
  List<Object?> get props => [
        services,
        counter,
        selected,
        serviceString,
        counterString,
      ];
}
