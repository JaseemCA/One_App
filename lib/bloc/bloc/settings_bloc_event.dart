import 'package:equatable/equatable.dart';

class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsEventUpdated extends SettingsEvent {
  final bool isCurrentPageIsTab;
  SettingsEventUpdated({this.isCurrentPageIsTab = false});
  @override
  List<Object?> get props => [isCurrentPageIsTab];
}

class HomePageSettingsChangedEvent extends SettingsEvent {
  @override
  List<Object?> get props => [];
}

class SwitchToHomePageEvent extends SettingsEvent {
  @override
  List<Object?> get props => [];
}
