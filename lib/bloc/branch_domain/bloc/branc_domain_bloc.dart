import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_event.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_state.dart';
import 'package:oneappcounter/services/networking_service.dart';

class BranchDomainBloc extends Bloc<BranchDomainEvent, BranchDomainState> {
  BranchDomainBloc() : super(BranchDomainInitial()) {
    on<DomainUpdated>((event, emit) {
      emit(BranchDomainValid(event.domain));
    });

    on<SubmitDomain>((event, emit) async {
      emit(BranchDomainLoading());

      try {
        final response = await NetworkingService.postHttp(
          path: 'login',
          data: {'domain': event.domain},
        );

        if (response is Response && response.statusCode == 200) {
          emit(BranchDomainSubmitted());
        } else {
          emit(const BranchDomainError("Failed to submit domain"));
        }
      } catch (e) {
        emit(BranchDomainError("An error occurred: ${e.toString()}"));
      }
    });
  }
}
