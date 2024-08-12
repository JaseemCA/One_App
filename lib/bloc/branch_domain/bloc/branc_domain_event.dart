import 'package:equatable/equatable.dart';

abstract class BranchDomainEvent extends Equatable {
  const BranchDomainEvent();

  @override
  List<Object> get props => [];
}

class DomainUpdated extends BranchDomainEvent {
  final String domain;

  const DomainUpdated(this.domain);

  @override
  List<Object> get props => [domain];
}

class SubmitDomain extends BranchDomainEvent {
  final String domain;

  const SubmitDomain(this.domain);

  @override
  List<Object> get props => [domain];
}
