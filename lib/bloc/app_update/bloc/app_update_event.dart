import 'package:equatable/equatable.dart';

abstract class AppUpdateEvent extends Equatable {
  const AppUpdateEvent();

  @override
  List<Object> get props => [];
}

class CheckForUpdate extends AppUpdateEvent {}
