
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_event.dart';
import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_state.dart';

class TokenPageBloc extends Bloc<TokenPageEvent, TokenPageState> {
  TokenPageBloc() : super(RebuildInitState()) {
    on<RebuildToCallEvent>(_mapRebuildToCall);
    on<RebuildCalledEvent>(_mapRebuildCalled);
    on<RebuildHoldedTokenEvent>(_mapRebuildHoldedToken);
    on<RebuildCancelledEvent>(_mapRebuildCancelled);
    on<RebuildHoldedQueueEvent>(_mapRebuildHoldedQueue);
  }
  _mapRebuildToCall(RebuildToCallEvent event, Emitter emit) {
    emit(RebuildInitState());
    emit(RebuildToCallTabState());
  }

  _mapRebuildCalled(RebuildCalledEvent event, Emitter emit) {
    emit(RebuildInitState());
    emit(RebuildCalledTabState());
  }

  _mapRebuildHoldedToken(RebuildHoldedTokenEvent event, Emitter emit) {
    emit(RebuildInitState());
    emit(RebuildHoldedTokenState());
  }

  _mapRebuildCancelled(RebuildCancelledEvent event, Emitter emit) {
    emit(RebuildInitState());
    emit(RebuildCancelledState());
  }

  _mapRebuildHoldedQueue(RebuildHoldedQueueEvent event, Emitter emit) {
    emit(RebuildInitState());
    emit(RebuildHoldedQueueState());
  }
}
