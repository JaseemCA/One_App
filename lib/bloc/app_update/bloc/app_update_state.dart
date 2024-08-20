import 'package:equatable/equatable.dart';
import 'package:in_app_update/in_app_update.dart';

abstract class AppUpdateState extends Equatable {
  const AppUpdateState();

  @override
  List<Object> get props => [];
}

class AppUpdateChecking extends AppUpdateState {}

class AppUpdateAvailable extends AppUpdateState {
  final AppUpdateInfo appUpdateInfo;

  const AppUpdateAvailable(this.appUpdateInfo);

  @override
  List<Object> get props => [appUpdateInfo];
}

class AppUpdateCheckFailed extends AppUpdateState {}
