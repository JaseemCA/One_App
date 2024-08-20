import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsStateInit extends SettingsState {
  @override
  List<Object?> get props => [];
}

class SettingsStateUpdating extends SettingsState {
  @override
  List<Object?> get props => [];
}

class SettingsStateUpdated extends SettingsState {
  final bool isServiceTabPage;
  SettingsStateUpdated({this.isServiceTabPage = false});
  @override
  List<Object?> get props => [isServiceTabPage];
}

class HomePageSettingsState extends SettingsState {
  @override
  List<Object?> get props => [];
}

class SwitchToHomePageState extends SettingsState {
  @override
  List<Object?> get props => [];
}
