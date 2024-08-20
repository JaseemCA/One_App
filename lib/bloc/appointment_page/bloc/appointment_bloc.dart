
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_event.dart';
import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_state.dart';

class AppointmentPageBloc
    extends Bloc<AppointmentPageEvent, AppointmentPageState> {
  AppointmentPageBloc() : super(RebuildAppointPageInitState()) {
    on<RebuildAllTabEvent>(_mapRebuildAppointmentPage);
  }

  _mapRebuildAppointmentPage(RebuildAllTabEvent event, Emitter emit) {
    emit(RebuildAppointPageInitState());
    emit(ReBuildBothTab());
  }
}
