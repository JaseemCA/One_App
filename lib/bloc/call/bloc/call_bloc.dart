import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/call/bloc/call_event.dart';
import 'package:oneappcounter/bloc/call/bloc/call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallInit()) {
    on<CallNextTokenEvent>(_mapCallNextTokenEvent);
  }
  _mapCallNextTokenEvent(CallNextTokenEvent event, Emitter emit) {
    emit(CallInit());
    emit(CallNextTokenStartedState());
    emit(CallNextTokenCompletedState());
  }
}
