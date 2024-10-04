import 'package:equatable/equatable.dart';

class CallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CallInit extends CallState {}

class CallNextTokenStartedState extends CallState {}

class CallNextTokenCompletedState extends CallState {}
 