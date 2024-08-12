import 'package:equatable/equatable.dart';

abstract class BranchDomainState extends Equatable {
  const BranchDomainState();

  @override
  List<Object> get props => [];
}

class BranchDomainInitial extends BranchDomainState {}

class BranchDomainValid extends BranchDomainState {
  final String domain;

  const BranchDomainValid(this.domain);

  @override
  List<Object> get props => [domain];
}

class BranchDomainLoading extends BranchDomainState {}

class BranchDomainSubmitted extends BranchDomainState {}
class BranchDomainError extends BranchDomainState {
  final String message;

  const BranchDomainError(this.message);

  @override
  List<Object> get props => [message];
}